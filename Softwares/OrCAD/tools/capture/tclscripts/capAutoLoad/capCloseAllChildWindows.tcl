#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCloseAllChildWindows.tcl
#/////////////////////////////////////////////////////////////////////////////////

package provide capCloseAllChildWindows 1.0

namespace eval ::capCloseAllChildWindows {

    proc registerMenuActions { args } {
	    catch {
		RegisterAction "OnCloseChildWindows"   "::capCloseAllChildWindows::shouldProcess" "" "capCloseChildViews" ""
		RegisterAction "OnCloseChildWindowsExceptCurrent" "::capCloseAllChildWindows::shouldProcess" "" "capCloseChildViewsExceptCurrent" "" 
		RegisterAction "OnUpdateCloseChildWindows"   "::capCloseAllChildWindows::shouldProcess" "" "::capCloseAllChildWindows::EnableAllWindowCloseMenu" ""
		RegisterAction "OnUpdateCloseChildWindowsExceptCurrent"   "::capCloseAllChildWindows::shouldProcess" "" "::capCloseAllChildWindows::EnableAllButCurrentWindowCloseMenu" ""
	    }
	}
    
    proc shouldProcess { args } {
        return 1
    }
    
    proc EnableAllWindowCloseMenu { args } {
	set lIsEnabled [::EnableAllWindowCloseMenu]
	if { $lIsEnabled == 1 } {
		return true
	}
	
	return false
		
    }
    
     proc EnableAllButCurrentWindowCloseMenu { args } {
	set lIsEnabled [::EnableAllButCurrentWindowCloseMenu]
	if { $lIsEnabled == 1 } {
		return true
	}
	
	return false
		
    }
    
}

::capCloseAllChildWindows::registerMenuActions

# end of file


