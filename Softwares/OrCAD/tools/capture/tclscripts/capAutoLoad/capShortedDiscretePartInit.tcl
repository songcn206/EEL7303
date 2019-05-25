#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capShortedDiscretePartInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capShortedDiscretePart_capTrueRunDrc {args} {
    return true
}

proc capShortedDiscretePart_capShortedDiscretePartDrcData {args} {
	if { [catch {package require capShortedDiscretePart}] } {
	} else {
		eval [concat ::capShortedDiscretePart::capShortedDiscretePartDrcData $args]
	}
}

proc capShortedDiscretePart_capRunDrc {args} {
	if { [catch {package require capShortedDiscretePart}] } {
	} else {
		eval [concat ::capShortedDiscretePart::capRunDrc $args]
	}
}

RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capShortedDiscretePart_capTrueRunDrc" "" "capShortedDiscretePart_capShortedDiscretePartDrcData" ""
