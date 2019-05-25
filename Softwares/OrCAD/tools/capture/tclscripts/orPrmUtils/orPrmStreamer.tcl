#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmStreamer.tcl
#            Common object streamers
#/////////////////////////////////////////////////////////////////////////////////

package provide orPrmStreamer 1.0

namespace eval orPrmStreamer {
}

proc orPrmStreamer::streamString { pString } {
    return [list string $pString]
}

proc orPrmStreamer::streamNumber { pNumber } {
    return [list number $pNumber]
}

proc orPrmStreamer::streamBool { pBool } {
    set lBool true

    if { 1 == [string is false $pBool] } {
        set lBool false
    }
    return [list bool $lBool]
}

proc orPrmStreamer::streamObject { pObject } {
    return [list object $pObject]
}

proc orPrmStreamer::streamArray { pList } {
    return [list array $pList]
}

# end of file

