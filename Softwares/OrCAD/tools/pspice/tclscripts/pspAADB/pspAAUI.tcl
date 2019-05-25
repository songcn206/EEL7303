#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAAUI.tcl
#            contains OrCAD PSpiceAA UI Tcl commands
#
#/////////////////////////////////////////////////////////////////////////////////

package require PSpiceAA 16.6.0
package provide pspAAUI 1.0


namespace eval ::pspAAUI {
}

proc ::pspAAUI::pspDesignTrue { args } {
	return 1;
}

proc ::pspAAUI::displayResults { pPath pName } {
	puts "Opening the results fileName: $pName"
 	pspAAOpenAssociated $pPath $pName
}

proc ::pspAAUI::selectAap { } {
	set pspAapFile [pspAASelectAap]
	return $pspAapFile
}

proc ::pspAAUI::getActiveAap { } {
	set pspAapFile [pspAAGetActiveAap]
	return $pspAapFile
}

proc ::pspAAUI::getAssociated { pPath } {
	return [pspAAGetAssociated $pPath]
}

proc ::pspAAUI::getActiveProfileList { pProfileList } {
	return [pspAAGetActiveProfileList $pProfileList]
}

