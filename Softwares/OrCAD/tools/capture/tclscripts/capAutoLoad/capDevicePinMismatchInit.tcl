#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDevicePinMismatchInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capDevicePinMismatch_capTrueRunDrc { args } {
    return true
}

proc capDevicePinMismatch_capDevicePinMismatchDrcData { args } {
	if { [catch {package require capDevicePinMismatch}] } {
	} else {
		eval [concat ::capDevicePinMismatch::capDevicePinMismatchDrcData $args]

	}
}

proc capDevicePinMismatch_capRunDrc { args } {
	if { [catch {package require capDevicePinMismatch}] } {
	} else {
		eval [concat ::capDevicePinMismatch::capRunDrc $args]
	}
}



RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capDevicePinMismatch_capTrueRunDrc" "" "capDevicePinMismatch_capDevicePinMismatchDrcData" ""
