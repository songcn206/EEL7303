#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAAGuiTempSweepMc.tcl
#            contains OrCAD PSpiceAA Javascript GUI invocation for Temperature Sweep
#
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmWebComp
package require pspAAGuiOpenResults
package require pspAATempSweepMc 1.0
package require orPspUtils 1.0
package require pspAAUI 
package provide pspAAGuiTempSweepMc 1.0


namespace eval ::pspAAGuiTempSweepMc {
	variable tempSweepDlgId
	variable htmlPath [correctUNCPath [file normalize [file join [file dirname [info script]] .. hybrid PspAATempSweep.html]]] 
}

proc ::pspAAGuiTempSweepMc::runTempSweep { tempStart tempEnd tempStep } {
	::pspAATempSweepMc::runMCCustom $tempStart $tempEnd $tempStep
	orPrm::DestroyWidget $::pspAAGuiTempSweepMc::tempSweepDlgId
	::pspAAGuiOpenResults::execDisplayResults
}

proc ::pspAAGuiTempSweepMc::enable { } {
	return 1
}

proc ::pspAAGuiTempSweepMc::execTempSweep {} {
	set ::pspAAGuiTempSweepMc::tempSweepDlgId [orPrm::GetNextId]
	orPrm::CreateModalDialog $::pspAAGuiTempSweepMc::tempSweepDlgId $::pspAAGuiTempSweepMc::htmlPath {Run Temperature Sweep} 300 220 1
}

proc ::pspAAGuiTempSweepMc::updateMenu {} {
	return "true"
}


RegisterAction "_cdnPspAARunTempSweepMc" "::pspAAGuiTempSweepMc::enable" "" "::pspAAGuiTempSweepMc::execTempSweep" ""
RegisterAction "_cdnPspAAUpdateMenu" "::pspAAGuiTempSweepMc::enable" "" "::pspAAGuiTempSweepMc::updateMenu" ""


# call procedure
##::pspAAGuiTempSweepMc::execTempSweep

