#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCommClientMethod.tcl
#            contains OrCAD Capture Communication utilities through TCL socket interface
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capCommClientMethod 1.0

namespace eval ::capCommClientMethod {

}

proc ::capCommClientMethod::InitClient {host port} {
    set s [socket $host $port]
    fconfigure $s -buffering line
    return $s
}

proc ::capCommClientMethod::SelectObject { pX pY } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::SelectObject" [list $pX $pY]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}

proc ::capCommClientMethod::GetNet { pWire } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::GetNet" [list $pWire]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}

proc ::capCommClientMethod::GetProperties { pObject } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::GetProperties" [list $pObject]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}


proc ::capCommClientMethod::ModifyProperty { pObject pPropertyName pPropertyValue } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::ModifyProperty" [list $pObject $pPropertyName $pPropertyValue]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}


proc ::capCommClientMethod::DragSelectedObjects { pX pY } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::DragSelectedObjects" [list $pX $pY]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}


proc ::capCommClientMethod::GetAllPartInstancesOnPage { pSchematicName pPageName } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::GetAllPartInstancesOnPage" [list $pSchematicName $pPageName]]
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}

proc ::capCommClientMethod::PlaceWire { pX1 pY1 pX2 pY2 } {
	set s [InitClient localhost 9020]
	set lObj [list "::capCommServerMethod::PlaceWire" [list $pX1 $pY1 $pX2 $pY2]] 
	puts $s $lObj
	
	# wait for the data
	gets $s lReturnValue
	
	return $lReturnValue
}