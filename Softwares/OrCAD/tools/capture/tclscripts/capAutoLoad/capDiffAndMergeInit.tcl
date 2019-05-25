#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDiffAndMergeInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capDifferenceViewer_capLaunchWidget { args } {
	if { [catch {package require capDifferenceViewer}] } {
	} else {
		eval [concat ::capDifferenceViewer::capLaunchWidget $args]
	}
}

