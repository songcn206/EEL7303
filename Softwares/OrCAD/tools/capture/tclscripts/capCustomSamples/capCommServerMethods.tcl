#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCommServerMethod.tcl
#            contains OrCAD Capture Communication utilities through TCL socket interface
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4

package provide capCommServerMethod 1.0

namespace eval ::capCommServerMethod {
	
}

proc ::capCommServerMethod::SelectObject { pList } {
	# requires schematic view to be active 
	if { [IsSchematicViewActive] != 1 } {
		set lReturnValue [list "No schematic view active"]
		return $lReturnValue
	}
	
	set lX [lindex $pList 0]
	set lY [lindex $pList 1]
	
	set lStatus [DboState]
	
	::SelectObject $lX $lY FALSE
	
	set lReturnValue [::GetSelectedObjects]
	set lNullObj NULL
	
	if { [llength $lReturnValue] == 0 } {
		set lReturnValue [list "No Object for selection"]
	}
	
	$lStatus -delete
	
	return $lReturnValue
	 
}

proc ::capCommServerMethod::GetNet { pList } {
	set lWire [lindex $pList 0]
	
	set lStatus [DboState]
	set lReturnValue [list [$lWire GetNet $lStatus]]
	$lStatus -delete
	
	return $lReturnValue
}
	

proc ::capCommServerMethod::ModifyProperty { pList } {
	set lObject [lindex $pList 0]
	set lPropName [lindex $pList 1]
	set lPropValue [lindex $pList 2]
	
	set lPropNameCStr [DboTclHelper_sMakeCString $lPropName]
	set lPropValueCStr [DboTclHelper_sMakeCString $lPropValue]
	
	set lStatus [$lObject SetEffectivePropStringValue $lPropNameCStr $lPropValueCStr]
	
	if {[$lStatus OK] == 1} { 
		set lReturnValue [list "successful"]
	} else {
		set lReturnValue [list "failed"]
	}
	
	return $lReturnValue
	 
}

proc ::capCommServerMethod::GetEffectiveProps { pObject } {
	set lStatus [DboState]
	
	set lReturnValue [list]
	
	set lStatus [DboState]
	set pPropsIter [$pObject NewEffectivePropsIter $lStatus]
	
	set lPropName [DboTclHelper_sMakeCString]
	set lPropValue [DboTclHelper_sMakeCString]
	set lPropType [DboTclHelper_sMakeDboValueType]
	set lEditable [DboTclHelper_sMakeInt]
		
	set  lStatus [$pPropsIter NextEffectiveProp $lPropName $lPropValue $lPropType $lEditable]
	
	while {[$lStatus OK] == 1} {
		
		set lPropNameStr [DboTclHelper_sGetConstCharPtr $lPropName]
		set lPropValueStr [DboTclHelper_sGetConstCharPtr $lPropValue]
		
		lappend lReturnValue [list $lPropNameStr $lPropValueStr]
		
		set  lStatus [$pPropsIter NextEffectiveProp $lPropName $lPropValue $lPropType $lEditable]
	}
	delete_DboEffectivePropsIter $pPropsIter
	
	$lStatus -delete
	
	if { [llength $lReturnValue] == 0 } {
		set lReturnValue [list "No properties"]
	}
	
	return $lReturnValue
}

proc ::capCommServerMethod::GetProperties { pList } {
	set lObject [lindex $pList 0]
	set lNullObj NULL
	
	set lReturnValue [list [::capCommServerMethod::GetEffectiveProps $lObject]]
		
	return $lReturnValue
}

proc ::capCommServerMethod::DragSelectedObjects { pList } {
	# requires schematic view to be active 
	if { [IsSchematicViewActive] != 1 } {
		set lReturnValue [list "No schematic view active"]
		return $lReturnValue
	}
	
	set lX [lindex $pList 0]
	set lY [lindex $pList 1]
	
	::Drag $lX $lY TRUE
	
	set lReturnValue [list "successful"]
	
	return $lReturnValue
}

proc ::capCommServerMethod::GetSelectedObjects { pList } {
	
	# requires schematic view to be active 
	if { [IsSchematicViewActive] != 1 } {
		set lReturnValue [list "No schematic view active"]
		return $lReturnValue
	}
	
	set lReturnValue [list [::GetSelectedObjects]]
	
	if { [llength $lReturnValue] == 0 } {
		set lReturnValue [list "No Objects selected"]
	}
	
	return $lReturnValue
}


proc ::capCommServerMethod::GetAllPartInstancesOnPage { pList } {
	set lSchematicName [lindex $pList 0]
	set lPageName [lindex $pList 1]
	
	set lNullObj NULL
	set lPage [::capCommServerMethod::GetPage $lSchematicName $lPageName]
	if { $lPage == $lNullObj} {
		set lReturnValue [list "Page not found"]
		return $lReturnValue
	}
	
	#PartInsts
	set lReturnValue [list]
	set lStatus [DboState]
	set lPartInstsIter [$lPage NewPartInstsIter $lStatus]
	set lInst [$lPartInstsIter NextPartInst $lStatus]
	while {$lInst!=$lNullObj} {
	     lappend lReturnValue [list $lInst]
	      set lInst [$lPartInstsIter NextPartInst $lStatus]
	}
	delete_DboPagePartInstsIter $lPartInstsIter
	
	if { [llength $lReturnValue] == 0 } {
		set lReturnValue [list "No part instances on page"]
	}
	
	set lReturnValue [list $lReturnValue]
	
	return $lReturnValue
}

proc ::capCommServerMethod::GetPage { pSchematicName pPageName } {
	set lSession $::DboSession_s_pDboSession
	DboSession -this $lSession
	
	set lStatus [DboState]
	
	set lNullObj NULL
	
	 set lDesign [$lSession GetActiveDesign]
	 if { $lDesign == $lNullObj} {
		return NULL
	 }

	set lSchematicName [DboTclHelper_sMakeCString $pSchematicName]
	set lPageName [DboTclHelper_sMakeCString $pPageName]
	 
	set lSchematic [$lDesign GetSchematic $lSchematicName $lStatus]
	if {$lSchematic == $lNullObj} {
		return NULL
	}
	
	set lPage [$lSchematic GetPage $lPageName $lStatus]
	
	$lStatus -delete
	
	return $lPage
}

proc ::capCommServerMethod::PlaceWire { pList } {
	# requires schematic view to be active 
	if { [IsSchematicViewActive] != 1 } {
		set lReturnValue [list "No schematic view active"]
		return $lReturnValue
	}
	
	set lX1 [lindex $pList 0]
	set lY1 [lindex $pList 1]
	set lX2 [lindex $pList 2]
	set lY2 [lindex $pList 3]
	
	::PlaceWire $lX1 $lY1 $lX2 $lY2
	
	set lReturnValue [list "successful"]
	
	return $lReturnValue
}
