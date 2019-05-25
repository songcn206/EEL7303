#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDboGeom.tcl
#            Contains OrCAD Capture Dbo geometry related helper functions
#/////////////////////////////////////////////////////////////////////////////////

package require capGeom

package provide capDboGeom 1.0

namespace eval capDboGeom {
    proc list2CPoint {pPoint} {
        return [DboTclHelper_sMakeCPoint [::capGeom::x $pPoint] [::capGeom::y $pPoint]]
    }

    proc list2CRect {pBBox} {
        return [DboTclHelper_sMakeCRect [::capGeom::left $pBBox] [::capGeom::top $pBBox] [::capGeom::right $pBBox] [::capGeom::bottom $pBBox]]
    }

    proc cRect2List {pCRect} {
        set lTopLeft [DboTclHelper_sGetCRectTopLeft $pCRect]
        set lBottomRight [DboTclHelper_sGetCRectBottomRight $pCRect]

        return [list [list [DboTclHelper_sGetCPointX $lTopLeft] [DboTclHelper_sGetCPointY $lTopLeft]] \
                     [list [DboTclHelper_sGetCPointX $lBottomRight] [DboTclHelper_sGetCPointY $lBottomRight]]]
    }

    proc rotation2DboRotation {pRotation} {
        set lRet $::DboValue_NOROTATION
        switch $pRotation 90 {
            set lRet $::DboValue_NINETY
        } 180 { 
            set lRet $::DboValue_ONEEIGHTY
        } 270 {
            set lRet $::DboValue_TWOSEVENTY
        }
        return $lRet
    }
}

# end of file

