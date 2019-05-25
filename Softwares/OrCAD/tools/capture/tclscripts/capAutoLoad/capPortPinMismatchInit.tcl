#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPortPinMismatchInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capPortPinMismatch_capTrueRunDrc {args} {
    return true
}

proc capPortPinMismatch_capPortPinMismatchDrcData {args} {
	if { [catch {package require capPortPinMismatch}] } {
	} else {
		eval [concat ::capPortPinMismatch::capPortPinMismatchDrcData $args]
	}
}

proc capPortPinMismatch_capRunDrc {args} {
	if { [catch {package require capPortPinMismatch}] } {
	} else {
		eval [concat ::capPortPinMismatch::capRunDrc $args]
	}
}

RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capPortPinMismatch_capTrueRunDrc" "" "capPortPinMismatch_capPortPinMismatchDrcData" ""


