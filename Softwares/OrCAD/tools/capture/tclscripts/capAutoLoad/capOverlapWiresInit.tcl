#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capOverlapWiresInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capOverlapWires_capTrueRunDrc {args} {
    return true
}

proc capOverlapWires_capOverlapWiresDrcData {args} {
	if { [catch {package require capOverlapWires}] } {
	} else {
		eval [concat ::capOverlapWires::capOverlapWiresDrcData $args]
	}
}

proc capOverlapWires_capRunDrc {args} {
	if { [catch {package require capOverlapWires}] } {
	} else {
		eval [concat ::capOverlapWires::capRunDrc $args]
	}
}

RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capOverlapWires_capTrueRunDrc" "" "capOverlapWires_capOverlapWiresDrcData" ""

