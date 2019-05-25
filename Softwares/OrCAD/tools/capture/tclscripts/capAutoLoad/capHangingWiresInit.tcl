#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capHangingWiresInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capHangingWires_capTrueRunDrc {args} {
    return true
}

proc capHangingWires_capHangingWiresDrcData {args} {
	if { [catch {package require capHangingWires}] } {
	} else {
		eval [concat ::capHangingWires::capHangingWiresDrcData $args]
	}
}

proc capHangingWires_capRunDrc {args} {
	if { [catch {package require capHangingWires}] } {
	} else {
		eval [concat ::capHangingWires::capRunDrc $args]
	}
}



RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capHangingWires_capTrueRunDrc" "" "capHangingWires_capHangingWiresDrcData" ""

