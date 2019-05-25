#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmDebug.tcl
#            Debug utilities
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmUtils
package provide orPrmDebug 1.0

namespace eval orPrmDebug {
    variable nDebugLevels
    array set nDebugLevels {}

    variable nDebugEnables
    array set nDebugEnables {}
}

proc orPrmDebug::fDbg { pModule pDbg {pStr ""} } {
    variable nDebugLevels
    variable nDebugEnables
    set lEnabled [getValSafe nDebugEnables $pModule 1]
    
    if { 1 == $lEnabled } {
        set lKey "$pModule,$pDbg"
        set lSet [getValSafe nDebugLevels $lKey]
        
        if { $lSet == 1 } {
            set l [info level]
            set lCaller [expr $l - 1]
            puts stderr "($pModule:$lCaller):[string repeat " " $lCaller] [info level $lCaller] >>> $pStr <<<"
            flush stderr
        }
    }
}

proc orPrmDebug::setDebugLevels { pModule pDebugLevels } {
    variable nDebugLevels
    
    foreach {key value} [array get $pDebugLevels] {
        set nDebugLevels($pModule,$key) $value
    }
}


proc orPrmDebug::enableDebug { pModule {pEnable 1} } {
   variable nDebugEnables
   set nDebugEnables($pModule) $pEnable
}

interp alias {} fDbg {} orPrmDebug::fDbg

# sample usage:
# namespace eval orPrmJSON {
# 
#     variable nDebugLevels
#     array set nDebugLevels { 
#         JSON_ENCODE           0
#     }    
# 
#     set nModuleName "JSON"
# 
#     orPrmDebug::setDebugLevels $nModuleName ::orPrmJSON::nDebugLevels
#     orPrmDebug::enableDebug $nModuleName 0
# }
# 
# proc orPrmJSON::test {} {
#     fDbg $::orPrmJSON::nModuleName JSON_ENCODE "hello"
# }

# end of file

