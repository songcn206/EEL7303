#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capSyncPropPCBFootprint.tcl
#            contains OrCAD Capture Sync PCB Footprint procedures
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capSyncPropPCBFootprint 1.0

namespace eval ::capSyncPropPCBFootprint {
	namespace export syncActiveDesign
	namespace export syncDesign
	
	variable mOldDiffs [list]
	variable mNewDiffs [list]
}

proc ::capSyncPropPCBFootprint::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}
	

proc ::capSyncPropPCBFootprint::visitPlacedInst { pPlacedInst pMode } {
	set lStatus [DboState]
	set lNullObj NULL
	
	variable mOldDiffs
	variable mNewDiffs
	
	set lCachedPCBFootprintNameStr [DboTclHelper_sMakeCString]
	set lPCBFootprintNameStr [DboTclHelper_sMakeCString]
	set lRefDesStr [DboTclHelper_sMakeCString]
	
	set lCachedPackage [$pPlacedInst GetPackage $lStatus]

	$lCachedPackage GetPCBFootprint $lCachedPCBFootprintNameStr
	$pPlacedInst GetPCBFootprint $lPCBFootprintNameStr
	
	set lCachedPCBFootprintName [DboTclHelper_sGetConstCharPtr $lCachedPCBFootprintNameStr]
	set lPCBFootprintName [DboTclHelper_sGetConstCharPtr $lPCBFootprintNameStr]
	
	if { $lCachedPCBFootprintName != "" } {
		if { $lPCBFootprintName != $lCachedPCBFootprintName} {
			$pPlacedInst GetReferenceDesignator $lRefDesStr
		
			set lOldSearchIndex [lsearch $mOldDiffs $pPlacedInst]
			
			if { $pMode == "ReportAllDiffs"} {
				lappend mOldDiffs $pPlacedInst
				set lMessage [concat $pMode " : PCB Footprint Mismatch : " [DboTclHelper_sGetConstCharPtr $lRefDesStr]  " : " $lPCBFootprintName " --> " $lCachedPCBFootprintName]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
				puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
			}

			if { $pMode == "ReportNewDiffs"} {
				if { $lOldSearchIndex == -1} {
					lappend mNewDiffs $pPlacedInst
					
					set lMessage [concat $pMode " : PCB Footprint Mismatch: 
					" [DboTclHelper_sGetConstCharPtr $lRefDesStr]  " : 
					" $lPCBFootprintName " --> " $lCachedPCBFootprintName]

					set lMessageStr [DboTclHelper_sMakeCString $lMessage]
					DboState_WriteToSessionLog $lMessageStr
					puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
				}
			}

			set lNewSearchIndex [lsearch $mNewDiffs $pPlacedInst]
		
			if { $pMode == "UpdateNewDiffs"} {
				if { $lNewSearchIndex != -1} {
					$pPlacedInst SetPCBFootprint $lCachedPCBFootprintNameStr
					$pPlacedInst MarkModified
				
					set lMessage [concat $pMode " : PCB Footprint Changed : " [DboTclHelper_sGetConstCharPtr $lRefDesStr]  " : " $lPCBFootprintName " --> " $lCachedPCBFootprintName]
					set lMessageStr [DboTclHelper_sMakeCString $lMessage]
					DboState_WriteToSessionLog $lMessageStr
					puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
				}
			}
			
			if { $pMode == "UpdateAllDiffs"} {
				$pPlacedInst SetPCBFootprint $lCachedPCBFootprintNameStr
				$pPlacedInst MarkModified
				
				set lMessage [concat $pMode " : PCB Footprint Changed : " [DboTclHelper_sGetConstCharPtr $lRefDesStr]  " : " $lPCBFootprintName " --> " $lCachedPCBFootprintName]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
				puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
			}
		}
	}
	
	$lStatus -delete
	return
}


proc ::capSyncPropPCBFootprint::visitPageInsts { pPage pMode } { 
	set lStatus [DboState]
	set lPartInstIter [$pPage NewPartInstsIter $lStatus]
	set lPartInst [$lPartInstIter NextPartInst $lStatus]
	set lNullObj NULL
	
	while {$lPartInst!=$lNullObj} {
		
		set lPlacedInst [DboPartInstToDboPlacedInst $lPartInst]
		
		if {$lPlacedInst != $lNullObj} {
			visitPlacedInst $lPlacedInst $pMode
		}
		
		set lPartInst [$lPartInstIter NextPartInst $lStatus]
	}
	delete_DboPagePartInstsIter $lPartInstIter
	$lStatus -delete
	
	return
}


proc ::capSyncPropPCBFootprint::visitPages { pSchematic pMode } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		visitPageInsts $lPage $pMode
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capSyncPropPCBFootprint::visitSchematics { pDesign pMode } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
		visitPages $lObj $pMode
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

# pMode = ReportAllDiffs | ReportNewDiffs | UpdateAllDiffs | UpdateNewDiffs
proc ::capSyncPropPCBFootprint::syncActiveDesign { pMode } {    
	 
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
	 
	 variable mOldDiffs
	 variable mNewDiffs
	 
	 if {$pMode == "ReportAllDiffs"} {
		set mOldDiffs [clearList $mOldDiffs]
		set mNewDiffs [clearList $mNewDiffs]
	}
	
	if {$pMode == "ReportNewDiffs"} {
		set mOldDiffs [concat $mOldDiffs $mNewDiffs]
		set mNewDiffs [clearList $mNewDiffs]
	}

	#updateNewDiffs should forcibly call ReportNewDiffs first
	if {$pMode == "UpdateNewDiffs"} {
		set mNewDiffs [clearList $mNewDiffs]
		visitSchematics $lDesign "ReportNewDiffs"
	}
	
	#updateNewDiffs should forcibly call ReportAllDiffs first
	if {$pMode == "UpdateAllDiffs"} {
		set mOldDiffs [clearList $mOldDiffs]
		set mNewDiffs [clearList $mNewDiffs]
		visitSchematics $lDesign "ReportAllDiffs"
	}
	
	 visitSchematics $lDesign $pMode
	 
	 if {$pMode == "UpdateAllDiffs"} {
		set mOldDiffs [clearList $mOldDiffs]
		set mNewDiffs [clearList $mNewDiffs]
	}
	
	if {$pMode == "UpdateNewDiffs"} {
		set mNewDiffs [clearList $mNewDiffs]
	}
	
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 set lMessage "---------------------------------------------------------------------------------"
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
	
	return
}

# pMode = ReportAllDiffs | UpdateAllDiffs
proc ::capSyncPropPCBFootprint::syncDesign { pDesignPath pMode } {    
	 
	set lMessage "---------------------------------------------------------------------------------"
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
	
	set lSession [DboTclHelper_sCreateSession]
	set lStatus [DboState]

	set lDesignPath [DboTclHelper_sMakeCString $pDesignPath]
	set lDesign [DboSession_GetDesignAndSchematics $lSession $lDesignPath $lStatus]

	 set lNullObj NULL
	  
	 if { $lDesign == $lNullObj} {
		set lError [DboTclHelper_sMakeCString [concat "Design not found : " $pDesignPath]]
		DboState_WriteToSessionLog $lError
		puts [DboTclHelper_sGetConstCharPtr $lError]
		return
	 }
	 
	 variable mOldDiffs
	 variable mNewDiffs
	 
	 if {$pMode == "ReportAllDiffs"} {
		set mOldDiffs [clearList $mOldDiffs]
		set mNewDiffs [clearList $mNewDiffs]
	}
	
	 visitSchematics $lDesign $pMode
	 
	 if {$pMode == "UpdateAllDiffs"} {
		$lSession MarkAllLibForSave $lDesign
		$lSession SaveDesign $lDesign
	}
	
	if {$pMode == "UpdateAllDiffs"} {
		set mOldDiffs [clearList $mOldDiffs]
		set mNewDiffs [clearList $mNewDiffs]
	}
	
	$lSession RemoveDesign $lDesign
	 
	 delete_DboSession $lSession
	 $lStatus -delete
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	set lMessage "---------------------------------------------------------------------------------"
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	puts [DboTclHelper_sGetConstCharPtr $lMessageStr]
	
	return
}

# source D:/WorkData/Capture/dbcheck/capSyncPropPCBFootprint.tcl

# capSyncPropPCBFootprint::syncActiveDesign ReportAllDiffs
# capSyncPropPCBFootprint::syncActiveDesign ReportNewDiffs
# capSyncPropPCBFootprint::syncActiveDesign UpdateAllDiffs
# capSyncPropPCBFootprint::syncActiveDesign UpdateNewDiffs

# capSyncPropPCBFootprint::syncDesign G:/CaptureData/SIGXP1.DSN ReportAllDiffs
# capSyncPropPCBFootprint::syncDesign G:/CaptureData/SIGXP1.DSN UpdateAllDiffs

