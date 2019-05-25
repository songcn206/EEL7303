#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capBundleCreator.tcl
#            Contains OrCAD Capture Bundle graphics creation routine
#/////////////////////////////////////////////////////////////////////////////////

package require capDynObjects
package require capBundleEvaluators

package provide capBundleCreator 1.0

proc genBundle {pPage pName pPinList pLoc {pBBoxEvaluator ""} {pPinPlacer ""} {pShapePlacer ""} {pPostProcessor ""}} {
   set id  [capDynObjects::generateDrawnInst $pPage $pName $::DboValue_BUNDLE_VIEW_TYPE $pLoc 0 0 black $pPinList {} $pBBoxEvaluator $pPinPlacer $pShapePlacer $pPostProcessor]
	if {0 == [catch {package require Capture}]} {
        if {1 == [IsSchematicViewActive]} {
            Menu "View::Zoom::Redraw"
            return $id
        }
    }
    return $id
}

#end of file

