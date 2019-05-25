#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPartReferencePrefixMismatch.tcl
#            DRC to check for Part Refrence Prefix Mismatch.
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRC\capPartReferencePrefixMismatch.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require capCustomDRC
package require capProcessDRC
package provide capPartReferencePrefixMismatch 1.0


namespace eval ::capPartReferencePrefixMismatch {
	set scriptDir [file dirname [info script]]
	variable partInstList [list]
}

proc ::capPartReferencePrefixMismatch::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capPartReferencePrefixMismatch::capProcessPartInsts { pPartInst } {
	
	set lStatus [DboState]
	set lNullObj NULL
	set lPartInst $pPartInst
	
	set lReference "Reference"
	set lReference [DboTclHelper_sMakeCString $lReference]
	set lInstReference [DboTclHelper_sMakeCString]
	
	$pPartInst GetEffectivePropStringValue $lReference $lInstReference
	
	
	set lInstPrefix [DboTclHelper_sMakeCString]
	set lInstRefName [DboTclHelper_sMakeInt]
	DboRefDesUtils_SplitPartReference $lInstReference $lInstPrefix $lInstRefName
	
	set lPlacePartInst [DboPartInstToDboPlacedInst $lPartInst]
	
	
	if { $lPlacePartInst != $lNullObj } {	
	
		set lPackage [$lPlacePartInst GetPackage $lStatus]
		set lPackageReference [DboTclHelper_sMakeCString]
		$lPackage GetReferenceTemplate $lPackageReference
		
		set lPkgPrefix [DboTclHelper_sMakeCString]
		set lPkgRefName [DboTclHelper_sMakeInt]
		
		DboRefDesUtils_SplitPartReference $lPackageReference $lPkgPrefix $lPkgRefName
		
		set lPartInstPrefixString [DboTclHelper_sGetConstCharPtr $lInstPrefix]
		set lPackageInstPrefix [DboTclHelper_sGetConstCharPtr $lPkgPrefix]
		

		
		if { $lPartInstPrefixString != $lPackageInstPrefix } {
		
			set lPartInstName [DboTclHelper_sMakeCString]
			$lPartInst GetName $lPartInstName
			set lPartInstName [DboTclHelper_sGetConstCharPtr $lPartInstName]
			
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
	
			set lErrType 0
			set lErrMessage "Part Reference {$lPartInstName} Prefix mismatch on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
			set lErrDetailString ""
	
			capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
			return;
		}
		
	}
	

}

proc ::capPartReferencePrefixMismatch::capProcessInstOccurenceStart { pInstOcc } {

	set lStatus [DboState]
	set lNullObj NULL
	
	set lReference "Reference"
	set lReference [DboTclHelper_sMakeCString $lReference]
	set lOccReference [DboTclHelper_sMakeCString]
	$pInstOcc GetEffectivePropStringValue $lReference $lOccReference
	
	set lOccPrefix [DboTclHelper_sMakeCString]
	set lOccRefName [DboTclHelper_sMakeInt]
	DboRefDesUtils_SplitPartReference $lOccReference $lOccPrefix $lOccRefName
	
	
	set lPartInst [$pInstOcc GetPartInst $lStatus]
	set lsearchIndex [lsearch $::capPartReferencePrefixMismatch::partInstList $lPartInst]
	
	# if partInst already Processed
	if { $lsearchIndex != -1 } {
		$lStatus -delete
		return
	}
	
	set lPlacePartInst [DboPartInstToDboPlacedInst $lPartInst]
	
	if { $lPlacePartInst != $lNullObj } {	
	
		set lPackage [$lPlacePartInst GetPackage $lStatus]
		set lPackageReference [DboTclHelper_sMakeCString]
		$lPackage GetReferenceTemplate $lPackageReference
		
		set lPkgPrefix [DboTclHelper_sMakeCString]
		set lPkgRefName [DboTclHelper_sMakeInt]
		
		DboRefDesUtils_SplitPartReference $lPackageReference $lPkgPrefix $lPkgRefName
		
		set lPartInstPrefixString [DboTclHelper_sGetConstCharPtr $lOccPrefix]
		set lPackageInstPrefix [DboTclHelper_sGetConstCharPtr $lPkgPrefix]
	
		
		if { $lPartInstPrefixString != $lPackageInstPrefix } {
		
			set lPartInstName [DboTclHelper_sMakeCString]
			$lPartInst GetName $lPartInstName
			set lPartInstName [DboTclHelper_sGetConstCharPtr $lPartInstName]
				
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
			
			set lErrType 0
			set lErrMessage "Part Reference {$lPartInstName} Prefix mismatch on  PAGE=$lPageName in SCHEMATIC=$SchematicName"	
			set lErrDetailString ""
			
			# Add Part Inst to Processed List
			lappend ::capPartReferencePrefixMismatch::partInstList $lPartInst 
	
			capCustomDRC::capShowDRCError $lErrType $lErrMessage $lErrDetailString $lLocation $lPage
			return;
		}
	
	}
	
	$lStatus -delete

	return
}


proc ::capPartReferencePrefixMismatch::capRunDrc { args } {

	set lScope [lindex $args 0]
	set lMode  [lindex $args 1]
	set lCreateDrcMarkers [lindex $args 2]
	set lLogFilePath [lindex $args 3]
	
	capCustomDRC::capSetCreateMarker $lCreateDrcMarkers
	set ::capPartReferencePrefixMismatch::partInstList [capPartReferencePrefixMismatch::clearList $::capPartReferencePrefixMismatch::partInstList]
	
	set lMessage "\nChecking for Part Refrence Prefix Mismatch \n\n"
	
	# Setting the Variables for logging
	capCustomDRC::capSetLogFilePath $lLogFilePath
	capCustomDRC::capCustomDrcLog $lMessage
	
	# Run always in Occurence Mode
	capProcessDRC::capProcessSelection "capPartReferencePrefixMismatch" $lScope $lMode

}

proc ::capPartReferencePrefixMismatch::capTrueRunDrc {} {
    return true
}

proc ::capPartReferencePrefixMismatch::capPartReferencePrefixMismatchDrcData {args} {
		set lDrcName 		"Part Refrence Prefix Mismatch"
		set lProc			"capPartReferencePrefixMismatch_capRunDrc"
		set lIsExecute 		[capCustomDRC::capCustomElectricalDrcFindExecutableStatus $lProc]
		set lOptional 		[DboTclHelper_sMakeStdVector]
		DboTclHelper_sPushBackToVector $lOptional "Type"
		DboTclHelper_sPushBackToVector $lOptional "Electrical"
		DboTclHelper_sPushBackToVector $lOptional "Description"
		DboTclHelper_sPushBackToVector $lOptional "Reference Designator Prefex is checked against the definition in library"
		DboTclHelper_sPushBackToVector $lOptional "FilePath"
		set lFilePath [file join $::capPartReferencePrefixMismatch::scriptDir capPartReferencePrefixMismatch.tcl]
		DboTclHelper_sPushBackToVector $lOptional $lFilePath
		set lReturn [CapCustomDRCElectricalAddItem $lDrcName $lIsExecute $lProc $lOptional]
		
		return lReturn
}

