#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPortPinMismatch.tcl
#            contains Design Rule Check for Pin Port Mismatch
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capPortPinMismatch.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capPortPinMismatch 1.0

namespace eval ::capPortPinMismatch {
	set scriptDir [file dirname [info script]]
	variable gDesign
	variable pinList [list]
	variable portList [list]	
}


proc ::capPortPinMismatch::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capPortPinMismatch::capVisitForUnderlyingPorts { pPage  } { 
	set lStatus [DboState]
	set lPortsIter [$pPage NewPortsIter $lStatus]
	set lPort [$lPortsIter NextPort $lStatus]
	set lNullObj NULL
	
	while {$lPort!=$lNullObj} {
		
		set lPortName [DboTclHelper_sMakeCString]
		$lPort GetName $lPortName
		
		set lPortBaseNameString [DboTclHelper_sMakeCString]
		set lLsbString [DboTclHelper_sMakeInt]
		set lMsbString [DboTclHelper_sMakeInt]
		set lFlag [DboBus_ValidBusName $lPortName $lPortBaseNameString $lLsbString $lMsbString]
		
		if { $lFlag!=0 } {
			set lPortBaseName [DboTclHelper_sGetConstCharPtr $lPortBaseNameString]	
		} else {
			set lPortBaseName [DboTclHelper_sGetConstCharPtr $lPortName]
		}
		
		set lCheck 0
		set lIndex 0
	
		foreach j $::capPortPinMismatch::portList {
				set lSearchIndex [lsearch $j $lPortBaseName]
				if {  $lSearchIndex != -1  }  {
					set ltempList [lindex $::capPortPinMismatch::portList $lIndex]
					lappend ltempList $lPort
					lset ::capPortPinMismatch::portList $lIndex $ltempList
					set lCheck 1	
				} else {
					set lIndex [expr $lIndex + 1]
				}
		}

		if { $lCheck==0 } {
			variable tempList [list]
			lappend tempList  $lPortBaseName
			lappend tempList  $lPort
			lappend ::capPortPinMismatch::portList $tempList 
		}
		
		set lPort [$lPortsIter NextPort $lStatus]
	}
	delete_DboPagePortsIter $lPortsIter
	$lStatus -delete
	
	return
}

proc ::capPortPinMismatch::capVisitPagesForUnderlyingPorts { pSchematic  } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitForUnderlyingPorts $lPage 
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}


proc ::capPortPinMismatch::capVisitPins { pPartInst } { 

	set lStatus [DboState]
	set lPinsIter [$pPartInst NewPinsIter $lStatus]

	set lPin [$lPinsIter NextPin $lStatus]
	set lNullObj NULL

	while { $lPin!=$lNullObj } {
		
		set lPinName [DboTclHelper_sMakeCString]
		$lPin GetPinName $lPinName
		
		set lPinBaseNameString [DboTclHelper_sMakeCString]
		set lLsbString [DboTclHelper_sMakeInt]
		set lMsbString [DboTclHelper_sMakeInt]
		set lFlag [DboBus_ValidBusName $lPinName $lPinBaseNameString $lLsbString $lMsbString]
		
		if { $lFlag!=0 } {
			set lPinBaseName [DboTclHelper_sGetConstCharPtr $lPinBaseNameString]	
		} else {
			set lPinBaseName [DboTclHelper_sGetConstCharPtr $lPinName]
		}

		set lCheck 0
		set lIndex 0
	
		foreach j $::capPortPinMismatch::pinList {
				set lSearchIndex [lsearch $j $lPinBaseName]
				if {  $lSearchIndex != -1  }  {
					set ltempList [lindex $::capPortPinMismatch::pinList $lIndex]
					lappend ltempList $lPin
					lset ::capPortPinMismatch::pinList $lIndex $ltempList	
					set lCheck 1
				} else {
					set lIndex [expr $lIndex + 1]
				}
		}

		if { $lCheck==0 } {
			variable tempList [list]
			lappend tempList $lPinBaseName
			lappend tempList  $lPin
			lappend ::capPortPinMismatch::pinList $tempList 
		}
		
		set lPin [$lPinsIter NextPin $lStatus]
	}
	delete_DboPartInstPinsIter $lPinsIter
	$lStatus -delete

	return
}


proc ::capPortPinMismatch::capProcessPartInsts { pPartInst } { 
	set lStatus [DboState]
	set lPartInst $pPartInst
	set lNullObj NULL

	
	set pObject [$lPartInst GetObjectType]
	
	if {$pObject == $::DboBaseObject_DRAWN_INSTANCE}	{
	
		set pViewType [$lPartInst GetContentsViewType $lStatus]
		
		if {$pViewType == $::DboValue_SCHEMATIC_VIEW_TYPE} {
		
			# Hirerchiral Block 
			set ::capPortPinMismatch::pinList [clearList $::capPortPinMismatch::pinList]
			capVisitPins $lPartInst
			
			# Underlying Schematic
			set ::capPortPinMismatch::portList [clearList $::capPortPinMismatch::portList]
			set lSchematicName [DboTclHelper_sMakeCString]
			$lPartInst GetContentsViewName $lSchematicName
			
			set lSchematicRef [$::capPortPinMismatch::gDesign GetSchematic $lSchematicName $lStatus]
			capVisitPagesForUnderlyingPorts $lSchematicRef
		
			
			foreach j $::capPortPinMismatch::pinList {
				for { set k 1 } { $k < [llength $j] } { incr k } {
					set lPin [lindex $j $k]
					
					set lPinName [DboTclHelper_sMakeCString]
					$lPin GetPinName $lPinName
					
					set lPinNameString [DboTclHelper_sMakeCString]
					set lPinLsbString [DboTclHelper_sMakeInt]
					set lPinMsbString [DboTclHelper_sMakeInt]
					set lPinFlag [DboBus_ValidBusName $lPinName $lPinNameString $lPinLsbString $lPinMsbString]
					
					set lPinBundleObject [$lPin IsBundlePin 0]
					
					if { $lPinFlag !=0 } {
						set lPinNameString [DboTclHelper_sGetConstCharPtr $lPinNameString]
					} else {
						set lPinNameString [DboTclHelper_sGetConstCharPtr $lPinName]
					}

					set lResult 0
					foreach l $::capPortPinMismatch::portList {
						
						set lPortName [lindex $l 0]

					
						if { $lPortName == $lPinNameString } {
							for { set m 1 } { $m < [llength $l] } { incr m } {
								set lPort [lindex $l $m]
								
								set lPortBundleObject [$lPort IsBundleObject]
								
								if { $lPinBundleObject ==  $lPortBundleObject } {
								
									set lPortName [DboTclHelper_sMakeCString]
									$lPort GetName $lPortName
									
									set lPortNameString [DboTclHelper_sMakeCString]
									set lPortLsbString [DboTclHelper_sMakeInt]
									set lPortMsbString [DboTclHelper_sMakeInt]
									set lPortFlag [DboBus_ValidBusName $lPortName $lPortNameString $lPortLsbString $lPortMsbString]
									

									if { $lPortFlag ==  $lPinFlag && $lPinFlag != 0 } {
										
										set lPinLsbValue [DboTclHelper_sGetInt $lPinLsbString]
										set lPinMsbValue [DboTclHelper_sGetInt $lPinMsbString]
										set lPortLsbValue [DboTclHelper_sGetInt $lPortMsbString]
										set lPortMsbValue [DboTclHelper_sGetInt $lPortLsbString]
										

										if { $lPinLsbValue == $lPortLsbValue  && $lPinMsbValue == $lPortMsbValue } {
										
											set lPageString [DboTclHelper_sMakeCString]
											set lPage [$lPartInst GetOwner]
											$lPage GetName $lPageString
											set lPageName [DboTclHelper_sGetConstCharPtr $lPageString]
											
											set lSchematicString [DboTclHelper_sMakeCString]
											set lSchematic [$lPage GetOwner]
											$lSchematic GetName $lSchematicString
											set SchematicName [DboTclHelper_sGetConstCharPtr $lSchematicString]
											
											set lPinNameString [DboTclHelper_sGetConstCharPtr $lPinName]
											set lHotSpotPoint [$lPin GetOffsetStartPoint $lStatus]
											
											set lErrType 0
											set lErrMessage "Hierarchiral Pin $lPinNameString Mismatch with Hierarchiral Port on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
											set lErrDetailString ""
										
											capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lHotSpotPoint $lPage
										}
									}
								}	
							}
						}
					}	
				}
			}
		}
	}
		
	$lStatus -delete
	return
}
proc ::capPortPinMismatch::capProcessSelectionStart { pDesign } {
	set ::capPortPinMismatch::gDesign $pDesign
}

proc ::capPortPinMismatch::capRunDrc { args } {

	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	
	set lMessage "\n Checking for Port Pin Mismatch \n\n"
	
	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
	
	capProcessDRC::capProcessSelection "capPortPinMismatch" $lScope 1
}

proc ::capPortPinMismatch::capTrueRunDrc {} {
    return true
}

proc ::capPortPinMismatch::capPortPinMismatchDrcData {args} {
		package require orPrmWebComp
		set lDrcName 		"Port Pin Mismatch"
		set lProc			"capPortPinMismatch_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Checks hierarchical pin and port definitions for any mismatch"
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capPortPinMismatch::scriptDir capPortPinMismatch.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}
