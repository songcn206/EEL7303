#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCorrectNetInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capNetNamesCorrection_enable {args}  {
	return 1
}

proc capNetNamesCorrection_correctName {args}  {
	if { [catch {package require capNetNamesCorrection}] } {
	} else {
		eval [concat ::capNetNamesCorrection::correctName $args]
	}
}

RegisterAction "_cdnReplaceNetNames"  "capNetNamesCorrection_enable" "" "capNetNamesCorrection_correctName" "" 

