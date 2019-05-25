#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCIS.tcl
#            contains OrCAD Capture CIS TCL data access sample
#
# Usage:
# 1. To Dump CIS Data
#		::capCIS::dump
#	
# 2. To Add Group 'G1','G2','G3'
#		set lGroup {"G1" "G2" "G3"}
#		::capCIS::AddGroups $lGroup
#
# 3. To Add SubGroup 'Sub1' in Group 'G1'
#		::capCIS::AddSubGroup {G1} {Sub1}
#
# 4. To Add Selected Parts on Schematic to Group G3
#		::capCIS::AddSchSelectedPartsToGroup {G3}
#
# 5. To Add Parts with Occurrence id '7513','6988' to Group G3
#		set lPartOccIdArr [CISTclHelper_sMakeCUIntArray]
#		CISTclHelper_sAddToCUIntArray $lPartOccIdArr 7513
#		CISTclHelper_sAddToCUIntArray $lPartOccIdArr 6988
#		::capCIS::AddPartsToGroup {G3} $lPartOccIdArr
#
# 6. To Add Variant
#		::capCIS::AddVariant {V3}
#
# 7. To Add Group G1 to a Variant V3
#		::capCIS::AddGroupToVariant {G1} {V3}
#
# 8. To Add SubGroup Sub1 from Group G1 to Variant V3
#		::capCIS::AddSubGroupToVariant {G1} {Sub1} {V3}
#
# 9. To Remove Group G1,G2
#		set lGroup {"G1" "G2"}
#		::capCIS::RemoveGroups $lGroup
#
# 10. To Remove SubGroup Sub1 from Group G1
#		::capCIS::RemoveSubGroup {G1} {Sub1}
#
# 11. To Remove Part from Group G1
#		::capCIS::RemoveSchSelectedPartsFromGroup G1
#
# 12. To Remove Parts with Occurrence id '7513','6988' from Group G3
#		set lPartOccIdArr [CISTclHelper_sMakeCUIntArray]
#		CISTclHelper_sAddToCUIntArray $lPartOccIdArr 7513
#		CISTclHelper_sAddToCUIntArray $lPartOccIdArr 6988
#		::capCIS::RemovePartsFromGroup {G3} $lPartOccIdArr
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capCISDump 1.0

namespace eval ::capCIS {
}

proc ::capCIS::dumpGroupPartData { pCISDesign pGroupContainer pGroupName pSubGroupName pPartId } {

	if { $pPartId == 0 } {
		return
	}
	
	set lNullObj NULL
	
	set lSubGroupNameStr [DboTclHelper_sGetConstCharPtr $pSubGroupName]
	set lGroupNameStr [DboTclHelper_sGetConstCharPtr $pGroupName]
	
	set lKeyStr $lGroupNameStr
	if { $lSubGroupNameStr != "" } {
		set lKeyStr [format "%s-%s" $lGroupNameStr $lSubGroupNameStr]
	}
	
	if { $pGroupContainer != $lNullObj } {
		if { $lSubGroupNameStr == "" } {
			set lIsStuffed [$pGroupContainer IsPartStuffedGroup $pGroupName [CISTclHelper_sGetUINTFromInt $pPartId]]
		} else {
			set lIsStuffed [$pGroupContainer IsPartStuffedSubGroup $pGroupName $pSubGroupName [CISTclHelper_sGetUINTFromInt $pPartId]]
		}
	}
	
	set lUINTPartId [CISTclHelper_sGetUINTFromInt $pPartId]
	set lCISInstOcc [$pCISDesign GetPartOccForID $lUINTPartId]
	
	if { $lCISInstOcc == $lNullObj } {
		return
	}
	
	set lRefDes [$lCISInstOcc GetPartRefDes]
	#puts $lRefDes;
	set lRefDes [$lRefDes GetRefDes]
	set lRefDes [DboTclHelper_sMakeCString $lRefDes]
	set lRefDesStr [DboTclHelper_sGetConstCharPtr $lRefDes]
	
	set lPresent ""
	
	if { $pGroupContainer != $lNullObj } {
		if { $lIsStuffed == 0 } {
			set lPresent "Not present" 
		} else {
			set lPresent "Present" 
		}
	}
	
	if { $lKeyStr == "Common" } {
		set lKey [DboTclHelper_sMakeCString]
	} else {
		set lKey [DboTclHelper_sMakeCString $lKeyStr]
	}
	
	set pOldVariant [DboTclHelper_sMakeCString]
	
	$pCISDesign GetActiveVariant $pOldVariant
	$pCISDesign SetActiveVariant $lKey
	
	
	set lCISPartInst [$lCISInstOcc GetOwningCISPartInst]
	set lPartStatus [DboTclHelper_sMakeCString]
	set lCaptureObjIdUINT [CISTclHelper_sGetUINTFromInt [$lCISInstOcc GetCaptureObjectId]]
	$lCISPartInst GetOccStatus $lCaptureObjIdUINT $lPartStatus $lKey
	set lPartStatusStr [DboTclHelper_sGetConstCharPtr $lPartStatus]
	
	if { $lPartStatusStr == "" } {
		set lPartNumberPropName [DboTclHelper_sMakeCString "Part Number"]
		set lPartNumber [$lCISInstOcc GetPartProp $lPartNumberPropName]
		set lPartNumberStr [DboTclHelper_sGetConstCharPtr $lPartNumber]
		
		if { $lPartNumberStr != "" } {
			set lPartRefPropName [DboTclHelper_sMakeCString "Part Reference"]
			set lPartRef [$lCISInstOcc GetPartProp $lPartRefPropName] 
			set lPartRefStr [DboTclHelper_sGetConstCharPtr $lPartRef]
			
			if { $lPartRefStr != "" } {
				set lPartStatusStr "APPROVED_DEFINED"
			} else {
				set lPartStatusStr "UNDEFINED"
			}
					
		}
	}
	
	if { $lPartStatusStr == "" } {
		set lPartStatusStr "UNDEFINED"
	}
	
	set lPartProps [CISTclHelper_sMakeCPartProp]
	$lCISInstOcc GetPartProps $lPartProps
	
	set lPropCount [$lPartProps GetSize]
	
	set lPropStr [list]
	for {set i 0} {$i<$lPropCount} {incr i} {
		set lPropName [$lPartProps GetName $i]
		set lPropValue [$lPartProps GetValue $i]
		set lPropNameStr [DboTclHelper_sGetConstCharPtr $lPropName]
		set lPropValueStr [DboTclHelper_sGetConstCharPtr $lPropValue]
		
		if { $lPropNameStr == "Part Number" } {
			set lPropStr [lappend lPropStr $lPropNameStr "=" $lPropValueStr]
		}
	}
	
	set lT [format "        %8s          :%-16s  :Status = %10s : %s" $lRefDesStr $lPresent $lPartStatusStr $lPropStr]
	puts $lT
	
	delete_CISInstOccurrence $lCISInstOcc
	
	$pCISDesign SetActiveVariant $pOldVariant
}


proc ::capCIS::dumpSubGroupPartData { pCISDesign pGroupContainer pGroupName pSubGroupName } {
	
	set lParts [CISTclHelper_sMakeCUIntArray]
	$pGroupContainer GetPartsFromSubGroup $pGroupName $pSubGroupName $lParts
	
	set lPartsCount [CISTclHelper_sGetCUIntArraySize $lParts]
	#puts "        Parts Count in subgroup is $lPartsCount"
	
	for {set i 0} {$i<$lPartsCount} {incr i} {
		set lPartId [CISTclHelper_sGetUInt $lParts $i]
		
		dumpGroupPartData $pCISDesign $pGroupContainer $pGroupName $pSubGroupName $lPartId
	}
}

proc ::capCIS::dumpSubGroup { pCISDesign pGroupContainer pGroupName } {
	
	set lSubGroupCount [$pGroupContainer GetSubGroupCount $pGroupName]
	puts "    Sub Group Count is $lSubGroupCount"
	
	for {set i 0} {$i<$lSubGroupCount} {incr i} {
		
		set lSubGroupName [$pGroupContainer GetSubGroupByIndex  $pGroupName $i]
		set lSubGroupNameStr [DboTclHelper_sGetConstCharPtr $lSubGroupName]
		puts "        .............................................."
		puts "        Sub Group Name is $lSubGroupNameStr" 
		dumpSubGroupPartData $pCISDesign $pGroupContainer $pGroupName $lSubGroupName
		puts "        .............................................."
	}
}

proc ::capCIS::dumpGroup { pCISDesign pGroupContainer pGroupName } {
	
	set lParts [CISTclHelper_sMakeCUIntArray]
	$pGroupContainer GetPartsFromGroup $pGroupName $lParts
	
	if { [$pGroupContainer IsGroupHasSubGroups $pGroupName] == 1} {
		dumpSubGroup $pCISDesign $pGroupContainer $pGroupName
	} else {
		set lPartsCount [CISTclHelper_sGetCUIntArraySize $lParts]
		#puts "    Parts Count in group is $lPartsCount"
		
		for {set i 0} {$i<$lPartsCount} {incr i} {
			set lPartId [CISTclHelper_sGetUInt $lParts $i]
			set lSubGroupName [DboTclHelper_sMakeCString ""]
			dumpGroupPartData $pCISDesign $pGroupContainer $pGroupName $lSubGroupName $lPartId
		}
	}
}

proc ::capCIS::dumpCommonGroup { pCISDesign } {
	
	set lParts [CISTclHelper_sMakeCUIntArray]
	$pCISDesign GetCommonParts $lParts
	
	set lPartsCount [CISTclHelper_sGetCUIntArraySize $lParts]
	#puts "    Parts Count in group is $lPartsCount"
		
	for {set i 0} {$i<$lPartsCount} {incr i} {
		set lPartId [CISTclHelper_sGetUInt $lParts $i]
		
		set lGroupName [DboTclHelper_sMakeCString "Common"]
		set lSubGroupName [DboTclHelper_sMakeCString ""]
		set lGroupContainer NULL
		
		dumpGroupPartData $pCISDesign $lGroupContainer $lGroupName $lSubGroupName $lPartId
	}
}

proc ::capCIS::dumpGroups { pCISDesign } {
	
	set lGroupContainer [$pCISDesign GetGroupsContainer]
	#puts "lGroupContainer is $lGroupContainer"
	
	puts "======================================================"
	puts " Common Group"
	dumpCommonGroup $pCISDesign
	puts "======================================================"
	
	set lGroupCount [$lGroupContainer GetGroupCount]
	puts "======================================================"
	puts " Group Count is $lGroupCount"

	for {set i 0} {$i<$lGroupCount} {incr i} {
		puts "  ----------------------------------------"
		set lGroupName [$lGroupContainer GetGroupByIndex $i]
		set lGroupNameStr [DboTclHelper_sGetConstCharPtr $lGroupName]
		puts " Group Name is $lGroupNameStr" 
		
		dumpGroup $pCISDesign $lGroupContainer $lGroupName
		puts "  ----------------------------------------"
	}
	puts "======================================================"
}


proc ::capCIS::getGroupNameStr { pGroupSubGroupNameStr } {
	set lList [split $pGroupSubGroupNameStr _]
	
	return [lindex $lList 0]
}

proc ::capCIS::getSubGroupNameStr { pGroupSubGroupNameStr } {
	set lList [split $pGroupSubGroupNameStr _]
	
	if { [llength $lList] > 1} {
		return [lindex $lList 1]
	} else {
		return ""
	}
}

proc ::capCIS::makeGroupSubGroupName { pGroupNameStr  pSubGroupNameStr } {
	if { $pSubGroupNameStr == ""} {
		return $pGroupNameStr
	} else {
		return [format "%s%s%s" $pGroupNameStr "-" $pSubGroupNameStr]
	}	
}

proc ::capCIS::dumpBOMVariantData { pCISDesign pGroupContainer pBOMVariantContainer pBOMVariantName } {
	
	set lBOMGroupsSubGroupsName [CISTclHelper_sMakeCStringArray]
	$pBOMVariantContainer GetBomGroups $pBOMVariantName $lBOMGroupsSubGroupsName
	
	set pBOMVariantNameStr [DboTclHelper_sGetConstCharPtr $pBOMVariantName]
	
	set lGroupSubGroupCount [CISTclHelper_sGetCStringArraySize $lBOMGroupsSubGroupsName]
	puts "    Number of member groups = $lGroupSubGroupCount"
	
	for {set i 0} {$i<$lGroupSubGroupCount} {incr i} {
		set lGroupSubGroupName [CISTclHelper_sGetCString $lBOMGroupsSubGroupsName $i]
		set lGroupSubGroupNameStr [DboTclHelper_sGetConstCharPtr $lGroupSubGroupName]
		
		set lGroupNameStr [::capCIS::getGroupNameStr $lGroupSubGroupNameStr]
		set lGroupName [DboTclHelper_sMakeCString $lGroupNameStr]
		
		set lSubGroupNameStr [::capCIS::getSubGroupNameStr $lGroupSubGroupNameStr]
		set lSubGroupName [DboTclHelper_sMakeCString $lSubGroupNameStr]
		
		set lFormattedGroupSubGroupNameStr [::capCIS::makeGroupSubGroupName $lGroupNameStr $lSubGroupNameStr]
		set lFormattedGroupSubGroupName [DboTclHelper_sMakeCString $lFormattedGroupSubGroupNameStr]
		
		puts "    Group/Subgroup name = $lGroupSubGroupNameStr (Formatted Name = $lFormattedGroupSubGroupNameStr)"
		
	}
}


proc ::capCIS::dumpBOMVariants { pCISDesign } { 
	set lGroupContainer [$pCISDesign GetGroupsContainer]
	#puts "lGroupContainer is $lGroupContainer"
	
	set lBOMVariantContainer [$pCISDesign GetBOMVariantContainer]
	#puts "lBOMVariantContainer is $lBOMVariantContainer"
	
	set lBOMVariantCount [$lBOMVariantContainer GetBomCount]
	puts "======================================================"
	puts "BOM Variant Count is $lBOMVariantCount"
	
	set lBOMVariantName [DboTclHelper_sMakeCString]
	
	for {set i 0} {$i<$lBOMVariantCount} {incr i} {
		puts "  ----------------------------------------"
		$lBOMVariantContainer GetBomName $i $lBOMVariantName
		set lBOMVariantNameStr [DboTclHelper_sGetConstCharPtr $lBOMVariantName]
		puts "  BOM Variant Name is $lBOMVariantNameStr" 
		
		dumpBOMVariantData $pCISDesign $lGroupContainer $lBOMVariantContainer $lBOMVariantName
		puts "  ----------------------------------------"
	}
	puts "======================================================"
	puts ""
	
}

proc ::capCIS::dump { } {

	if { [catch {set lDesign [GetActivePMDesign]} ] != 0 } {
		puts "Active design not found"
		return
	}
	
	set lNullObj NULL
	
	if {$lDesign == $lNullObj } {
		puts "Active design not found"
		return
	}
	
	if { [catch {set lCISDesign [CPartMgmt_GetCisDesign $lDesign]} ] != 0 } {
		puts "Active CIS design not found"
		return
	}
	
	puts "lCISDesign is $lCISDesign"
	if {$lCISDesign == $lNullObj } {
		puts "Active CIS design not found"
		return
	}
	

	dumpGroups $lCISDesign
	
	dumpBOMVariants $lCISDesign 
}

proc ::capCIS::GetCISDesign {} {
	set lDesign [GetActivePMDesign]
	set lCISDesign [CPartMgmt_GetCisDesign $lDesign]
	return $lCISDesign
}
 
proc ::capCIS::AddGroups { aTclList } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	foreach listelement $aTclList { 
		set lGroupName [DboTclHelper_sMakeCString $listelement]
		$lGroupContainer AddGroup $lGroupName
	}
}

proc ::capCIS::RemoveGroups { aTclList } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	set lBOMVariantContainer [$lCISDesign GetBOMVariantContainer]
	foreach listelement $aTclList {
		
		set lGroupName [DboTclHelper_sMakeCString $listelement]
		$lGroupContainer RemoveGroup $lGroupName
		
		# Delete from Variant also
		set lGroups [DboTclHelper_sMakeCString {Groups}]
		$lBOMVariantContainer DeleteInBom $lGroups $lGroupName
	}
}

proc ::capCIS::AddSubGroup { aGroupName aSubGroupName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lGroupName [DboTclHelper_sMakeCString $aGroupName]
	set lSubGroupArr [CISTclHelper_sMakeCStringArray]
	set lSubGroupName [DboTclHelper_sMakeCString $aSubGroupName]
	CISTclHelper_sAddToCStringArray $lSubGroupArr $lSubGroupName
	
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	$lGroupContainer AddSubGroup $lGroupName $lSubGroupArr
}

proc ::capCIS::RemoveSubGroup { aGroupName aSubGroupName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lGroupName [DboTclHelper_sMakeCString $aGroupName]
	set lSubGroupName [DboTclHelper_sMakeCString $aSubGroupName]
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	$lGroupContainer DeleteSubGroup $lGroupName $lSubGroupName
	
	# Remove from the variant also
	set lBOMVariantContainer [$lCISDesign GetBOMVariantContainer]
	$lBOMVariantContainer DeleteInBom $lGroupName $lSubGroupName
}

proc ::capCIS::AddSchSelectedPartsToGroup { aGroupName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lSelectedObjects [GetSelectedObjects]
	set SchOcc [GetInstanceOccurrence]
	set lStatus [DboState]
	set lPartOccIdArr [CISTclHelper_sMakeCUIntArray]
	foreach lDBObject $lSelectedObjects { 
		if { [$lDBObject GetObjectType]==$::DboBaseObject_PLACED_INSTANCE } {
			set lPartOcc [$lDBObject GetObjectOccurrence $SchOcc]
			set lPartOccId [$lPartOcc GetId $lStatus]
			CISTclHelper_sAddToCUIntArray $lPartOccIdArr $lPartOccId
		}
	}
	AddPartsToGroup $aGroupName $lPartOccIdArr
	$lStatus -delete
}

proc ::capCIS::AddPartsToGroup { aGroupName aCISCUIntArray } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lGroupName [DboTclHelper_sMakeCString $aGroupName]
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	if {[$lGroupContainer IsGroupHasSubGroups $lGroupName] == 1} {
		set lSubGroupCount [$lGroupContainer GetSubGroupCount $lGroupName]
		for {set i 0} {$i<$lSubGroupCount} {incr i} {
			set lSubGroupName [$lGroupContainer GetSubGroupByIndex  $lGroupName $i]
			$lGroupContainer AddPartsToSubGroup $lGroupName $lSubGroupName $aCISCUIntArray
		}
	} else {
		$lGroupContainer AddPartsToGroup $lGroupName $aCISCUIntArray
	}
}

proc ::capCIS::RemoveSchSelectedPartsFromGroup { aGroupName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lSelectedObjects [GetSelectedObjects]
	set SchOcc [GetInstanceOccurrence]
	set lStatus [DboState]
	set lPartOccIdArr [CISTclHelper_sMakeCUIntArray]
	foreach lDBObject $lSelectedObjects { 
		if { [$lDBObject GetObjectType]==$::DboBaseObject_PLACED_INSTANCE } {
			set lPartOcc [$lDBObject GetObjectOccurrence $SchOcc]
			set lPartOccId [$lPartOcc GetId $lStatus]
			CISTclHelper_sAddToCUIntArray $lPartOccIdArr $lPartOccId
		}
	}
	RemovePartsFromGroup $aGroupName $lPartOccIdArr
	$lStatus -delete
}

proc ::capCIS::RemovePartsFromGroup { aGroupName aCISCUIntArray } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lGroupName [DboTclHelper_sMakeCString $aGroupName]
	set lGroupContainer [$lCISDesign GetGroupsContainer]
	if {[$lGroupContainer IsGroupHasSubGroups $lGroupName] == 1} {
		set lSubGroupCount [$lGroupContainer GetSubGroupCount $lGroupName]
		for {set i 0} {$i<$lSubGroupCount} {incr i} {
			set lSubGroupName [$lGroupContainer GetSubGroupByIndex  $lGroupName $i]
			$lGroupContainer DeletePartsFromSubGroup $lGroupName $lSubGroupName $aCISCUIntArray
		}
	} else {
		$lGroupContainer DeletePartsFromGroup $lGroupName $aCISCUIntArray
	}
}

proc ::capCIS::AddVariant { aVariantName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	set lBOMVariantContainer [$lCISDesign GetBOMVariantContainer]
	set lVariantName [DboTclHelper_sMakeCString $aVariantName]
	$lBOMVariantContainer AddGroup $lVariantName
}

proc ::capCIS::AddGroupToVariant { aGroupName aVariantName } {
	set lCISDesign [GetCISDesign]
	set lNullObj NULL
	if {$lCISDesign == $lNullObj} {
		puts "Active CIS design not found"
		return
	}
	
	set lBOMVariantContainer [$lCISDesign GetBOMVariantContainer]
	set lVariantName [DboTclHelper_sMakeCString $aVariantName]
	set lGroupName [DboTclHelper_sMakeCString $aGroupName]
	$lBOMVariantContainer AddGroupToBomVariant $lVariantName $lGroupName
}

proc ::capCIS::AddSubGroupToVariant { aGroupName aSubGroupName aVariantName } {
	set lConCatGroup [concat $aGroupName\_$aSubGroupName]
	AddGroupToVariant $lConCatGroup $aVariantName
}

::capCIS::dump