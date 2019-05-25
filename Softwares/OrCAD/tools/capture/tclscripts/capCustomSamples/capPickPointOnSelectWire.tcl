#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#  TCL file: capPickPointOnSelectWire.tcl
#
#/////////////////////////////////////////////////////////////////////////////////


package require Tcl 8.4
package provide capPickPointOnSelectWire 1.0

namespace eval ::capPickPointOnSelectWire {
	variable mPickPositionX
	variable mPickPositionY
}

set ::capPickPointOnSelectWire::mPickPositionX "-1"
set ::capPickPointOnSelectWire::mPickPositionY "-1"
	
proc ::capPickPointOnSelectWire::pickPoint { pCommandName } {    
	 
	set lSelectedObjects [GetSelectedObjects]
	
	if { [llength $lSelectedObjects] == 1} {
		set lObject [lindex $lSelectedObjects 0]
		
		set lObjectType [$lObject GetObjectType] 
		
		if {$lObjectType == $::DboBaseObject_WIRE_SCALAR} { 
			
			if {[catch {set lPickPosition [GetLastMouseClickPointOnPage]} lResult] } {
			} else {
				set ::capPickPointOnSelectWire::mPickPositionX [lindex $lPickPosition 0]
				set ::capPickPointOnSelectWire::mPickPositionY [lindex $lPickPosition 1]
				
				set lMessage [concat "Wire has been selected at point " $::capPickPointOnSelectWire::mPickPositionX " " $::capPickPointOnSelectWire::mPickPositionY]
				set lCommandName [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lCommandName
			}
		}
	}
	
	DboTclHelper_sReleaseAllCreatedPtrs
	
	return
}

proc ::capPickPointOnSelectWire::needsCallback { pCommandName } {
	
	set ret 0
	
	if {$pCommandName=="OnLButtonUp"} {
		set ret 1
	} 
	
	return $ret
}

proc ::capPickPointOnSelectWire::registerCommandListener {} {
    RegisterAction "_cdnOrSchViewCmdComplete" "::capPickPointOnSelectWire::needsCallback" "" "::capPickPointOnSelectWire::pickPoint" ""
}

::capPickPointOnSelectWire::registerCommandListener
