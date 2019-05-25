#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capGeom.tcl
#            Contains generic tcl geometry helper functions
#/////////////////////////////////////////////////////////////////////////////////

package provide capGeom 1.0

namespace eval capGeom {
    proc x {pPoint} {
        return [lindex $pPoint 0]
    }
    
    proc y {pPoint} {
        return [lindex $pPoint 1]
    }
    
    proc topLeft { pBBox } {
        return [lindex $pBBox 0]
    }
    
    proc bottomRight { pBBox } {
        return [lindex $pBBox 1]
    }
    
    proc left { pBBox } {
        return [x [topLeft $pBBox]]
    }
    
    proc top { pBBox } {
        return [y [topLeft $pBBox]]
    }
    
    proc right { pBBox } {
        return [x [bottomRight $pBBox]]
    }
    
    proc bottom { pBBox } {
        return [y [bottomRight $pBBox]]
    }
    
    proc bboxUnion {pBBox1 pBBox2} {
        set lTopLeft [list [expr [left $pBBox1] + [left $pBBox2]] [expr [top $pBBox1] + [top $pBBox2]]]
        set lBottomRight [list [expr [right $pBBox1] + [right $pBBox2]] [expr [bottom $pBBox1] + [bottom $pBBox2]]]        
        return [list $lTopLeft $lBottomRight]
    }
    
    proc width {pBBox} {
        return [expr abs([left $pBBox] - [right $pBBox])]
    }
    
    proc height {pBBox} {
        return [expr abs([top $pBBox] - [bottom $pBBox])]
    }    
}

# end of file

