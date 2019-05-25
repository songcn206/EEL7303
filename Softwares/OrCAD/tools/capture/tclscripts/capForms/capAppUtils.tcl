#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAppLaunch.tcl
#            Sample Tcl/Tk Application Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////

namespace eval capAppUtils {
    variable nScriptsDirPath ""
    variable nScriptsDirName "tclscripts"
}

package provide capAppUtils 1.0

proc capAppUtils::capTopLevel { pWindow } {
    toplevel $pWindow
    bind  $pWindow <Key-F5> [subst {wm withdraw $pWindow ; wm deiconify $pWindow}]
    return $pWindow
}

proc capAppUtils::showError { pTitle pError } {
    if { [catch {package require Tk 8.4}] } {
        puts $pError
    } else {
        tk_messageBox \
            -title $pTitle \
            -message $pError \
            -type ok                
    }
}

proc capAppUtils::safeInvoker {pCommandName args} {
    append lQualifiedCmdName "::" $pCommandName
    if { "" == [info proc $lQualifiedCmdName] } {
        showError "Script Error" "ERROR : $lQualifiedCmdName not defined"
    } else {
        if { [catch {eval $lQualifiedCmdName $args}] } {
            showError "Script Error" "ERROR : $::errorInfo"
        }
    }
}

proc capAppUtils::getScriptsDir {} {
    if { $::capAppUtils::nScriptsDirPath == "" } {
        set ::capAppUtils::nScriptsDirPath [file join [file dirname [info nameofexecutable]] $::capAppUtils::nScriptsDirName]
    }
    return $::capAppUtils::nScriptsDirPath
}

proc capAppUtils::isGeomNegative { pWindow } {
 set lResult [regexp -- {([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)} [wm geometry $pWindow] -> width height decorationLeft decorationTop]
 
 # if regexp failed, that means decorationLeft or decorationTop is negative
 if {$lResult ==  0} {
	return 1
 }
 
 #puts "Geometry is positive"
 return 0
}


proc capAppUtils::autoAdoptWindow { pWindow } {
    set l [array get ::env ORCAD_CAPTCL_ADOPT_CHILD]
	
    if { 0 != [llength $l] } {
	if { 1 == [string match -nocase "false" [lindex $l 1]] 
	 ||  1 == [string match -nocase "0" [lindex $l 1]]} {
	    return
	}
    }	    
	
    wm attributes $pWindow -toolwindow 1 
    update
    SetAppWindowAsParent [GetParent [winfo id $pWindow]]	
    
    #test -> wm geometry $pWindow -1000+0
    
    if { [capAppUtils::isGeomNegative $pWindow] == 1 } {
	#puts "resetting the geomtery to (0, 0)"
	
	wm geometry $pWindow +0+0
	
	# reset the geometry to 0,0
	set lPathName [winfo pathname [winfo id $pWindow]]
	set lCommand "wm geometry $lPathName +0+0"
	after idle $lCommand
    }
}

proc capAppUtils::getDPI { } {
	set lDPI [winfo fpixels . 1i]
	#puts "DPI is $lDPI"
	return $lDPI
}

proc capAppUtils::getDPIScaledValue { pValue } {
	
	 set l [array get ::env ORCAD_CAPTCL_IGNORE_DPI_SCALING]
	
	    if { 0 != [llength $l] } {
		if { 1 == [string match -nocase "true" [lindex $l 1]] 
		 ||  1 == [string match -nocase "1" [lindex $l 1]]} {
		    return $pValue
		}
	    }	    
	
	set lDPI [capAppUtils::getDPI]
	set lMultiplier [expr "$lDPI/96.0"]
	
	if { $lMultiplier < 1 } { 
		set lMultiplier 1
	}
	
	set lScaledValue [expr "round(ceil($pValue*$lMultiplier))"]
	#puts "$pValue ->>>> $lScaledValue"
	
	return $lScaledValue
}

proc capAppUtils::setWindowSize { pWindow pMinX pMinY pMaxX pMaxY } {
	
	wm minsize $pWindow [getDPIScaledValue $pMinX] [getDPIScaledValue $pMinY]
	wm maxsize $pWindow [getDPIScaledValue $pMaxX] [getDPIScaledValue $pMaxY]
}

# end of file

