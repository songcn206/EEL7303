#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPspUtils.tcl
#            Base utilities
#/////////////////////////////////////////////////////////////////////////////////

package provide orPspUtils 1.0

proc correctUNCPath { pPath } {
    set lRet {}
    if {1 == [regexp {^\/\/(.*)} $pPath lAll lRemaining]} {
        append lRet "\\\\" $lRemaining
    } else {
        set lRet $pPath
    }
    return $lRet
}

