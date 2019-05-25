#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAppLaunchMenu.tcl
#            Automatically registers Accessory menu items for Tcl/Tk samples.
#/////////////////////////////////////////////////////////////////////////////////


proc capTrue {} {
    return true
}

proc capGetInstallMessage {} {
        return {
============================================================================================
This feature requires Tcl/Tk installation. We recommend ActiveState ActiveTcl version 8.4.
For more information refer to the document OrCAD_Capture_TclTk_Extensions.pdf in
<installation dir>\tools\capture\tclscripts
============================================================================================
}
}

proc capCheckPkg {args} {
    if { [catch {package require Tk 8.4}] } {
        set lMessage [DboTclHelper_sMakeCString [capGetInstallMessage]]
        DboState_WriteToSessionLog $lMessage
    } else {
        update
        wm withdraw .
        package require capAppLaunch
        capAppLaunch::launchForm $args
    }        
}

proc capOpenStartPage {args} {
    OpenStartPage
}

proc capAddAppLauncher {} {
    if { [GetLicenseString] != "" } {
		AddAccessoryMenu "Cadence Tcl/Tk Utilities" "Utilities..." "capCheckPkg"
    }
    AddAccessoryMenu "Cadence Tcl/Tk Utilities" "Start Page" "capOpenStartPage"	
}

RegisterAction "_cdnCapTclAddPageCustomMenu" "capTrue" "" "capAddAppLauncher" ""
RegisterAction "_cdnCapTclAddDesignCustomMenu" "capTrue" "" "capAddAppLauncher" ""


