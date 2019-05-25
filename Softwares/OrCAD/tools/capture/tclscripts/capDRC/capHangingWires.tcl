#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capHangingWires.tcl
#            DRC to check Hanging Wires
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capHangingWires.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capHangingWires 1.0


namespace eval ::capHangingWires {
	set scriptDir [file dirname [info script]]
	variable WireList [list]
}


proc ::capHangingWires::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capHangingWires::capProcessWireObtained { pWire } {

	set lStatus [DboState]
	set lNullObj NULL
	
	set lCounter 0
	
	set lStartPoint [$pWire GetStartPoint $lStatus]
	set lStartX [DboTclHelper_sGetCPointX $lStartPoint]
	set lStartY [DboTclHelper_sGetCPointY $lStartPoint]
	set lEndPoint [$pWire GetEndPoint $lStatus]
	set lEndX [DboTclHelper_sGetCPointX $lEndPoint]
	set lEndY [DboTclHelper_sGetCPointY $lEndPoint]
	
	set lPage [$pWire GetOwner]
	
	set lStartPointObjectIterator [$lPage NewObjectsAtPointIter $lStartPoint $lStatus]
	set lObject [$lStartPointObjectIterator NextObject $lStatus]
	
	while {$lObject != $lNullObj} {
	
		set lActive [$lObject IsCurrent]
		if { $lActive == 1 } {
			incr  lCounter
			if { $lCounter >= 2} {
				break
			}
		}
		
		unset lObject
		set lObject [$lStartPointObjectIterator NextObject $lStatus] 
		
	 }
	
	if { $lCounter < 2 } {
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
		
		set lErrType 0
		set lErrMessage "Wire {$lUStartX,$lUStartY:$lUEndX,$lUEndY} is hanging at Point { $lUStartX, $lUStartY } on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
		set lErrDetailString ""
	
		capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lStartPoint $lPage
	}
	
	set lEndPointObjectIterator [$lPage NewObjectsAtPointIter $lEndPoint $lStatus]
	set lObject [$lEndPointObjectIterator NextObject $lStatus]
	
	set lCounter 0
	
	while {$lObject != $lNullObj} {

		set lActive [$lObject IsCurrent]
		if { $lActive == 1 } {
			incr  lCounter
			if { $lCounter >= 2} {
				break
			}
		}
		
		unset lObject
		set lObject [$lEndPointObjectIterator NextObject $lStatus] 
		
	 }
	
	if { $lCounter < 2 } {
	
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
		
		set lErrType 0
		set lErrMessage "Wire {$lUStartX,$lUStartY:$lUEndX,$lUEndY} is hanging at Point { $lUEndX, $lUEndY } on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
		set lErrDetailString ""
	
		capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lEndPoint $lPage
	}

}
proc ::capHangingWires::capProcessDboNet { pDboNet } {

	set lStatus [DboState]
	set lNullObj NULL

	set lWiresIter [$pDboNet NewWiresIter $lStatus]
	set lWire [$lWiresIter NextWire $lStatus]
	
	while {$lWire != $lNullObj} {
	
		set lsearchIndex [lsearch $::capHangingWires::WireList $lWire]
		if { $lsearchIndex == -1 } {
			capHangingWires::capProcessWireObtained $lWire
			lappend ::capHangingWires::WireList $lWire
		}
		unset lWire
		set lWire [$lWiresIter NextWire $lStatus] 
		
	 }

}

proc ::capHangingWires::capProcessWire { pWire } {
	
	set lsearchIndex [lsearch $::capHangingWires::WireList $pWire]
	if { $lsearchIndex == -1 } {
		capHangingWires::capProcessWireObtained $pWire
		lappend ::capHangingWires::WireList $pWire 
	}
	

}

proc ::capHangingWires::capRunDrc { args } {

	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	set ::capHangingWires::WireList [capHangingWires::clearList $::capHangingWires::WireList]
	
	set lMessage "\n Checking for Hanging Wires \n\n"
	
	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
	
	capProcessDRC::capProcessSelection "capHangingWires" $lScope $lMode
}

proc ::capHangingWires::capTrueRunDrc {} {
    return true
}

proc ::capHangingWires::capHangingWiresDrcData { args } {
		package require orPrmWebComp
		set lDrcName 		"Hanging Wires"
		set lProc			"capHangingWires_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Checks for any un-connected wire ends"
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capHangingWires::scriptDir capHangingWires.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}

