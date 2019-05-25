#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAnnotateHBlockPageNumber.tcl
#            Assigns Page Number property to H-Block to which it points
#   
#  The Design Must NOT be Open in Capture.
#
#  You can run the script either in the Capture TCL command window or in standalone TCL shell. 
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g. source {D:\TclScript\capAnnotateHBlockPageNumber.tcl}
# 2. capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber <Design path> 
#    e.g. capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber {D:\SPB163\tools\capture\samples\FULLADD.DSN}
#
# Steps for running the script in Standalone TCL shell
# 1. load <orDb_Dll_Tcl.dll path> DboTclWriteBasic
#    e.g. load {D:\SPB163\tools\capture/orDb_Dll_Tcl} DboTclWriteBasic
#    (In this case, please make sure that C:/Cadence/SPB_16.3/tools/bin is present in the Path environment variable, because the dependent dll orDb_Dll is picked up from that location)
# 2. source <script path>
#    e.g. source {D:\TclScript\capAnnotateHBlockPageNumber.tcl}
# 3. capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber <Design path> 
#    e.g. capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber {D:\SPB163\tools\capture\samples\FULLADD.DSN}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capAnnotateHBlockPageNumber 1.0

namespace eval ::capAnnotateHBlockPageNumber {
	namespace export AnnotateHBlockPageNumber
}

proc ::capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber { pDesignName } {
	do $pDesignName 
	return
}

proc GetPageNumber { pInstOcc pPage } {
	set PageName [DboTclHelper_sMakeCString]
	$pPage GetName $PageName
	puts "Reading TitleBlock On Page: [DboTclHelper_sGetConstCharPtr $PageName]"
	set pStatus [DboState]
	set pTBIter [$pPage NewTitleBlocksIter $pStatus]
	set pTB [$pTBIter NextTitleBlock $pStatus]
	set varNullObj NULL
	set strTBPageNumberPropertyValue [DboTclHelper_sMakeCString]
	set strTBPageNumberPropertyName [DboTclHelper_sMakeCString {Page Number}]
	while {$pTB!=$varNullObj} {
		set TitleBlockID [$pTB GetId $pStatus]
		set pTitleBlockOcc [$pInstOcc GetTitleBlockOccurrence $TitleBlockID $pStatus]
		if {$pTitleBlockOcc!=$varNullObj} {
			$pTitleBlockOcc GetEffectivePropStringValue $strTBPageNumberPropertyName $strTBPageNumberPropertyValue
			puts "TitleBlock Occurrence Page Number: [DboTclHelper_sGetConstCharPtr $strTBPageNumberPropertyValue]"
		} else {
			$pTB GetEffectivePropStringValue $strTBPageNumberPropertyName $strTBPageNumberPropertyValue
			puts "TitleBlock Instance Page Number: [DboTclHelper_sGetConstCharPtr $strTBPageNumberPropertyValue]"
		}
		set pTB [$pTBIter NextTitleBlock $pStatus]
	}
	delete_DboPageTitleBlocksIter $pTBIter
	$pStatus -delete
	set PageNumber [DboTclHelper_sGetConstCharPtr $strTBPageNumberPropertyValue]
	return $PageNumber
}

proc GetTitleBlockPageNumber { pDboInstOcc pSchematicObj } {
	set pStatus [DboState]
	set pPagesIter [$pSchematicObj NewPagesIter $pStatus]
	set pPage [$pPagesIter NextPage $pStatus]
	set varNullObj NULL
	while {$pPage!=$varNullObj} {
		set PageNumber [GetPageNumber $pDboInstOcc $pPage]
		set pPage [$pPagesIter NextPage $pStatus]
	}
	delete_DboSchematicPagesIter $pPagesIter
	$pStatus -delete
	return $PageNumber
}

proc capAnnotateHBlockPageNumber::do { pDesignName } {
	set pSession [DboTclHelper_sCreateSession]
	set lDesignName [DboTclHelper_sMakeCString $pDesignName]
	set pStatus [DboState]
	set pDesign [$pSession GetDesignAndSchematics $lDesignName $pStatus]
	set varNullObj NULL
	if { $pDesign == $varNullObj } {
		puts "Could Not Open design" 
		return
	 }
	 if { [$pDesign IsRootOccurrenceExisting] == 0 } {
		puts "Reading Root Occurrence"
		$pDesign GetRootOccurrence $pStatus
	 }
	 # Display the mode of the Design
	 set varOccMode [$pDesign DesignHasReusedSchematics]
	 set varOccModeSchText [DboTclHelper_sMakeCString {Design Mode: Occurrence - Reason: ReUsed Schematic}]
	 set varOccModeText [DboTclHelper_sMakeCString {Design Mode: Occurrence - Reason: Occurrence Property Present}]
	 if {$varOccMode} { 
		puts [DboTclHelper_sGetConstCharPtr $varOccModeSchText] 
	} else {
		set varOccMode [$pDesign DesignHasOccurrenceProperties $pStatus]
		if {$varOccMode} {
			puts [DboTclHelper_sGetConstCharPtr $varOccModeText]
		}
	}
	# Iterate over occurrences
	DboDesignOccurrencesIter iterOccs $pDesign
	set pDboInstOcc [iterOccs NextOccurrence $pStatus]
	set varPartReference [DboTclHelper_sMakeCString {Part Reference}]
	set varPartReferenceValue [DboTclHelper_sMakeCString]
	while {$pDboInstOcc!=$varNullObj} {
		set pDboPartInst [$pDboInstOcc GetPartInst $pStatus];
		if {$pDboPartInst!=$varNullObj && [$pDboPartInst IsPrimitive $pStatus]==0} { 
			set pView [$pDboInstOcc GetContents $pStatus]
			# value 9 is for Schematic Object
			if {$pView!=$varNullObj && [$pView GetObjectType]==9} { 
				# Get the title Block page number from the underlying schematic
				set pSchematicObj [DboViewToDboSchematic $pView]
				set PageNumber [GetTitleBlockPageNumber $pDboInstOcc $pSchematicObj]
				$pDboInstOcc GetEffectivePropStringValue $varPartReference $varPartReferenceValue
				set varMessageStr [concat "H-Block Part Reference: " [DboTclHelper_sGetConstCharPtr $varPartReferenceValue] "Refers Page:" $PageNumber "\r\n"]
				puts $varMessageStr
				set strMessageStr [DboTclHelper_sMakeCString $varMessageStr]
				DboState_WriteToSessionLog $strMessageStr
				if { [$pDboPartInst GetUserPropsPermitted $pStatus ]==1} {
					# Add the Page Number as user propery
					set varNewUserProperty [DboTclHelper_sMakeCString {Page Number}]
					set varNewUserPropertyValue [DboTclHelper_sMakeCString $PageNumber]
					$pDboPartInst SetEffectivePropStringValue $varNewUserProperty $varNewUserPropertyValue
					
					# Add the display property by getting the display property setting from part reference
					set strReferencePropName [DboTclHelper_sMakeCString {Reference}]
					set pDispProp [$pDboPartInst GetDisplayProp $strReferencePropName $pStatus]
					set logfont [DboTclHelper_sMakeLOGFONT]
					set rotation 0
					set color 48
					# To Place the property X location away from Part Reference Display Property
					#if {$pDispProp!=$varNullObj} {
					#	 set varReferenceLocation [$pDispProp GetLocation $pStatus]
					#	 set xlocation [DboTclHelper_sGetCPointX $varReferenceLocation]
					#	 set xlocation [expr $xlocation+100]
					#	 set varDispLocation [DboTclHelper_sMakeCPoint $xlocation [DboTclHelper_sGetCPointY $varReferenceLocation]]	
					#	 set pNewDispProp [$pDboPartInst NewDisplayProp $pStatus $varNewUserProperty $varDispLocation $rotation $logfont $color]		
						 # 0 = DoNotDisplay, 1 = Value, 2 = Name and Value, 3 = Value, 4 = If Value Exists
					#	 $pNewDispProp SetDisplayType 2
					#} else {
						set pageNumberDispProp [$pDboPartInst GetDisplayProp $varNewUserProperty $pStatus]
						if { $pageNumberDispProp == $varNullObj } {
							set xlocation 0
							set ylocation 0
							set displocation [DboTclHelper_sMakeCPoint [expr $xlocation] [expr $ylocation]]
							set pNewDispProp [$pDboPartInst NewDisplayProp $pStatus $varNewUserProperty $displocation $rotation $logfont $color]
							# 0 = DoNotDisplay, 1 = Value, 2 = Name and Value, 3 = Value, 4 = If Value Exists
							$pNewDispProp SetDisplayType 2
						} else {
							$pDispProp SetValueString $varNewUserPropertyValue $pDboInstOcc
							$pDispProp SetDisplayType 2
						}
					#}
				}
			}
			
		}
		set pDboInstOcc [iterOccs NextOccurrence $pStatus]
	}
	$pSession MarkAllLibForSave $pDesign
	$pSession SaveDesign $pDesign
	$pSession RemoveLib $pDesign
	DboTclHelper_sDeleteSession $pSession
	
	DboTclHelper_sReleaseAllCreatedPtrs
}