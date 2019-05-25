#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - capZOrder.tcl
#  This file contains OrCAD Capture Non-electrical shapes Z 
#  ordering procedures

package require Tcl 8.4
package provide capZOrder 1.0

namespace eval ::capZOrder {
}

proc ::capZOrder::capIsOrderable {} {
    set lRet 1

    set lSelObjs [GetSelectedObjects]
    
    if { "" == $lSelObjs } {
        set lRet 0
    } else {
        foreach lObj $lSelObjs {
            set lType [$lObj GetObjectType] 
            if { $lType != $::DboBaseObject_GRAPHIC_BOX_INST
                && $lType != $::DboBaseObject_GRAPHIC_LINE_INST
                && $lType != $::DboBaseObject_GRAPHIC_ARC_INST
                && $lType != $::DboBaseObject_GRAPHIC_ELLIPSE_INST
                && $lType != $::DboBaseObject_GRAPHIC_POLYGON_INST
                && $lType != $::DboBaseObject_GRAPHIC_POLYLINE_INST
                && $lType != $::DboBaseObject_GRAPHIC_COMMENTTEXT_INST
                && $lType != $::DboBaseObject_GRAPHIC_BITMAP_INST } {
                set lRet 0
                break
            }
        }
    }
    return $lRet
}

proc ::capZOrder::enable {} {
    catch {
        RegisterAction "Send To Back" ::capZOrder::capIsOrderable "" SendToBack SCHEMATIC
    }
    
    catch {
        RegisterAction "Send Backward" ::capZOrder::capIsOrderable "" SendBackward SCHEMATIC
    }
    
    catch {
        RegisterAction "Bring To Front" ::capZOrder::capIsOrderable "" BringToFront SCHEMATIC
    }
    
    catch {
        RegisterAction "Bring Forward" ::capZOrder::capIsOrderable "" BringForward SCHEMATIC
    }    
}

proc ::capZOrder::disable {} {
    catch {
        UnregisterAction "Send To Back"
    }
    
    catch {
        UnregisterAction "Send Backward"
    }
    
    catch {    
        UnregisterAction "Bring To Front"
    }
    
    catch {    
        UnregisterAction "Bring Forward"
    }    
}

