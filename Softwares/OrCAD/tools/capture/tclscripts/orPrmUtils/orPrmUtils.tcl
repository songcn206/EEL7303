#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmUtils.tcl
#            Base utilities
#/////////////////////////////////////////////////////////////////////////////////

package provide orPrmUtils 1.0

# safely retrieve values from a Tcl array
# if the key is not found, the default value 
# provided is returned
proc getValSafe { pArray pName {pDefault ""} } {
    upvar 1 $pArray lArray

    set lVal [array get lArray $pName]

    set lRet $pDefault
    if { [llength $lVal] > 0 } {
        set lRet [lindex $lVal 1]
    }
    return $lRet
}

proc escapeChars { pName } {
    return [string map {\\ \\\\} $pName]
}

proc rl { pkg } {
    namespace forget $pkg
    package forget $pkg
    package require $pkg
}

proc swap { lhs rhs } {
    upvar 1 $lhs left $rhs right
    set temp $left
    set right $left
    set left $temp
}

proc correctUNCPath { pPath } {
    set lRet {}
    if {1 == [regexp {^\/\/(.*)} $pPath lAll lRemaining]} {
        append lRet "\\\\" $lRemaining
    } else {
        set lRet $pPath
    }
    return $lRet
}

proc capGetLanguagePack {} {
	set lang [capGetThreeLetterLanguageCode]
	set lang [DboTclHelper_sGetConstCharPtr $lang]
	return $lang
}
