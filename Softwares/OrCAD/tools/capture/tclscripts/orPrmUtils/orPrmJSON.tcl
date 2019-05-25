#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmJSON.tcl
#            JSONizer utilities
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmDebug

package provide orPrmJSON 1.0

namespace eval orPrmJSON {

    variable nDebugLevels
    array set nDebugLevels { 
        JSON_ENCODE           0
    }    

    set nModuleName "JSON"

    orPrmDebug::setDebugLevels $nModuleName ::orPrmJSON::nDebugLevels
    orPrmDebug::enableDebug $nModuleName 0
}

proc orPrmJSON::encode {pTclList} {
    fDbg $orPrmJSON::nModuleName JSON_ENCODE
    foreach {lType lValue} $pTclList {
        switch $lType {
            object {
                set acc {}
                foreach {key lObject} $lValue {
                    set enc [encode $lObject]
                    lappend acc "\"$key\":$enc"
                }
                set acc [join $acc ","]
                return "{$acc}"
            }
            number { return $lValue }
            bool { return  $lValue }
            array {
                set lFlattened {}
                foreach {lObject} $lValue {
                    lappend lFlattened [encode $lObject]
                }
                set lFlattened [join $lFlattened ","]
                return "\[$lFlattened\]"
            }
            string { return "\"$lValue\"" }
        }
    }
}

proc orPrmJSON::decode {pJSON} {
    return {}
}

# end of file

