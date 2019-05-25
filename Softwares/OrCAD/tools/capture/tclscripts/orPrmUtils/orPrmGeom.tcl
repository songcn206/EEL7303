#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmGeom.tcl
#            Common Geometry Utilities
#/////////////////////////////////////////////////////////////////////////////////

package provide orPrmGeom 1.0

namespace eval orPrmGeom {
    variable PI 3.1415926535897931
}

proc orPrmGeom::x {pPoint} {
    return [lindex $pPoint 0]
}

proc orPrmGeom::y {pPoint} {
    return [lindex $pPoint 1]
}

proc orPrmGeom::topLeft { pBBox } {
    return [lindex $pBBox 0]
}

proc orPrmGeom::bottomRight { pBBox } {
    return [lindex $pBBox 1]
}

proc orPrmGeom::left { pBBox } {
    return [x [topLeft $pBBox]]
}

proc orPrmGeom::top { pBBox } {
    return [y [topLeft $pBBox]]
}

proc orPrmGeom::right { pBBox } {
    return [x [bottomRight $pBBox]]
}

proc orPrmGeom::bottom { pBBox } {
    return [y [bottomRight $pBBox]]
}

proc orPrmGeom::pointEquals { pPt1 pPt2 } {
    set lRet 0
    if {[x $pPt1] == [x $pPt2] && [y $pPt1] == [y $pPt2]} {
        set lRet 1
    }
    return $lRet
}

proc orPrmGeom::offsetPoint { pPt pXOffset pYOffset } {
    return [list [expr [x $pPt] + $pXOffset] [expr [y $pPt] + $pYOffset]]
}

proc orPrmGeom::offsetPointByPoint { pPt pOffsetPt } {
    return [offsetPoint $pPt [x $pOffsetPt] [y $pOffsetPt]]
}

proc orPrmGeom::boxEquals { pBox1 pBox2 } {
    set lRet 0
    if { 1 == [pointEquals [topLeft $pBox1] [topLeft $pBox2]] && 1 == [pointEquals [bottomRight $pBox1] [bottomRight $pBox2]] } {
        set lRet 1
    }
    return $lRet
}

proc orPrmGeom::expandBox { pBox x y  } {
    return [list [topLeft $pBox] [offsetPoint [bottomRight $pBox] $x $y]]
}

proc orPrmGeom::bboxUnion {pBBox1 pBBox2} {
    set lTopLeft [list [expr [left $pBBox1] + [left $pBBox2]] [expr [top $pBBox1] + [top $pBBox2]]]
    set lBottomRight [list [expr [right $pBBox1] + [right $pBBox2]] [expr [bottom $pBBox1] + [bottom $pBBox2]]]        
    return [list $lTopLeft $lBottomRight]
}

proc orPrmGeom::width {pBBox} {
    return [expr abs([left $pBBox] - [right $pBBox])]
}

proc orPrmGeom::height {pBBox} {
    return [expr abs([top $pBBox] - [bottom $pBBox])]
}    

proc orPrmGeom::center {pBBox} {
    set lCenterX [expr [left $pBBox] + [width $pBBox]/2]
    set lCenterY [expr [top $pBBox] + [height $pBBox]/2]
    return [list $lCenterX $lCenterY]
}

proc orPrmGeom::computeAngle { pRef pPoint } {
    variable PI

    # Figure out where the point is if we transform reference to 0,0
    set canonX [expr [x $pPoint] - [x $pRef]]
    set canonY [expr [y $pRef] - [y $pPoint]]
    set angle 0

    if {0 == $canonX} {
    # vertical ?
        if {0 != $canonY} {
            if {$canonY < 0} {
                set angle [expr $PI * 3 / 2]
            } else {
                set angle [expr $PI / 2]
            }
        } else {
            set angle  0
        }
    } elseif {0 == $canonY} {
        if {$canonX < 0} {
            set angle $PI
        } else {
            set angle 0
        }
    } else {
        set angle [expr {atan2($canonY, $canonX)}]

        # Now turn it into angle between 0 and 360
        if {$angle < 0} {
            set angle [expr {$angle + 2 * $PI}]
        }
    }
    return $angle
}

proc orPrmGeom::computeArcAttributes { pBox pStart pEnd } {
    variable PI

    set lAntiClk true

    set lCenter [center $pBox]
    set lStartAngle [computeAngle $lCenter  $pStart]
    set lEndAngle [computeAngle $lCenter $pEnd]
    set lRadius [expr [width $pBox]/2]

    set lStartDegrees  $lStartAngle
    set lEndDegrees  $lEndAngle

    if { $lStartDegrees > $lEndDegrees} {
        set lEndDegrees  $lStartAngle
        set lStartDegrees  $lEndAngle
        set lAntiClk false
    }

    if {$lStartDegrees != 0} {
        set lStartDegrees  [expr {2 * $PI - $lStartDegrees}]
    }

    if {$lEndDegrees != 0} {
        set lEndDegrees  [expr {2 * $PI - $lEndDegrees}]
    }

    set lStartAngle $lStartDegrees
    set lEndAngle $lEndDegrees

    return [list $lStartAngle $lEndAngle $lAntiClk $lRadius]
}

# end of file

