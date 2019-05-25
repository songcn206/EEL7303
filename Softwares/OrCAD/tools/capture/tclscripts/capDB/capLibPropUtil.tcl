#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capLibPropUtil.tcl
#            contains OrCAD Capture Library data sanity checking and correction 
#            procedures
#
# You can run the script either in the Capture TCL command window or in standalone TCL shell.
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g. source d:/workdata/capture/dbcheck/Published/capLibPropUtil.tcl
#
#
#Steps for running the script in Standalone TCL shell
#1. load <orDb_Dll_Tcl.dll path> DboTclWriteBasic
#    e.g. load C:/Cadence/SPB_16.3/tools/Capture/orDb_Dll_Tcl DboTclWriteBasic
#    (In this case, please make sure that C:/Cadence/SPB_16.3/tools/bin is present in the Path environment variable, because the dependent dll orDb_Dll is picked up from that location)
#2. source <script path>
#    e.g. source d:/workdata/capture/dbcheck/Published/capLibPropUtil.tcl
#
#
#3. capLibPropUtil::add_prop_lib <olb path> <log file path> <prop name> <prop value> <?force>
#    e.g. capLibPropUtil::del_prop_lib <olb path> <log file path> <prop name>
#    e.g. capLibPropUtil::make_display_prop <olb path> <log file path> <prop name> <dispType 1>  <rotation 0> <color 48>


#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capLibPropUtil 1.0

namespace eval ::capLibPropUtil {
    namespace export add_prop_lib
    namespace export del_prop_lib
    namespace export make_display_prop
}

proc write_to_logfile {logf msg} {
    set NullObject NULL
    set fp [open $logf {a+}]
    if {$fp!=$NullObject} {
	puts $fp $msg
	close $fp
    } else {
	puts $msg
    }
}

proc ::capLibPropUtil::addp_iter {logf  partsIter pPropName pPropValue force} {
    

    set lStatus [DboState] 
    set NullObject NULL

    set lpart [$partsIter Next $lStatus]
    while {$lpart != $NullObject} {
	set prev [DboTclHelper_sMakeCString ]
	set lname [DboTclHelper_sMakeCString ]
	set result [DboTclHelper_sMakeCString ]
	$lpart GetName $lname
	set lname [DboTclHelper_sGetConstCharPtr $lname] 
	if {$force!="force"} {
	    $lpart GetEffectivePropStringValue $pPropName $prev
	    set prev [DboTclHelper_sGetConstCharPtr $prev]
	    if {$prev==$NullObject|$prev==""} {
		set lStatus [$lpart SetEffectivePropStringValue $pPropName $pPropValue]
		if { [$lStatus Succeeded] } {
		    set msg "adding property: ok"
		}	else {
		    set msg "adding property: failed"
		}
	    }   else {
		set msg "non empty prop already exists -- skipping"
	    }
	}  else {	    
	    set lStatus [$lpart SetEffectivePropStringValue $pPropName $pPropValue]	    
	    if { [$lStatus Succeeded] } {
		set msg "adding property: ok"
	    }	else {
		set msg "adding property: failed"
	    }
	}
	write_to_logfile $logf [concat $lname $msg]
	set lpart [$partsIter Next $lStatus]
    }
}


proc ::capLibPropUtil::add_prop_lib {pLibName logf pPropName pPropValue {force ""}} {     

   
    set lSession $::DboSession_s_pDboSession
    DboSession -this $lSession
    set lStatus [DboState]
    set NullObject NULL
   
    set pLibName [DboTclHelper_sMakeCString $pLibName]
    set pPropName [DboTclHelper_sMakeCString $pPropName]
    set pPropValue [DboTclHelper_sMakeCString $pPropValue]

    set lLib [$lSession GetOpenLib $pLibName $lStatus]
    if { $lLib != $NullObject} {
	write_to_logfile $logf "Library is open: please close to run this script"
	#puts  "Library is open: please close to run this script"
	return
    }
    set lLib [$lSession GetLib $pLibName $lStatus]
    if { $lLib == $NullObject} {
	write_to_logfile $logf "Can't open library"
	return
    }

    set partsIter [$lLib NewPartsIter $lStatus]
    addp_iter $logf $partsIter $pPropName $pPropValue $force
    set symsIter [$lLib NewSymbolsIter $lStatus]
    addp_iter $logf $symsIter $pPropName $pPropValue $force

    $lSession MarkAllLibForSave $lLib
    $lSession SaveLib $lLib
    $lSession RemoveLib $lLib
    DboTclHelper_sReleaseAllCreatedPtrs
    
   

}



proc ::capLibPropUtil::delp_iter {logf partsIter pPropName} {
    
    set lStatus [DboState] 
    set NullObject NULL
    set lpart [$partsIter Next $lStatus]
    while {$lpart != $NullObject} {
	set prev [DboTclHelper_sMakeCString ]
	set lname [DboTclHelper_sMakeCString ]
	$lpart GetName $lname
	set lname [DboTclHelper_sGetConstCharPtr $lname] 
	$lpart GetEffectivePropStringValue $pPropName $prev
	set prev [DboTclHelper_sGetConstCharPtr $prev]
	set msg1 ""
	if {$prev!=$NullObject&$prev!=""} {
	    set disProp [$lpart GetDisplayProp $pPropName $lStatus]
	    if {$disProp != $NullObject} {
		set lpart [DboBaseObjectToDboLibObject $lpart]
		set lpart [DboLibObjectToDboGraphicObject $lpart]
		set lpart [DboGraphicObjectToDboSymbol $lpart]

		#set lStatus [$lpart DeleteDisplayProp $disProp]
		$disProp SetDisplayType 0

	    }
	    set $lStatus [$lpart DeleteEffectiveProp $pPropName]

	    if { [$lStatus Succeeded] } {

		set msg1 "removing property: ok"
	    }	else {
		set msg1 "removing property: failed"
	    }
	    	    
	    write_to_logfile $logf [concat $lname $msg1 ]
	}   else {
	    write_to_logfile $logf [concat $lname "prop does not exist"]
	}
	
	set lpart [$partsIter Next $lStatus]
    }
}


# usage: del_prop_lib libname propname
proc ::capLibPropUtil::del_prop_lib {pLibName logf pPropName } {

  
    set lSession $::DboSession_s_pDboSession
    DboSession -this $lSession
    set lStatus [DboState]
    set NullObject NULL

 
    set pLibName [DboTclHelper_sMakeCString $pLibName]
    set pPropName [DboTclHelper_sMakeCString $pPropName]

    set lLib [$lSession GetOpenLib $pLibName $lStatus]
    if { $lLib != $NullObject} {
	write_to_logfile $logf "Library is open: please close to run this script"
	return
    }
    set lLib [$lSession GetLib $pLibName $lStatus]
    if { $lLib == $NullObject} {
	write_to_logfile $logf "Can't open library"
	return
    }
    
    set partsIter [$lLib NewPartsIter $lStatus]
    delp_iter $logf $partsIter $pPropName 
    set symsIter [$lLib NewSymbolsIter $lStatus]
    delp_iter $logf $symsIter $pPropName 

    $lSession MarkAllLibForSave $lLib
    $lSession SaveLib $lLib
    $lSession RemoveLib $lLib
   

    DboTclHelper_sReleaseAllCreatedPtrs
}

proc ::capLibPropUtil::get_default_disp_prop_location {lpart} {
    set lStatus [DboState] 
    set NullObject NULL

    set bbox [$lpart GetBoundingBox]

    set location [DboTclHelper_sGetCRectBottomRight $bbox]

    set locx [DboTclHelper_sGetCPointX $location]
    set locy [DboTclHelper_sGetCPointY $location]

    set dpiter [$lpart NewDisplayPropsIter $lStatus]

    set dp [$dpiter NextProp $lStatus]
    while {$dp != $NullObject} {

	set brpt [$dp GetLocation $lStatus]

	#puts $bbox
	#set brpt [DboTclHelper_sGetCRectBottomRight $bbox]
	set yoff [DboTclHelper_sGetCPointY $brpt]
	if {[expr $yoff] > [expr $locy]} {
	    set locy $yoff
	}
	set dp [$dpiter NextProp $lStatus]
    }
    set location [DboTclHelper_sMakeCPoint [expr $locx] [expr $locy + 10]]
    return $location
}

proc ::capLibPropUtil::mkdisp_iter {logf partsIter pPropName dispType  rotation color locx locy} {


    set lStatus [DboState] 
    set NullObject NULL
    set lpart [$partsIter Next $lStatus]

    
    while {$lpart != $NullObject} {
	
	set lname [DboTclHelper_sMakeCString ]
	$lpart GetName $lname
	set lname [DboTclHelper_sGetConstCharPtr $lname] 

	set prev [DboTclHelper_sMakeCString ]
	$lpart GetEffectivePropStringValue $pPropName $prev
	set prev [DboTclHelper_sGetConstCharPtr $prev]
	if {$prev==$NullObject|$prev=={} } { 
	    write_to_logfile $logf [concat $lname "User property not present"]
	    set lpart [$partsIter Next $lStatus]
	    continue
	}

	
	set disProp [$lpart GetDisplayProp $pPropName $lStatus]
       	
	if {$disProp != $NullObject} {
	    $disProp SetDisplayType [expr $dispType]
	    write_to_logfile $logf [concat $lname "modifying display prop"]
	} else {

	    if {$locx != 0 | $locy != 0} {
	    	set location [DboTclHelper_sMakeCPoint [expr $locx] [expr $locy]]
	    } else {

	    	set location [get_default_disp_prop_location $lpart]
	    }
	    #set location [DboTclHelper_sMakeCPoint [expr $locx] [expr $locy]]
	    set logfont [DboTclHelper_sMakeLOGFONT]
	    set disProp [$lpart NewDisplayProp $lStatus $pPropName $location [expr $rotation] $logfont $color]
	    $disProp SetDisplayType [expr $dispType]
	    write_to_logfile $logf [concat $lname "displayed property"]
	} 
	set lpart [$partsIter Next $lStatus]
    }
}


# to make a user property a display property
# the property must already be present
proc ::capLibPropUtil::make_display_prop {pLibName logf pPropName {dispType 1}  {rotation 0} {color 48} {locx 0} {locy 0}} {


    set lSession $::DboSession_s_pDboSession
    DboSession -this $lSession
    set lStatus [DboState]
    set NullObject NULL

    set pLibName [DboTclHelper_sMakeCString $pLibName]
    set pPropName [DboTclHelper_sMakeCString $pPropName]
    
    set lLib [$lSession GetOpenLib $pLibName $lStatus]

 
    if { $lLib != $NullObject} {
	write_to_logfile $logf "Library is open: please close to run this script"
	return
    }

    set lLib [$lSession GetLib $pLibName $lStatus]
    if { $lLib == $NullObject} {
	write_to_logfile $logf "Can't open library"
	return
    }

    set partsIter [$lLib NewPartsIter $lStatus]

    mkdisp_iter $logf $partsIter $pPropName $dispType $rotation $color $locx $locy
    set symsIter [$lLib NewSymbolsIter $lStatus]
    mkdisp_iter $logf $symsIter $pPropName $dispType $rotation $color $locx $locy

    $lSession MarkAllLibForSave $lLib
    $lSession SaveLib $lLib
    $lSession RemoveLib $lLib


    DboTclHelper_sReleaseAllCreatedPtrs

    
}