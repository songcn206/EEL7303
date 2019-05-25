#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - capRotate.tcl
#  This file contains OrCAD Capture Context Aware Rotation procedures

package require Tcl 8.4
package provide capGUIUtils 1.0

namespace eval ::capGUIUtils {
    namespace export capCARotateEnabler
    namespace export capCARotate

    RegisterAction "Context-Aware Rotate" "::capGUIUtils::capCARotateEnabler" "Ctrl+R" "::capGUIUtils::capCARotate" "Schematic"
}

proc ::capGUIUtils::capCARotateEnabler {} {
    set lEnableRotate 0
    # Get the selected objects
    set lSelObjs [GetSelectedObjects]

    # Enable only for single object selection
    if { [llength $lSelObjs] == 1 } {
        # Enable only if a part or a hierarchical block is selected
        set lObj [lindex $lSelObjs 0]
        set lObjType [DboBaseObject_GetObjectType $lObj]
        if { $lObjType == 12 || $lObjType == 13 } {
            set lEnableRotate 1
        }
    }
    return $lEnableRotate
}

proc ::capGUIUtils::capCARotate {} {
    # Note: this command will override the 
    #       current global rotation mode
    set lOrigOption [GetOptionBool RotateInstPropInContext]
    SetOptionBool RotateInstPropInContext ON
    Rotate
    SetOptionBool RotateInstPropInContext $lOrigOption
}

