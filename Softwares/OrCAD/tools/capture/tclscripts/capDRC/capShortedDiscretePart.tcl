#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capShortedDiscretePart.tcl
#            DRC to check for discrete shorted Part.
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capShortedDiscretePart.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capShortedDiscretePart 1.0


namespace eval ::capShortedDiscretePart {
	set scriptDir [file dirname [info script]]
	variable partInstList [list]
}

proc ::capShortedDiscretePart::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capShortedDiscretePart::capProcessInstOccurenceStart { pInstOcc } {
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPortCount 0
	set lPortOne NULL
	set lPortTwo NULL
	
	set lPartInst [$pInstOcc GetPartInst $lStatus]
	set lsearchIndex [lsearch $::capShortedDiscretePart::partInstList $lPartInst]
	
	# if partInst already Processed
	if { $lsearchIndex != -1 } {
		$lStatus -delete
		return
	}
	
	# Add PArt Inst to Processed List
	lappend ::capShortedDiscretePart::partInstList $lPartInst 

	set lPortOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_PORTS]
	$lPortOccIter Sort $lStatus
	set lPortOcc [$lPortOccIter NextOccurrence $lStatus]
	while { $lPortOcc!= $lNullObj} {
	
		incr lPortCount
	
		if { $lPortCount == 1} {
			set lPortOne $lPortOcc
		} elseif { $lPortCount == 2} {
			set lPortTwo $lPortOcc
		} else {
			set lPortCount 0
			break
		}
		set lPortOcc [$lPortOccIter NextOccurrence $lStatus]
	}
	delete_DboOccurrenceChildrenIter $lPortOccIter
	set lBaseObject [$pInstOcc GetParent]
	set lOcc [DboBaseObjectToDboOccurrence $lBaseObject]
	set lSchOcc [DboOccurrenceToDboInstOccurrence $lOcc]
	
	set lFlatNetOne NULL
	set lFlatNetTwo NULL
	

	if { $lPortCount == 2 } {
		set lPortOneOcc [DboOccurrenceToDboPortOccurrence $lPortOne]
		# Get the pin 
		set lPartPin [$lPortOneOcc GetPortInst $lStatus]
		set lPinTypeOne  [$lPartPin GetPinType $lStatus]
		set lNet [$lPartPin GetNet $lStatus]
		if { $lNet != $lNullObj} { 
			set lSchNet [$lNet GetSchematicNet]
			set lNetOcc [$lSchOcc GetNetOccurrence $lSchNet $lStatus]
			set lFlatNetOne [$lNetOcc GetFlatNet $lStatus]
		} else {
			$lStatus -delete
			return
		}
		
		set lPortTwoOcc [DboOccurrenceToDboPortOccurrence $lPortTwo]
		# Get the pin 
		set lPartPin [$lPortTwoOcc GetPortInst $lStatus]
		set lPinTypeTwo  [$lPartPin GetPinType $lStatus]
		set lNet [$lPartPin GetNet $lStatus]
		if { $lNet != $lNullObj} { 
			set lSchNet [$lNet GetSchematicNet]
			set lNetOcc [$lSchOcc GetNetOccurrence $lSchNet $lStatus]
			set lFlatNetTwo [$lNetOcc GetFlatNet $lStatus]
		} else {
			$lStatus -delete
			return
		}	

		if { $lFlatNetOne == $lFlatNetTwo } {
			# Ignore if both are power Pins
			if { $lPinTypeOne == $::DboValue_POWER &&  $lPinTypeTwo == $::DboValue_POWER } {
				$lStatus -delete
				return
			}


			set lMessageString [DboTclHelper_sMakeCString]
			$lPartInst GetName $lMessageString
			set lPartName [DboTclHelper_sGetConstCharPtr $lMessageString]
			
			set lReferenceString [DboTclHelper_sMakeCString]
			$lPartInst GetReference $lReferenceString
			set lReferenceName [DboTclHelper_sGetConstCharPtr $lReferenceString]
			
			set lPageString [DboTclHelper_sMakeCString]
			set lPage [$lPartInst GetOwner]
			$lPage GetName $lPageString
			set lPageName [DboTclHelper_sGetConstCharPtr $lPageString]
			
			set lSchematicString [DboTclHelper_sMakeCString]
			set lSchematic [$lPage GetOwner]
			$lSchematic GetName $lSchematicString
			set SchematicName [DboTclHelper_sGetConstCharPtr $lSchematicString]
		
			set lErrType 1
			set lErrMessage "ERROR: $lReferenceName { REFRENCE:$lPartName } is shorted in PAGE=$lPageName in SCHEMATIC=$SchematicName"		
			set lErrDetailString ""
			set lLocation [$lPartPin GetOffsetHotSpot $lStatus]
		
			capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
			
		}
	}
	
	$lStatus -delete

	return
}


proc ::capShortedDiscretePart::capRunDrc { args } {

	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	set ::capShortedDiscretePart::partInstList [capShortedDiscretePart::clearList $::capShortedDiscretePart::partInstList]
	
	set lMessage "\nChecking for Shorted Discrete Part \n\n"
	
	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
	
	# Run always in Occurence Mode
	capProcessDRC::capProcessSelection "capShortedDiscretePart" $lScope 0

}

proc ::capShortedDiscretePart::capTrueRunDrc {} {
    return true
}

proc ::capShortedDiscretePart::capShortedDiscretePartDrcData {args} {
		set lDrcName 		"Shorted Discrete Part"
		set lProc			"capShortedDiscretePart_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Check if two terminals of any discrete part attached to same net "
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capShortedDiscretePart::scriptDir capShortedDiscretePart.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}

