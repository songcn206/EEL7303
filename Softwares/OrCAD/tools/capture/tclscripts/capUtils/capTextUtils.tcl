#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capTextUtils.tcl
#            Contains OrCAD Capture text formatting and helper functions
#/////////////////////////////////////////////////////////////////////////////////

package provide capTextUtils 1.0

namespace eval capTextUtils {
    array set nCharWidthFactors {
        i                       0.5
        fjl                     0.6
        -rt\[\]().              0.7
        zec                     0.8
        qgxao                   0.9
        +snhudpbkyv_1234567890  1.0
        w                       1.3
        m                       1.5
        I                       0.8
        J                       0.9
        S                       1.0
        Z                       1.1
        PLF                     1.2
        QOAVBTEC                1.3
        GUYR                    1.4
        NHXDK                   1.5
        MW                      1.8
    }
}

proc capTextUtils::computeTextWidth { pText pFactor } {
    set lWidth 0
    set lLen [string length $pText]
    for {set lIdx 0} {$lIdx < $lLen} {incr lIdx} {
        set lChar "*"
        append lChar [string index $pText $lIdx] "*"
        set lRet [array get capTextUtils::nCharWidthFactors $lChar]
        set lCharWidth 1
        if {[llength $lRet] > 0} {
            set lCharWidth [lindex $lRet 1]
        }
        set lWidth [expr $lWidth + $lCharWidth]
    }
    set lWidth [expr $lLen * $pFactor * $lWidth]
    puts "$pText - $lWidth"
    return $lWidth
}

# end of file

