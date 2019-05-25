#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomDRC.tcl
#            contains Custom DRC Framework
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capAutoLoad\capCustomDRC.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require orPrmJSON
package require orPrmStreamer
package require orPrmDebug
package require orPrmUtils
package require capHybridTest
package provide capCustomDRC 1.0
package require orPrmWebComp

namespace eval ::capCustomDRC {
	set lScriptDir [file dirname [info script]]
	set lRootDir [file join $::capCustomDRC::lScriptDir ..]
	set lCreateMarker 0
	variable lLogFilePath
	variable lJSONDRCs
	variable widgetId
	variable lDrcType
}


proc ::capCustomDRC::showDRCsElectrical {} {
	set lData [capCustomDRC::capCustomDRCElectrical]
	set lRawList [lindex $lData 0]
	set length  [llength $lRawList]
	set ::capCustomDRC::lJSONDRCs [lindex $lData 1]
	return $length;
}

proc ::capCustomDRC::showDRCsPhysical {} {
	set lData [capCustomDRC::capCustomDRCPhysical]
	set lRawList [lindex $lData 0]
	set length  [llength $lRawList]
	set ::capCustomDRC::lJSONDRCs [lindex $lData 1]
	return $length;
}

proc ::capCustomDRC::tclCall {} {
	return "$::capCustomDRC::lJSONDRCs"
}


proc ::capCustomDRC::drcType {} {
	return $::capCustomDRC::lDrcType
}

proc ::capCustomDRC::CloseWidget {} {
	orPrm::DestroyWidget $::capCustomDRC::widgetId
}

proc ::capCustomDRC::HelpDRC {} {
	orCommonTclUtil_ShowHelp "cap_ug" "custom_drc"
}

proc ::capCustomDRC::capSetRootDir { pDir } {
	set ::capCustomDRC::lRootDir $pDir
}

proc ::capCustomDRC::capResetRootDir {} {
	set ::capCustomDRC::lRootDir [file join $::capCustomDRC::lScriptDir .. ]
}

proc ::capCustomDRC::capSetCreateMarker { pFlag } {
	set ::capCustomDRC::lCreateMarker $pFlag
}

proc ::capCustomDRC::capSetLogFilePath { pPath } {
	set ::capCustomDRC::lLogFilePath $pPath
}


proc ::capCustomDRC::capLaunchWidget { numDRC } {
	set lModalId [orPrm::GetNextId]
    set ::capCustomDRC::widgetId $lModalId
	capHybridTest::capHybridTestInitialise $lModalId
    set res [correctUNCPath [file join $::capCustomDRC::lRootDir hybrid DesignRuleChecker.html]]
   
    set height [expr $numDRC *30 + 220]
    if {$height > 800} {
        set height 800
    }
    set actualDialogId [orPrm::CreateModalDialog $lModalId $res "Design Rule Checker" 1070 $height 1]
}


proc ::capCustomDRC::capShowCustomDRCElectrical {args} {
	set numDRC [::capCustomDRC::showDRCsElectrical]
	package require orPrmWebComp
	set ::capCustomDRC::lDrcType 0
	
	::capCustomDRC::capLaunchWidget $numDRC
	orPrm::SetTitle $::capCustomDRC::widgetId "Custom DRC Electrical"
}

proc ::capCustomDRC::capShowCustomDRCPhysical {args} {
	set numDRC [::capCustomDRC::showDRCsPhysical]
	package require orPrmWebComp
	set ::capCustomDRC::lDrcType 1
	
	::capCustomDRC::capLaunchWidget $numDRC
	orPrm::SetTitle $::capCustomDRC::widgetId "Custom DRC Physical"
}


proc ::capCustomDRC::capMakeJSONList { pList } {

	set lDRCList {}

	foreach drc $pList {
		set lDRCRule {}
		foreach pair $drc {
			foreach {name value} $pair {
				set lDRCRule [concat $lDRCRule [list $name [orPrmStreamer::streamString $value]]]
			}
		}
		lappend lDRCList [orPrmStreamer::streamObject $lDRCRule]
	}
	
	set lDRCArray [orPrmStreamer::streamArray $lDRCList]
	set lDRCs [orPrmStreamer::streamObject [list drcs $lDRCArray]]
	return [orPrmJSON::encode $lDRCs]
}


proc ::capCustomDRC::capCustomDRCElectrical {} {
	set lList [capOnCustomDRCElectrical]
	set lListJSON [capCustomDRC::capMakeJSONList $lList]
	return [list $lList $lListJSON]
}

proc ::capCustomDRC::capCustomDRCPhysical {} {
	set lList [capOnCustomDRCPhysical]
	set lListJSON [capCustomDRC::capMakeJSONList $lList]
	return [list $lList $lListJSON]
}


proc ::capCustomDRC::capCustomDrcLog { pMessage } {

	set outfile [open $::capCustomDRC::lLogFilePath a+]
	puts $outfile $pMessage
	close $outfile
	
	set lMessage [DboTclHelper_sMakeCString $pMessage]
	DboState_WriteToSessionLog $lMessage
}


proc ::capCustomDRC::ConvertDocToUser { pPage pDoc } {
   set lUser [expr "$pDoc *1.0 / [$pPage GetPhysicalGranularity]"]
   set lUser [expr floor($lUser*100) /100]
   return $lUser
}

proc ::capCustomDRC::capShowDRCError { pErrType pErrMsg pErrDetail pLocation pPage } {

	set lStatus [DboState]
	set lErrorName [DboTclHelper_sMakeCString]
	set lErrorName [GetDRCErrorMessage $pErrType]

	set lMsgLocation [DboTclHelper_sMakeCString]
	set lOwner [$pPage GetOwner]
	$lOwner GetName $lMsgLocation
	set lMsgLocation [DboTclHelper_sGetConstCharPtr $lMsgLocation]
	set lMsgLocation [concat $lMsgLocation,]
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageName [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lMsgLocation [concat $lMsgLocation $lPageName]

	set lStartX [DboTclHelper_sGetCPointX $pLocation]
	set lStartY [DboTclHelper_sGetCPointY $pLocation]
	
	set lXCord [capCustomDRC::ConvertDocToUser $pPage $lStartX]
	set lYCord [capCustomDRC::ConvertDocToUser $pPage $lStartY]


	set lMsgLocation [concat "$lMsgLocation  \($lXCord, $lYCord\)  "]
	set lERCSymbol [capGetDRCErrorSymbol]
	
	set pErrMsg [DboTclHelper_sMakeCString $pErrMsg]
	set pErrDetail [DboTclHelper_sMakeCString $pErrDetail]

	set lMsgLocation [DboTclHelper_sMakeCString $lMsgLocation]
	
	if { $::capCustomDRC::lCreateMarker == 1} {
		set lExist [capFindInDrcMap $pPage $pLocation $pErrMsg]
		if { $lExist == 0 } {
			$pPage NewERC $lStatus $lErrorName $pErrMsg $pErrDetail $lMsgLocation $lERCSymbol $pLocation $::DboValue_NOROTATION 0 0
		}
	}

	set lErrorNameString [DboTclHelper_sGetConstCharPtr $lErrorName]
	set lErrorMsgString [DboTclHelper_sGetConstCharPtr $pErrMsg]
	set lPrintLog [concat $lErrorNameString $lErrorMsgString]
	set lMessage [DboTclHelper_sMakeCString $lPrintLog]
	DboState_WriteToSessionLog $lMessage

	set outfile [open $::capCustomDRC::lLogFilePath a+]
	puts $outfile $lPrintLog
	close $outfile

}

proc ::capCustomDRC::capCustomElectricalDrcFindExecutableStatus { pDrc } {
	set drcString [GetOptionString CustomElectricalDrcRules]
	set drc [split $drcString ","]
	set lSearchIndex [lsearch $drc $pDrc]
	if {  $lSearchIndex != -1  }  {
		return 1
	} else {
		return 0
	}
}

proc ::capCustomDRC::capCustomPhysicalDrcFindExecutableStatus { pDrc } {
	set drcString [GetOptionString CustomPhysicalDrcRules]
	set drc [split $drcString ","]
	set lSearchIndex [lsearch $drc $pDrc]
	
	if {  $lSearchIndex != -1  }  {
		return 1
	} else {
		return 0
	}
}

proc ::capCustomDRC::capCustomRunElectricalDrc { args } {
	set drcString [GetOptionString CustomElectricalDrcRules]
	set drc [split $drcString ","]
	foreach rule $drc {
		eval [concat $rule $args]
	}
	
}

proc ::capCustomDRC::capCustomRunPhysicalDrc {args} {
	set drcString [GetOptionString CustomPhysicalDrcRules]
	set drc [split $drcString ","]
	foreach rule $drc {
		eval [concat $rule $args]
	}
}





