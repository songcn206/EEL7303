#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capModifiedFlatNetEventHandler.tcl
#            contains OrCAD Capture Custom page util
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capModifiedFlatNetEventHandler 1.0


namespace eval ::capModifiedFlatNetEventHandler {
	
}

proc ::capModifiedFlatNetEventHandler::OnPagePostConnect { pPage } {
	
	set lMessage "Connect happened on page $pPage"
	
	DboState_WriteToSessionLog [DboTclHelper_sMakeCString $lMessage]
	
	set lSchematic [$pPage GetOwner]
	set lLib [$lSchematic GetOwner]
	set lDesign [DboLibToDboDesign $lLib]
	
	set lNulllObj NULL
	
	if { $lDesign == $lNulllObj} {
		return
	}
	
	set lModifiedFlatNetsIter [new_DboModifiedFlatNetsIter $lDesign]
	
	set lFlatNetId [DboTclHelper_sMakeULong]
	set lFlatNetStatus [DboTclHelper_sMakeInt]
	
	set lStatus [$lModifiedFlatNetsIter NextId $lFlatNetId $lFlatNetStatus]
	while { [$lStatus OK] == 1 } {
		
		set lFlatNetStatusStr " "
		if { [DboTclHelper_sGetInt $lFlatNetStatus] == 0} {
			set lFlatNetStatusStr " deleted"
		} elseif { [DboTclHelper_sGetInt $lFlatNetStatus] == 1} {
			set lFlatNetStatusStr " added/modified"
		} 
		
		set lMessage [concat "Flat Net Id " [DboTclHelper_sGetULong $lFlatNetId] $lFlatNetStatusStr]
		DboState_WriteToSessionLog [DboTclHelper_sMakeCString $lMessage]
	
		set lStatus [$lModifiedFlatNetsIter NextId $lFlatNetId $lFlatNetStatus]
	}
	
	delete_DboModifiedFlatNetsIter $lModifiedFlatNetsIter
	
	$lStatus -delete
	DboTclHelper_sReleaseAllCreatedPtrs
	
	return
}

proc ::capModifiedFlatNetEventHandler::OnPagePreConnect { pPage } {
	
	set lSchematic [$pPage GetOwner]
	set lLib [$lSchematic GetOwner]
	set lDesign [DboLibToDboDesign $lLib]
	
	set lNulllObj NULL
	
	if { $lDesign == $lNulllObj} {
		return
	}
	
	$lDesign StartRegisteringFlatNetModification
	
	DboTclHelper_sReleaseAllCreatedPtrs
}

proc ::capModifiedFlatNetEventHandler::capTrue { pPage } {
	return 1
}

RegisterAction "_cdnOrPreConnect" "::capModifiedFlatNetEventHandler::capTrue" "" "::capModifiedFlatNetEventHandler::OnPagePreConnect" ""
RegisterAction "_cdnOrPostConnect" "::capModifiedFlatNetEventHandler::capTrue" "" "::capModifiedFlatNetEventHandler::OnPagePostConnect" ""

