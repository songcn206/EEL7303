#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capFindWindowExtension.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capFindWindowExtension { } {
}

proc capFindUtil_enablePatternMatcher { args}  {
	return 1
}

proc capFindUtil_cdnCapturePatternMatch {args}  {
	if { [catch {package require capFindUtil}] } {
	} else {
		eval [concat ::capFindUtil::cdnCapturePatternMatch $args]
	}
}

proc capFindUtil_CaptureFindControlProc { args }  {
	if { [catch {package require capFindUtil}] } {
	} else {
		eval [concat ::capFindUtil::CaptureFindControlProc $args]
	}
}

RegisterAction "_cdnPatternMatch"  "capFindUtil_enablePatternMatcher" "" capFindUtil_cdnCapturePatternMatch "" 
RegisterAction "_cdnRegisterFindExntension"  "capFindUtil_enablePatternMatcher" "" "capFindUtil_CaptureFindControlProc" ""
