#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomDRCInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capCustomDRC_capCustomRunElectricalDrc { args } {
	if { [catch {package require capCustomDRC}] } {
	} else {
		eval [concat ::capCustomDRC::capCustomRunElectricalDrc $args]
	}
}

proc capCustomDRC_capCustomRunPhysicalDrc {args} {
	if { [catch {package require capCustomDRC}] } {
	} else {
		eval [concat ::capCustomDRC::capCustomRunPhysicalDrc $args]
	}
}

proc capCustomDRC_capShowCustomDRCElectrical {args} {
	if { [catch {package require capCustomDRC}] } {
	} else {
		eval [concat ::capCustomDRC::capShowCustomDRCElectrical $args]
	}
}

proc capCustomDRC_capShowCustomDRCPhysical {args} {
	if { [catch {package require capCustomDRC}] } {
	} else {
		eval [concat ::capCustomDRC::capShowCustomDRCPhysical $args]
	}
}
