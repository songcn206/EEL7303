#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: caplearningresources.tcl
#            Automatically registers Learning Resources menu items.
#/////////////////////////////////////////////////////////////////////////////////


proc learningResources_DummyTrue { args } {
    return true
}

proc learningResources_openApp { args } {
	if { [catch {package require learningResources}] } {
	} else {
		eval [concat ::learningResources::openApp $args]
	}
}

proc learningResources_addMenu { } {
	RegisterAction "_OpenBasic" "learningResources_DummyTrue" "" "learningResources_openApp" "" 
	RegisterAction "procTrueOnlearningResources" "learningResources_DummyTrue" "" "learningResources_DummyTrue" ""
	InsertXMLMenu [list [list "Help" "LearningResources"] "0" "HelpLearningOrCADCapture" [list "action" "Learning &PSpice"  "0" "_OpenBasic" "procTrueOnlearningResources" ]]
	DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Adding Learning Resources ... under Help Menu"]
}

learningResources_addMenu
