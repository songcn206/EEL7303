#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomzePageInit.tcl
#/////////////////////////////////////////////////////////////////////////////////

proc capCustomizePageInit { } {

	set lEnablePageCustomization [GetOptionString "TCLEnablePageCustomization"]
	
	if { $lEnablePageCustomization == 1 } {
		if { [catch {package require capCustomizePageLaunch}] } {
		} else {
			catch {capCustomizePageLaunch::readINI}
			catch {capCustomizePageLaunch::registerActions}
		}
	}
	
}

capCustomizePageInit

