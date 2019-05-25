#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capFindUtil.tcl
#            contains OrCAD Capture Design utlities
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#  
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capFindUtil 1.0

namespace eval ::capFindUtil {
	namespace export _cdnPatternMatch
}

proc ::capFindUtil::RegisterPatternMatch { }  {
RegisterAction "_cdnPatternMatch"  "::capFindUtil::enablePatternMatcher" "" capFindUtil::cdnCapturePatternMatch "" 
}

proc ::capFindUtil::RegisterExtensibleFind { }  {
catch { RegisterAction "_cdnRegisterFindExntension"  "::capFindUtil::enablePatternMatcher" "" "::capFindUtil::CaptureFindControlProc" ""  }
}

proc ::capFindUtil::enablePatternMatcher { args}  {
	return 1
}

proc ::capFindUtil::enableExtensibleFind { args }  {
	return 1
}


proc ::capFindUtil::cdnCapturePatternMatch {isCaseSensitive pTextToSearch pTextFromSearch }  {
	set lNullObj NULL
	if { $pTextToSearch == $lNullObj ||
		$pTextToSearch == "" ||
		$pTextFromSearch == $lNullObj ||
		$pTextFromSearch == "" } {
		puts "Incorrect usage"
		return
	}
	
	set isAlphaNumUnderscpre [regexp {^[A-Za-z0-9_\s]+$} $pTextToSearch]
	
	if { $isAlphaNumUnderscpre == 1} {
	
		set tempStr ^$pTextToSearch\$
		
		#lappend tempStr \^$pTextToSearch\$
		set pTextToSearch $tempStr
	}
	
	
	if { $isCaseSensitive == 1 } {
		set lSearchResult [regexp $pTextToSearch $pTextFromSearch]
	} else {
		set lSearchResult [regexp -nocase $pTextToSearch $pTextFromSearch]
	}
	if { $lSearchResult == 1 } {
		return 1
	}
	return 0
}


proc ::capFindUtil::CaptureFindControlProc { pFindWindowType }  {
	set lNullObj NULL
	set varlist {}
	if { $pFindWindowType == $lNullObj } {
		puts "Incorrect usage"
		return
	}
	if { $pFindWindowType == "Parts" } {
		lappend varlist "Location X-Coordinate"
		lappend varlist "Location Y-Coordinate"
		return $varlist
	}
}
