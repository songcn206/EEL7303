#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAdvancedSaveInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capAdvancedSave_capOnSaveFile { args } {
	if { [catch {package require capAdvancedSave}] } {
	} else {
		eval [concat ::capAdvancedSave::capOnSaveFile $args]
	}
}

proc capAdvancedSave_capOnArchive { args } {
	if { [catch {package require capAdvancedSave}] } {
	} else {
		eval [concat ::capAdvancedSave::capOnArchive $args]
	}
}



