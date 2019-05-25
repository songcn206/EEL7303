#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capBundleEvaluators.tcl
#            Contains OrCAD Capture Bundle graphics creation callbacks
#/////////////////////////////////////////////////////////////////////////////////

package require capTextUtils
package provide capBundleEvaluators 1.0

namespace eval capBundleEvaluators {
    set nVertPinSpacingFactor 20
    set nMiddleSpacing        25
    set nTextWidthFactor       0.8
    set nBundleMemberStartY   20
}

proc capBundleEvaluators::computeBBox {pName pPinList pShapeList} {
    set lPinsBBox {{0 0} {0 0}}
    set lMaxMemberNameWidth 0
    set lBundleNameWidth 0
    set lHeight 0
    set lPinShapeWidth 2

    # calculate bbox to enclose all pin names and pin shapes
    foreach lPin $pPinList {
        puts "Pin data is $lPin"

        set lPinName [lindex $lPin 0]
        set lPinType [lindex $lPin 1]

        if {"bundle" == $lPinType} {
            set lBundleNameWidth [capTextUtils::computeTextWidth $lPinName $::capBundleEvaluators::nTextWidthFactor]
        } else {
            set lMemberNameWidth [capTextUtils::computeTextWidth $lPinName $::capBundleEvaluators::nTextWidthFactor]
            if {$lMemberNameWidth > $lMaxMemberNameWidth} {
                set lMaxMemberNameWidth $lMemberNameWidth
            }

            # increment the vertical spacing for each member
            incr lHeight $::capBundleEvaluators::nVertPinSpacingFactor
        }
    }

    # add vert spacing for initial and last pins
    set lBBoxHeight [expr int(ceil($lHeight + $::capBundleEvaluators::nVertPinSpacingFactor))]
    
    puts "Bundle name width: $lBundleNameWidth"
    puts "Max member name width: $lMaxMemberNameWidth"
    
    set lBBoxWidth [expr int(ceil($lBundleNameWidth + $lPinShapeWidth + $lMaxMemberNameWidth + $lPinShapeWidth + $::capBundleEvaluators::nMiddleSpacing))]

    # return the computed bbox
    set lBBox [list {0 0} [list $lBBoxWidth $lBBoxHeight]]
    
    puts "Computed BBOX $lBBox"
    return $lBBox
}

proc capBundleEvaluators::computePinPlacement {pDrawnInst pBBox pPinList pShapeList} {

    set lLocY $::capBundleEvaluators::nBundleMemberStartY
    set lPinPlacementList {}

    foreach lPinData $pPinList {
        set lPinName [lindex $lPinData 0]
        set lPinRank [lindex $lPinData 1]
        set lPinClass [lindex $lPinData 2]

        if {"bundle" == $lPinRank} {
            set lLocation [list 0 [expr [capGeom::height $pBBox]/2]]
        } else {
            set lLocation [list [capGeom::width $pBBox] $lLocY]
            incr lLocY $::capBundleEvaluators::nVertPinSpacingFactor
        }

        set lHotspot $lLocation
        lappend lPinPlacementList [list $lPinName $lLocation $lHotspot]
    }
    return $lPinPlacementList
}

proc capBundleEvaluators::createBezier { pDrawnInst pPointList } {
    set lStatus [DboState]
    set lLibPart [$pDrawnInst GetDefiningSymbol $lStatus]
    set lBezier [DboGraphicObject_NewBezier $lLibPart $lStatus $::DboValue_SOLID_LINE $::DboValue_MEDIUM_WIDTH]
    if { 0 != $lBezier } {
        for {set lIdx 0} {$lIdx < [llength $pPointList]} {incr lIdx} {
            $lBezier NewPoint [::capDboGeom::list2CPoint [lindex $pPointList $lIdx]] $lIdx 
        }
    }
    
    $lStatus -delete
    return $lBezier
}

proc capBundleEvaluators::placeShapes {pDrawnInst pBBox pPinList pShapeList} {
    set lHeight [capGeom::height $pBBox]
    set lWidth [capGeom::width $pBBox]
    
    # create two beziers that would look like a parenthesis
    # top bezier points
    set lTopStart [list [expr $lWidth/2 - 10] [expr $lHeight/2]]
    set lTopControl1 [list [expr $lWidth/2 + 10] [expr $lHeight/2]]
    set lTopControl2 [list [expr $lWidth/2 - 10] $::capBundleEvaluators::nBundleMemberStartY]
    set lTopEnd [list [expr $lWidth/2 + 10] $::capBundleEvaluators::nBundleMemberStartY]

    # bottom bezier points
    set lBotStart [list [expr $lWidth/2 - 10] [expr $lHeight/2]]
    set lBotControl1 [list [expr $lWidth/2 + 10] [expr $lHeight/2]]
    set lBotControl2 [list [expr $lWidth/2 - 10] [expr $lHeight - $::capBundleEvaluators::nVertPinSpacingFactor]]
    set lBotEnd [list [expr $lWidth/2 + 10] [expr $lHeight - $::capBundleEvaluators::nVertPinSpacingFactor]]

    # create the top bezier
    createBezier $pDrawnInst [list $lTopStart $lTopControl1 $lTopControl2 $lTopEnd]
    
    # create the bottom bezier    
    createBezier $pDrawnInst [list $lBotStart $lBotControl1 $lBotControl2 $lBotEnd]
}

