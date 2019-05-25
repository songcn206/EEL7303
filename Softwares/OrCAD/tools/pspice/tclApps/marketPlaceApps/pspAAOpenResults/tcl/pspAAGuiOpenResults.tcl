#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAAGuiOpenResults.tcl
#            contains OrCAD PSpiceAA Javascript GUI invocation for Opening Associated Profiles
#
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmWebComp
package require orPspUtils 1.0
package provide pspAAGuiOpenResults 1.0


namespace eval ::pspAAGuiOpenResults {
	variable displayResultDlgId
	variable htmlPath [correctUNCPath [file normalize [file join [file dirname [info script]] .. hybrid PspAAOpenResults.html]]] 
}

proc ::pspAAGuiOpenResults::enable { } {
	return 1
}

proc ::pspAAGuiOpenResults::execDisplayResults {} {
	set ::pspAAGuiOpenResults::displayResultDlgId [orPrm::CreateWidget $::orPrm::::WTYPE_CONTROLBAR]
	orPrm::SetTitle $::pspAAGuiOpenResults::displayResultDlgId "Associated Profiles"
	orPrm::LoadResource $::pspAAGuiOpenResults::displayResultDlgId $::pspAAGuiOpenResults::htmlPath 
	##orPrm::SetSize $::pspAAGuiOpenResults::displayResultDlgId 200 300
	orPrm::ShowWidget $::pspAAGuiOpenResults::displayResultDlgId 1
}

proc ::pspAAGuiOpenResults::updateMenu {} {
	return "true"
}


RegisterAction "_cdnPspAADisplayResults" "::pspAAGuiOpenResults::enable" "" "::pspAAGuiOpenResults::execDisplayResults" ""
RegisterAction "_cdnPspAAUpdateMenu" "::pspAAGuiOpenResults::enable" "" "::pspAAGuiOpenResults::updateMenu" ""


# call procedure
##::pspAAGuiOpenResults::execDisplayResults

