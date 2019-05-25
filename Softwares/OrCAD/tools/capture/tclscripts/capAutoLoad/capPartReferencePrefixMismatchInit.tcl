#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPartReferencePrefixMismatchInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capPartReferencePrefixMismatch_capTrueRunDrc {args} {
    return true
}

proc capPartReferencePrefixMismatch_capPartReferencePrefixMismatchDrcData {args} {
	if { [catch {package require capPartReferencePrefixMismatch}] } {
	} else {
		eval [concat ::capPartReferencePrefixMismatch::capPartReferencePrefixMismatchDrcData $args]
	}
}

proc capPartReferencePrefixMismatch_capRunDrc {args} {
	if { [catch {package require capPartReferencePrefixMismatch}] } {
	} else {
		eval [concat ::capPartReferencePrefixMismatch::capRunDrc $args]
	}
}

RegisterAction "_cdnCapCustomDRCElectricalAddItem" "capPartReferencePrefixMismatch_capTrueRunDrc" "" "capPartReferencePrefixMismatch_capPartReferencePrefixMismatchDrcData" ""

