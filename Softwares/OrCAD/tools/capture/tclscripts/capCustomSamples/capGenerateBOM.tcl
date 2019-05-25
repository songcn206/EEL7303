#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capGenerateBOMUtil.tcl
#            contains OrCAD Capture BOM generation utlities
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capGenerateBOMUtil 1.0

namespace eval ::capGenerateBOMUtil {
	variable mListPartNumbers [list]
	variable mListReferences [list]
	variable mListReferencesWithoutPartNumber [list]
	variable mFindNumber
	variable mPCBNumber
	variable mRevision
	variable mOutDir
	variable mOutSumFile
	variable mOutRefFile
	
	variable mActivePMDesign
	variable mDesignBaseName
	variable mDesignDir
	variable mInitialized
}

proc ::capGenerateBOMUtil::init { } {
	set ::capGenerateBOMUtil::mInitialized 0
	set ::capGenerateBOMUtil::mActivePMDesign 0
}

::capGenerateBOMUtil::init 


proc ::capGenerateBOMUtil::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capGenerateBOMUtil::getReference { pInstOcc } {
	
	set lName [DboTclHelper_sMakeCString]
	set lStatus [$pInstOcc GetReference $lName]
	set lInstOccRef [DboTclHelper_sGetConstCharPtr $lName]
	#puts [concat "Reference " $lInstOccRef]
	$lStatus -delete
	return $lInstOccRef
	
}

proc ::capGenerateBOMUtil::getPropertyValue { pDesign pInstOcc pPropertyName } {
	
	set lNullObj NULL
	set lValue $lNullObj
	
	set lPropName [DboTclHelper_sMakeCString $pPropertyName]
	set lPropValue [DboTclHelper_sMakeCString]
	
	set lStatus [DboState]
	set lPartInst [$pInstOcc GetPartInst $lStatus]
	
	# check if it has variant Part Number Property
	set lIsVariantInst 0
	if { [$pInstOcc IsVariantPropMapEmpty] == 0} {
		set lIsVariantInst 1
	} elseif { $lPartInst != $lNullObj && [$lPartInst IsVariantPropMapEmpty] == 0} {
		set lIsVariantInst 2
	}
	
	#puts [concat "lIsVariantInst is " $lIsVariantInst]
	
	if {$lIsVariantInst == 1 } {
		
		set lFindValue [$pInstOcc GetVariantProp $lPropName $lPropValue]
		
		if { $lFindValue == 1} {
			set lPropValueString [DboTclHelper_sGetConstCharPtr $lPropValue]
			set lDesignCISNotStuffedString [DboTclHelper_sGetConstCharPtr [$pDesign GetCISNotStuffedString]]
			
			if { $lPropValueString !=  $lDesignCISNotStuffedString} {
				set lValue $lPropValueString
				#puts [concat "Variant Part Number (Occurrence)" $lValue]
			}
		}
		
	} elseif {$lIsVariantInst == 2 } {
		
		set lFindValue [$lPartInst GetVariantProp $lPropName $lPropValue]
		
		if { $lFindValue == 1} {
			set lPropValueString [DboTclHelper_sGetConstCharPtr $lPropValue]
			set lDesignCISNotStuffedString [DboTclHelper_sGetConstCharPtr [$pDesign GetCISNotStuffedString]]
			
			if { $lPropValueString !=  $lDesignCISNotStuffedString} {
				set lValue $lPropValueString
				#puts [concat "Variant Part Number (Instance)" $lValue]
			}
		}
		
	} else {
		
		set lStatus [$pInstOcc GetEffectivePropStringValue $lPropName $lPropValue]
		if {[$lStatus OK] == 1} {
			set lValue [DboTclHelper_sGetConstCharPtr $lPropValue]
			#puts [concat "Part Number " $lValue]
		}
		$lStatus -delete
		
	}
	
	if { $lValue == ""} {
		set lValue $lNullObj
	}
	
	return $lValue
}

proc ::capGenerateBOMUtil::getPartNumber { pDesign pInstOcc } {
	
	return [::capGenerateBOMUtil::getPropertyValue $pDesign $pInstOcc "Part Number"]
}


proc ::capGenerateBOMUtil::getPrep { pDesign pInstOcc } {
	
	set lPrepValue [::capGenerateBOMUtil::getPropertyValue $pDesign $pInstOcc "Prep"]
	set lNullObj NULL
	if { $lPrepValue == $lNullObj} {
		set lPrepValue ""
	}
	return $lPrepValue
}


proc ::capGenerateBOMUtil::getPartNumberIndexInList { pPartNumber } {
	set lNumberOfParts [llength $::capGenerateBOMUtil::mListPartNumbers]
	
	for {set i 0} {$i<$lNumberOfParts} {incr i} {
	   set lPartData [lindex $::capGenerateBOMUtil::mListPartNumbers $i]
	   
	   set lPartNumberInList [lindex $lPartData 0]
	   
	   if { $lPartNumberInList == $pPartNumber} {
		return $i
	   }
	}
	
	return -1
}

proc  ::capGenerateBOMUtil::recordBOMData { pDesign pInstOcc } {
	set lStatus [DboState]
	set lIsPrimitive [$pInstOcc IsPrimitive $lStatus]
	$lStatus -delete
	
	set lName [DboTclHelper_sMakeCString]
	set lNullObj NULL
	
	if {$lIsPrimitive == 1} {
		# get reference
		set lReference [::capGenerateBOMUtil::getReference $pInstOcc]
			
		#get part number
		set lPartNumber [::capGenerateBOMUtil::getPartNumber $pDesign $pInstOcc]
		
		#get prep
		set lPrep [::capGenerateBOMUtil::getPrep $pDesign $pInstOcc]
		
		if { $lPartNumber == $lNullObj} {
			lappend ::capGenerateBOMUtil::mListReferencesWithoutPartNumber $lReference
		} else {
			set lReferenceIndex [lsearch $::capGenerateBOMUtil::mListReferences $lReference]
			if { $lReferenceIndex == -1} {
				lappend ::capGenerateBOMUtil::mListReferences $lReference
				
				set lPartNumberIndex [::capGenerateBOMUtil::getPartNumberIndexInList $lPartNumber]
				if { $lPartNumberIndex == -1} {
					lappend ::capGenerateBOMUtil::mListPartNumbers [list $lPartNumber $lReference $lPrep]
				} else {
					set lPartData [lindex $::capGenerateBOMUtil::mListPartNumbers $lPartNumberIndex]
					lappend lPartData $lReference $lPrep
					lset ::capGenerateBOMUtil::mListPartNumbers $lPartNumberIndex $lPartData
				}
			}
		}
	}
}

proc ::capGenerateBOMUtil::capEnumerateInstOccurrence { pDesign pInstOcc } {
	set lStatus [DboState]
	
	set lNullObj NULL
	
	set lInstOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_INSTS]
	$lInstOccIter Sort $lStatus
	set lChildOcc [$lInstOccIter NextOccurrence $lStatus]
	while { $lChildOcc!= $lNullObj} {
		set lId [$lChildOcc GetId $lStatus]
		
		#get the DboInstOccurrence pointer from DboOccurrence pointer
		set lInstOcc [DboOccurrenceToDboInstOccurrence $lChildOcc] 
		
		::capGenerateBOMUtil::recordBOMData $pDesign $lInstOcc
		
		set lOccId [$lInstOcc GetId $lStatus]
		
		::capGenerateBOMUtil::capEnumerateInstOccurrence $pDesign $lInstOcc
		
		set lChildOcc [$lInstOccIter NextOccurrence $lStatus]
	}
	delete_DboOccurrenceChildrenIter $lInstOccIter

	$lStatus -delete
}

proc ::capGenerateBOMUtil::capEnumerateOccurrences { pDesign } {
	set lStatus [DboState]
	set lRootOcc [$pDesign GetRootOccurrence $lStatus]
	
	set lName [DboTclHelper_sMakeCString]
	 set lStatus [$pDesign GetRootName $lName]	
	 
	::capGenerateBOMUtil::capEnumerateInstOccurrence $pDesign $lRootOcc
	
	$lStatus -delete
	return
}

proc ::capGenerateBOMUtil::sortDataOnLowestRefdes { } {
	set lNumberOfParts [llength $::capGenerateBOMUtil::mListPartNumbers]
	
	set lRefdesSortedList [list]
	
	#sort each part line individually based on the lowest refdes in that part line
	for {set i 0} {$i<$lNumberOfParts} {incr i} {
	   
	   set lPartData [lindex $::capGenerateBOMUtil::mListPartNumbers $i]
	   
	   # create a refdes list 
	   set lPartRefdesList [list]
	   
	   set lQuantity [expr "([llength $lPartData] -1)/2"]
	   
	   for {set j 0} {$j< $lQuantity} {incr j}  {
		
		set lRefdes [lindex $lPartData [expr "2*$j+1"]]
		set lPrep [lindex $lPartData [expr "2*$j+2"]]
		
		lappend lPartRefdesList [list $lRefdes $lPrep]
	    }
	    
	    #puts "Part refdes list is $lPartRefdesList"
	    
	    set lPartRefdesSortedList [lsort -dictionary -index 0 $lPartRefdesList]
	    
	    #puts "Part refdes sorted list is $lPartRefdesSortedList"
	    
	    # part name is the first data in each part list
	   set lPartName [lindex $lPartData 0]
	   
	    #now again flatten the part refdes sorted list and create a new list (with part number), that will be set in the master list
	    set lPartDataWithSortedRefdes [list $lPartName]
	    
	    set lNumberOfRefdes [llength $lPartRefdesSortedList]
	   
	   for {set k 0} {$k< $lNumberOfRefdes} {incr k}  {
		set lRefdesData [lindex $lPartRefdesSortedList $k]
		set lRefdes [lindex $lRefdesData 0]
		set lPrep [lindex $lRefdesData 1]
		
		lappend lPartDataWithSortedRefdes $lRefdes
		lappend lPartDataWithSortedRefdes $lPrep
	    }
	
	   lset ::capGenerateBOMUtil::mListPartNumbers $i $lPartDataWithSortedRefdes
	}
	
	#when all the part lines have their individual refdes data sorted, its time to make the complete list sorted based on the lowest refdes
	# that will be present on the 2nd position (index 1) of each line, 
	set lSortedListPartNumbersOnLowestRefdes [lsort -dictionary -index 1 $::capGenerateBOMUtil::mListPartNumbers]	
	set ::capGenerateBOMUtil::mListPartNumbers $lSortedListPartNumbersOnLowestRefdes
	return
}


proc ::capGenerateBOMUtil::writeDataToBOMFiles { } {
	set lSumFile [open $::capGenerateBOMUtil::mOutSumFile w]
	set lRefFile [open $::capGenerateBOMUtil::mOutRefFile w]
	
	::capGenerateBOMUtil::sortDataOnLowestRefdes
	
	set lNumberOfParts [llength $::capGenerateBOMUtil::mListPartNumbers]
	
	set lRefdesSortedList [list]
	
	for {set i 0} {$i<$lNumberOfParts} {incr i} {
	   
	   set lPartData [lindex $::capGenerateBOMUtil::mListPartNumbers $i]
	   
	   # part name is the first data in each part list
	   set lPartName [lindex $lPartData 0]
	   
	   # for every instance (refdes), we are storing 2 property values (refdes + prep), so total number of quantity is (list_length - 1 (for part name))/2 (number of data, i.e. properties per instance) 
	   set lQuantity [expr "([llength $lPartData] -1)/2"]
	   
	   # create a formatted find number, if it is less than 4 digits, make it 4 digits
	   set lFormattedFindNumber $::capGenerateBOMUtil::mFindNumber
	   if { $::capGenerateBOMUtil::mFindNumber < 10} {
	 	set lFormattedFindNumber 000
		append lFormattedFindNumber $::capGenerateBOMUtil::mFindNumber
	   } elseif { $::capGenerateBOMUtil::mFindNumber < 100} {
	 	set lFormattedFindNumber 00
		append lFormattedFindNumber $::capGenerateBOMUtil::mFindNumber
	   } elseif { $::capGenerateBOMUtil::mFindNumber < 1000} {
	 	set lFormattedFindNumber 0
		append lFormattedFindNumber $::capGenerateBOMUtil::mFindNumber
	   }
	
	   # create a line for writing into the sum file
	   #e.g. 0178,AW777-3410-390-003,2,,,,,,
	   set lLine $lFormattedFindNumber
	   append  lLine "," $lPartName "," $lQuantity ",,,,,,"
	   
	   # write the line to sum file
	   puts $lSumFile $lLine
	   
	   # create a list of alll lines with all required data
	   for {set j 0} {$j< $lQuantity} {incr j}  {
		
		set lRefdes [lindex $lPartData [expr "2*$j+1"]]
		set lPrep [lindex $lPartData [expr "2*$j+2"]]
		
		set lListLine [list]
		lappend lListLine  $::capGenerateBOMUtil::mPCBNumber $::capGenerateBOMUtil::mRevision $lFormattedFindNumber $lPartName $lRefdes $lPrep
		
		lappend lRefdesSortedList $lListLine
	   }
	   
	   # increment find number by 1
	   incr ::capGenerateBOMUtil::mFindNumber 
	}
	
	#sort the list based on the 5th data i.e. "Refdes" in each list line, 
	set lRefdesSortedList [lsort -dictionary -index 4 $lRefdesSortedList]
	set lCount [llength $lRefdesSortedList]
	
	#write data to the ref file
	for {set j 0} {$j<$lCount} {incr j} {
		
		set lListLine [lindex $lRefdesSortedList $j]
		
		#e.g. 312618-002;A;0100;AW777-3410-211-114;C1;;;
		set lPCBNumber [lindex $lListLine 0]
		set lRevision [lindex $lListLine 1]
		set lFormattedFindNumber [lindex $lListLine 2]
		set lPartName [lindex $lListLine 3]
		set lRefdes [lindex $lListLine 4]
		set lPrep [lindex $lListLine 5]
		
		set lLine $lPCBNumber
		append  lLine ";" $lRevision ";" $lFormattedFindNumber ";" $lPartName ";" $lRefdes ";" $lPrep ";;"
		
		#write the line to Ref file
		puts $lRefFile $lLine
	}

	
	#puts "closing the files"
	flush $lSumFile
	close $lSumFile
	flush $lRefFile
	close $lRefFile
	
	return
}

proc ::capGenerateBOMUtil::getDesignNameAttributes { } {
	
	catch {set lDesign [GetActivePMDesign]} lResult
	
	if {$lResult == 1} {
		set lMessage [concat "(::capGenerateBOMUtil::printGenerateBOM) " " Error : No active design"]
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
		return 0
	}
	
	if { $::capGenerateBOMUtil::mActivePMDesign != $lDesign} {
		set ::capGenerateBOMUtil::mInitialized 0
		set ::capGenerateBOMUtil::mActivePMDesign $lDesign
	 } else {
		return 1
	 }
	 
	 set lDesignName [DboTclHelper_sMakeCString]
	 $lDesign GetName $lDesignName
	 set lFilePath [DboTclHelper_sGetConstCharPtr $lDesignName]
	 set lFileSplitPath [file split $lFilePath]
	 set lFileName [file rootname [lindex $lFileSplitPath [expr [llength $lFileSplitPath] - 1]]]
	 
	 set ::capGenerateBOMUtil::mDesignBaseName $lFileName
	 set ::capGenerateBOMUtil::mDesignDir [file dirname [file normalize $lFilePath]]
	
	 return 1
}

proc ::capGenerateBOMUtil::setDefaultValues { } {
	 
	 set ::capGenerateBOMUtil::mFindNumber 100
	 set ::capGenerateBOMUtil::mPCBNumber "PCB"
	 set ::capGenerateBOMUtil::mRevision "A"
	 set ::capGenerateBOMUtil::mOutDir $::capGenerateBOMUtil::mDesignDir 
}

proc ::capGenerateBOMUtil::setOptionValues { } {
	
	set lResult [::capGenerateBOMUtil::getDesignNameAttributes]
	
	if { $lResult == 0 } {
		return 0
	}	
	
	if { $::capGenerateBOMUtil::mInitialized == 0 } {
		::capGenerateBOMUtil::setDefaultValues
	}
	
	set ::capGenerateBOMUtil::mFindNumber 100
	set ::capGenerateBOMUtil::mInitialized 1
	
	return 1
}


proc ::capGenerateBOMUtil::generateBOM { PCBNumber Revision FindNumberStartIndex } {    
	 
	set lResult [::capGenerateBOMUtil::setOptionValues]
	
	if { $lResult == 0 } {
		puts "Error"
		return
	}	 
	 set ::capGenerateBOMUtil::mListPartNumbers [::capGenerateBOMUtil::clearList $::capGenerateBOMUtil::mListPartNumbers]
	 set ::capGenerateBOMUtil::mListReferences [::capGenerateBOMUtil::clearList $::capGenerateBOMUtil::mListReferences]
	 set ::capGenerateBOMUtil::mListReferencesWithoutPartNumber [::capGenerateBOMUtil::clearList $::capGenerateBOMUtil::mListReferencesWithoutPartNumber]
	 
	 set ::capGenerateBOMUtil::mFindNumber $FindNumberStartIndex
	 set ::capGenerateBOMUtil::mPCBNumber $PCBNumber
	 set ::capGenerateBOMUtil::mRevision $Revision
	 set lSumFileName ""
	 append lSumFileName $::capGenerateBOMUtil::mPCBNumber "-" $::capGenerateBOMUtil::mRevision "-" "sum.txt"
	 set ::capGenerateBOMUtil::mOutSumFile [file join $::capGenerateBOMUtil::mOutDir $lSumFileName]
	 
	 set lRefFileName ""
	 append lRefFileName $::capGenerateBOMUtil::mPCBNumber "-" $::capGenerateBOMUtil::mRevision "-" "ref.txt"
	 set ::capGenerateBOMUtil::mOutRefFile [file join $::capGenerateBOMUtil::mOutDir $lRefFileName]
	 
	 ::capGenerateBOMUtil::capEnumerateOccurrences $::capGenerateBOMUtil::mActivePMDesign
	 	
	 ::capGenerateBOMUtil::writeDataToBOMFiles
	 
	 #puts "-----------"
	 #puts $::capGenerateBOMUtil::mListReferences
	 #puts "------Part List-------"
	 #puts $::capGenerateBOMUtil::mListPartNumbers
	 #puts "  "
	 puts "-----References without Part Numbers---" 
	 puts $::capGenerateBOMUtil::mListReferencesWithoutPartNumber 
	 puts "-----------" 
	 
	 puts [concat "BOM files ouput generated at " $::capGenerateBOMUtil::mOutSumFile " and " $::capGenerateBOMUtil::mOutRefFile]
	 puts "Generation of BOM Files completed successfully"
	 
	 catch {AddFileToOutputFolder $::capGenerateBOMUtil::mOutSumFile}
	 catch {AddFileToOutputFolder $::capGenerateBOMUtil::mOutRefFile}
	 
	 return
}

proc generateCustomBOM { {PCBNumber "312618-002"} {Revision "A"} {FindNumberStartIndex 100} } { 
	 ::capGenerateBOMUtil::generateBOM $PCBNumber $Revision $FindNumberStartIndex
}

# source D:/WorkData/Capture/dbcheck/capGenerateBOM.tcl
# ::capGenerateBOMUtil::generateBOM