#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDevicePinMismatch.tcl
#            DRC to check for Device Pin Mismatch.
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capDevicePinMismatch.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capDevicePinMismatch 1.0


namespace eval ::capDevicePinMismatch {
	set scriptDir [file dirname [info script]]
	variable partInstList [list]
}

proc ::capDevicePinMismatch::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capDevicePinMismatch::capProcessInstOccurenceStart { pInstOcc } {
	set lStatus [DboState]
	set lNullObj NULL
	
	
	set lDesignator "Designator"
	set lDesignator [DboTclHelper_sMakeCString $lDesignator]
	set lValue [DboTclHelper_sMakeCString]
	
	$pInstOcc GetEffectivePropStringValue $lDesignator $lValue
	
	set lPartInst [$pInstOcc GetPartInst $lStatus]
	set lsearchIndex [lsearch $::capDevicePinMismatch::partInstList $lPartInst]
	
	# if partInst already Processed
	if { $lsearchIndex != -1 } {
		$lStatus -delete
		return
	}
		
	set lPlacePartInst [DboPartInstToDboPlacedInst $lPartInst]
	
	if { $lPlacePartInst != $lNullObj } {
	
		set lPartInstDevice [$lPlacePartInst GetDevice $lStatus]
		
		set lpackage [$lPlacePartInst GetPackage $lStatus]
		set lOccDevice [$lpackage GetDevice $lValue $lStatus]

		set lPartDeviceCell [$lPartInstDevice GetCell $lStatus]
		set lPartDevicePartIter [$lPartDeviceCell NewPartsIter $lStatus]
		set lPartDeviceLibPart [$lPartDevicePartIter NextPart $lStatus]
		
		set lPartInstName [DboTclHelper_sMakeCString]
		$lPartInst GetName $lPartInstName
		set lPartInstName [DboTclHelper_sGetConstCharPtr $lPartInstName]
	
		set lOccDeviceCell [$lOccDevice GetCell $lStatus]
		set lOccDevicePartIter [$lOccDeviceCell NewPartsIter $lStatus]
		set lOccDeviceLibPart [$lOccDevicePartIter NextPart $lStatus]
		
		set lPartDevicePartPinCount [DboLibPart_sGetPinCount $lPartDeviceLibPart $lStatus]
		set lOccDevicePartPinCount [DboLibPart_sGetPinCount $lOccDeviceLibPart $lStatus]
		
		set lPageString [DboTclHelper_sMakeCString]
		set lPage [$lPartInst GetOwner]
		$lPage GetName $lPageString
		set lPageName [DboTclHelper_sGetConstCharPtr $lPageString]
		
		set lSchematicString [DboTclHelper_sMakeCString]
		set lSchematic [$lPage GetOwner]
		$lSchematic GetName $lSchematicString
		set SchematicName [DboTclHelper_sGetConstCharPtr $lSchematicString]
		
		set lBBox [$lPartInst GetOffsetBoundingBox $lStatus]
		set lLocation [DboTclHelper_sGetCRectTopLeft $lBBox]

		
		if { $lPartDevicePartPinCount != $lOccDevicePartPinCount } {
		
			set lErrType 0
			set lErrMessage "Device {$lPartInstName} pin mismatch on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
			set lErrDetailString ""
	
			capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
			
			# Add Part Inst to Processed List
			lappend ::capDevicePinMismatch::partInstList $lPartInst 
	
			return;
		}
		
		set lPartDevicePinIter [$lPartDeviceLibPart NewLPinsIter $lStatus]
		set lPartDeviceSymbolPin [$lPartDevicePinIter NextPin $lStatus]
		
		set lOccDevicePinIter [$lOccDeviceLibPart NewLPinsIter $lStatus]
		set lOccDeviceSymbolPin [$lOccDevicePinIter NextPin $lStatus]
		
		while { $lPartDeviceSymbolPin != $lNullObj } {
		
			set lPartDeviceSymbolPinName [DboTclHelper_sMakeCString]
			$lPartDeviceSymbolPin GetPinName $lPartDeviceSymbolPinName
			set lPartDeviceSymbolPinName [DboTclHelper_sGetConstCharPtr $lPartDeviceSymbolPinName]
			
			set lOccDeviceSymbolPinName [DboTclHelper_sMakeCString]
			$lOccDeviceSymbolPin GetPinName $lOccDeviceSymbolPinName
			set lOccDeviceSymbolPinName [DboTclHelper_sGetConstCharPtr $lOccDeviceSymbolPinName]
			
			if { $lPartDeviceSymbolPinName !=  $lOccDeviceSymbolPinName } {	
			
				set lErrType 0
				set lErrMessage "Device {$lPartInstName} pin mismatch on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
				set lErrDetailString ""
				
				# Add Part Inst to Processed List
				lappend ::capDevicePinMismatch::partInstList $lPartInst 
		
				capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
				return;
			}
			
			
			set lPartDeviceSymbolPinType [$lPartDeviceSymbolPin GetPinType $lStatus]
			set lOccDeviceSymbolPinType [$lOccDeviceSymbolPin GetPinType $lStatus]
			
			if { $lPartDeviceSymbolPinType !=  $lOccDeviceSymbolPinType } {	
			
				set lErrType 0
				set lErrMessage "Device {$lPartInstName} pin mismatch on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
				set lErrDetailString ""
				
				# Add Part Inst to Processed List
				lappend ::capDevicePinMismatch::partInstList $lPartInst 
		
				capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
				return;
			}
		
			
			set lPartDeviceSymbolPin [$lPartDevicePinIter NextPin $lStatus]
			set lOccDeviceSymbolPin [$lOccDevicePinIter NextPin $lStatus]
		}
		
	}
	
	$lStatus -delete

	return
}


proc ::capDevicePinMismatch::capRunDrc { args } {
	
	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	set ::capDevicePinMismatch::partInstList [capDevicePinMismatch::clearList $::capDevicePinMismatch::partInstList]
	
	set lMessage "\nChecking for Device Pin Mismatch \n\n"

	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
		
	if { $lMode == 1 } {
		set lErrorMessage "\n This DRC is not valid for instance Mode \n"
		capCustomDRC::capCustomDrcLog $lErrorMessage
		return
	}
	
	# Run always in Occurence Mode
	capProcessDRC::capProcessSelection "capDevicePinMismatch" $lScope 0

}

proc ::capDevicePinMismatch::capDevicePinMismatchDrcData {args} {
		set lDrcName 		"Device Pin Mismatch"
		set lProc			"capDevicePinMismatch_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Checks for mismatch of physical pin group due to Part reference designator used in occurrence"
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capDevicePinMismatch::scriptDir capDevicePinMismatch.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}

