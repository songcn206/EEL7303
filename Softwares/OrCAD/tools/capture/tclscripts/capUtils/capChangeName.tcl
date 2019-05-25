#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capNormalizeNames.tcl
#            contains OrCAD Capture Pdf print utlities
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4

package provide capNormalizeNames 1.0


namespace eval ::capNormalizeNames {
	namespace export NormalizeActiveDesign
}


proc ::capNormalizeNames::RegisterNormalizeNames { }  {
RegisterAction "_cdnNormalizeNetGroup"  "::capNormalizeNames::enable" "" "::capNetNamesCorrection::NormalizeActiveDesign" "" 
}

#::capNormalizeNames::RegisterNormalizeNetGroup

proc ::capNormalizeNames::enable { }  {
	return 1
}





proc ::capNormalizeNames::NormalizePages { pSchematic } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		::capNormalizeNames::NormalizePagePtrObjects $lPage
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}


proc ::capNormalizeNames::NormalizeSchematic { pDesign } {    
	 
	 set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
		::capNormalizeNames::NormalizePages $lObj
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
		
	return
}


proc ::capNormalizeNames::NormalizeActiveDesign {  } {    
	 
	set lMessage "---------------------------------------------------------------------------------"
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
				
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [$lSession GetActiveDesign]
	 if { $lDesign == $lNullObj} {
		set lError [DboTclHelper_sMakeCString "Active design not found"]
		DboState_WriteToSessionLog $lError
		puts [DboTclHelper_sGetConstCharPtr $lError]
		return
	 }
	 
	 
	::capNormalizeNames::NormalizeSchematic $lDesign
	 
	set lMessage "---------------------------------------------------------------------------------"
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
	
	return
}


proc ::capNormalizeNames::init { } {
	
}

proc ::capNormalizeNames::NormalizePagePtrObjects { pPage } {
	 #puts ::capNormalizeNames::NormalizePageEntry
	 
	 set lNullObj NULL
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [DboState]
	$pPage GetName $lName
	 
	#PartInsts
	set pPartInstsIter [$pPage NewPartInstsIter $lStatus]
	set pInst [$pPartInstsIter NextPartInst $lStatus]
	while {$pInst!=$lNullObj} {
	       ::capNormalizeNames::NormalizePart $pInst
	      set pInst [$pPartInstsIter NextPartInst $lStatus]
	}
	delete_DboPagePartInstsIter $pPartInstsIter
	
	#$pPage Connect;
	#$pPage CommitTransaction;
	
	$lStatus -delete
	
	#puts ::capNormalizeNames::NormalizePageExit
	return $pPage
}


proc ::capNormalizeNames::NormalizePart { pInst  }  {
	#puts ::capNormalizeNames::NormalizePartEntry
	set lNullObj NULL
	#set lName [DboTclHelper_sMakeCString]
	set lStatus [DboState]
	#$pInst GetName $lName
	
	#set lID [DboTclHelper_sGetConstCharPtr $lName]
	
	set lObj $pInst
	set pObject [$pInst GetObjectType]
	if {$pObject == $::DboBaseObject_DRAWN_INSTANCE}	{
	
		set pViewType [$pInst GetContentsViewType $lStatus]
		
		if { $pViewType == $::DboValue_SCHEMATIC_VIEW_TYPE } {
			set lName [DboTclHelper_sMakeCString]
			$pInst GetName $lName
			
			set lNameStr [DboTclHelper_sGetConstCharPtr $lName]
			
			set result [string map {" " "_"} $lNameStr]
			set result1 [string map {"!" "_"} $result]
			
			if { $result1 != $lNameStr } {
			
			set lMessage "$lNameStr hierarchical block name has been changed to  $result"
			set lMessageStr [DboTclHelper_sMakeCString $lMessage]
			DboState_WriteToSessionLog $lMessageStr
			}
					
			set lNewName [DboTclHelper_sMakeCString $result1]
			$pInst SetName $lNewName
		}
	
	}
	
	$lStatus -delete
	#puts ::capNormalizeNames::NormalizePartExit
	return $pInst
	
}


::capNormalizeNames::NormalizeActiveDesign
 
