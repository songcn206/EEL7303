#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capOverlapWires.tcl
#            DRC to Check Overlaping Wires
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capOverlapWires.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capOverlapWires 1.0


namespace eval ::capOverlapWires {
	set scriptDir [file dirname [info script]]
	variable wireList [list]
	set Mode 0
}

proc ::capOverlapWires::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capOverlapWires::capGetAlignment { pObject } {
	set lAlign [$pObject IsHorizontal ]
}


proc ::capOverlapWires::capProcessWiresObtained { pWire pObject } {

	set lStatus [DboState]
	set lNullObj NULL
	
	lappend ::capOverlapWires::wireList $pWire
	set lAlign [$pWire IsHorizontal $lStatus]
	
	set lStartPoint [$pWire GetStartPoint $lStatus]
	set lStartX [DboTclHelper_sGetCPointX $lStartPoint]
	set lStartY [DboTclHelper_sGetCPointY $lStartPoint]
	set lEndPoint [$pWire GetEndPoint $lStatus]
	set lEndX [DboTclHelper_sGetCPointX $lEndPoint]
	set lEndY [DboTclHelper_sGetCPointY $lEndPoint]
	
	set lPage NULL
	if { $::capOverlapWires::Mode == 0 } {
		set lPage [$pWire GetOwner]
	} else {
		set lPage $pObject
	}
	set lLeftWireIter [$lPage NewWiresIter $lStatus]
	set lLeftWire [$lLeftWireIter NextWire $lStatus]
	
	while { $lLeftWire != $lNullObj } {
		set lOrthogonal [$lLeftWire IsNonOrthogonal $lStatus]
		if { $lOrthogonal == 1 } {
			set lLeftWire [$lLeftWireIter NextWire $lStatus]
			continue
		}
		
		if { $lLeftWire != $pWire} {
			set lLeftWireAlign [$lLeftWire IsHorizontal $lStatus]
			if { $lLeftWireAlign == $lAlign } {
				set lLeftStartPoint [$lLeftWire GetStartPoint $lStatus]
				set lLeftStartX [DboTclHelper_sGetCPointX $lLeftStartPoint]
				set lLeftStartY [DboTclHelper_sGetCPointY $lLeftStartPoint]
				set lLeftEndPoint [$lLeftWire GetEndPoint $lStatus]
				set lLeftEndX [DboTclHelper_sGetCPointX $lLeftEndPoint]
				set lLeftEndY [DboTclHelper_sGetCPointY $lLeftEndPoint]
				if { $lStartX == $lLeftStartX } {
					if { $lLeftStartY >= $lStartY && $lLeftStartY >=$lEndY && $lLeftEndY >= $lStartY  && $lLeftEndY >= $lEndY } {
					} elseif { $lLeftStartY <= $lStartY && $lLeftStartY <= $lEndY && $lLeftEndY <= $lStartY  && $lLeftEndY <= $lEndY } {
					} else {
						set lSearchIndex [lsearch $::capOverlapWires::wireList $lLeftWire]
						if {  $lSearchIndex == -1  }  {
						
							set lPageString [DboTclHelper_sMakeCString]
							set lPage [$pWire GetOwner]
							$lPage GetName $lPageString
							set lPageName [DboTclHelper_sGetConstCharPtr $lPageString]
							
							set lSchematicString [DboTclHelper_sMakeCString]
							set lSchematic [$lPage GetOwner]
							$lSchematic GetName $lSchematicString
							set SchematicName [DboTclHelper_sGetConstCharPtr $lSchematicString]
							
							set lUStartX [capCustomDRC::ConvertDocToUser $lPage $lStartX]
							set lUStartY [capCustomDRC::ConvertDocToUser $lPage $lStartY]
							set lUEndX [capCustomDRC::ConvertDocToUser $lPage $lEndX]
							set lUEndY [capCustomDRC::ConvertDocToUser $lPage $lEndY]
							set lULeftStartX [capCustomDRC::ConvertDocToUser $lPage $lLeftStartX]
							set lULeftStartY [capCustomDRC::ConvertDocToUser $lPage $lLeftStartY]
							set lULeftEndX [capCustomDRC::ConvertDocToUser $lPage $lLeftEndX]
							set lULeftEndY [capCustomDRC::ConvertDocToUser $lPage $lLeftEndY]
							
							# Setting DRC Markers Variables
							set lErrType 0
							set lErrMessage "Wire {$lUStartX,$lUStartY:$lUEndX,$lUEndY} is overlaped with Wire {$lULeftStartX,$lULeftStartY:$lULeftEndX,$lULeftEndY} on  PAGE=$lPageName in SCHEMATIC=$SchematicName"
							set lErrDetailString ""
							
							if { $lLeftStartY >= $lStartY && $lLeftStartY <= $lEndY} {
								capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLeftStartPoint $lPage
							} else {
								capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLeftEndPoint $lPage
							} 
						} 
					}
					
				} elseif { $lStartY == $lLeftStartY} {
					if { $lLeftStartX >= $lStartX && $lLeftStartX >=$lEndX && $lLeftEndX >= $lStartX  && $lLeftEndX >= $lEndX } {
					} elseif { $lLeftStartX <= $lStartX && $lLeftStartX <= $lEndX && $lLeftEndX <= $lStartX  && $lLeftEndX <= $lEndX } {
					} else {
						set lSearchIndex [lsearch $::capOverlapWires::wireList $lLeftWire]
						if {  $lSearchIndex == -1  }  {
						
							set lPageString [DboTclHelper_sMakeCString]
							set lPage [$pWire GetOwner]
							$lPage GetName $lPageString
							set lPageName [DboTclHelper_sGetConstCharPtr $lPageString]
							
							set lSchematicString [DboTclHelper_sMakeCString]
							set lSchematic [$lPage GetOwner]
							$lSchematic GetName $lSchematicString
							set SchematicName [DboTclHelper_sGetConstCharPtr $lSchematicString]
							
							set lUStartX [capCustomDRC::ConvertDocToUser $lPage $lStartX]
							set lUStartY [capCustomDRC::ConvertDocToUser $lPage $lStartY]
							set lUEndX [capCustomDRC::ConvertDocToUser $lPage $lEndX]
							set lUEndY [capCustomDRC::ConvertDocToUser $lPage $lEndY]
							set lULeftStartX [capCustomDRC::ConvertDocToUser $lPage $lLeftStartX]
							set lULeftStartY [capCustomDRC::ConvertDocToUser $lPage $lLeftStartY]
							set lULeftEndX [capCustomDRC::ConvertDocToUser $lPage $lLeftEndX]
							set lULeftEndY [capCustomDRC::ConvertDocToUser $lPage $lLeftEndY]
							
							# Setting DRC Markers Variables
							set lErrType 0
							set lErrMessage "Wire {$lUStartX,$lUStartY:$lUEndX,$lUEndY} is overlaped with Wire {$lULeftStartX,$lULeftStartY:$lULeftEndX,$lULeftEndY} on  PAGE=$lPageName in SCHEMATIC=$SchematicName"
							set lErrDetailString ""
							
							if { $lLeftStartX >= $lStartX && $lLeftStartX <= $lEndX} {
								capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLeftStartPoint $lPage
							} else {
								capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLeftEndPoint $lPage
							} 
						} 
					}
				} else {
					#For Future Use
				}
			}
			
		}
		
		set lLeftWire [$lLeftWireIter NextWire $lStatus] 
	}
}

# For Occurence Mode
proc ::capOverlapWires::capProcessDboNet { pDboNet } {
	set lStatus [DboState]
	set lNullObj NULL
	
	set ::capOverlapWires::Mode 0
	
	set lWiresIter [$pDboNet NewWiresIter $lStatus]
	set lWire [$lWiresIter NextWire $lStatus]
	
	while {$lWire != $lNullObj} {
	
		set lOrthogonal [$lWire IsNonOrthogonal $lStatus]
		if { $lOrthogonal == 0 } {
			capOverlapWires::capProcessWiresObtained $lWire $pDboNet
		}
		
		unset lWire
		set lWire [$lWiresIter NextWire $lStatus] 
		
	 }

	
}

# For Instance Mode
proc ::capOverlapWires::capProcessPageStart { pPage } {
	set lStatus [DboState]
	set lNullObj NULL
	
	set ::capOverlapWires::Mode 1
	
	#wires
	set lWiresIter [$pPage NewWiresIter $lStatus]
	set lWire [$lWiresIter NextWire $lStatus] 

	while {$lWire != $lNullObj} {
		
		set lOrthogonal [$lWire IsNonOrthogonal $lStatus]
		if { $lOrthogonal == 0 } {
			capOverlapWires::capProcessWiresObtained $lWire $pPage
		}
		
		unset lWire
		set lWire [$lWiresIter NextWire $lStatus] 
		
	 }
}

proc ::capOverlapWires::capRunDrc { args } {
	
	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	set ::capOverlapWires::wireList [capOverlapWires::clearList $::capOverlapWires::wireList]
	
	set lMessage "\nChecking for Overlaping Buses and Wires \n\n"
	
	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
	
	
	capProcessDRC::capProcessSelection "capOverlapWires" $lScope $lMode
}

proc ::capOverlapWires::capTrueRunDrc {} {
    return true
}

proc ::capOverlapWires::capOverlapWiresDrcData {args} {
		package require orPrmWebComp
		set lDrcName 		"Overlaping Wires"
		set lProc			"capOverlapWires_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Checks if two wires are overlapped with each other"
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capOverlapWires::scriptDir capOverlapWires.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}
