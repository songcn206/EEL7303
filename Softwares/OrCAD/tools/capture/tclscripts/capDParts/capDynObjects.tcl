#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDynObjects.tcl
#            Contains OrCAD Capture dynamic object creation framework functions
#/////////////////////////////////////////////////////////////////////////////////

package require Capture
package require capDboGeom
package require capGeom

package provide capDynObjects 1.0

proc capCheckObjType { pObject pType } {
    return {[$pObject GetObjectType] == $pType}
}

proc color2DboColor {pColor} {
    set lRet $::DboValue_COLOR40 

    switch $pColor black {
        set lRet $::DboValue_COLOR40
    } white { 
        set lRet $::DboValue_COLOR47
    }
    return $lRet
}

namespace eval capDynObjects {
    set nState [DboState]
    set nEmptyString [DboTclHelper_sMakeCString]
    set nOrigin [DboTclHelper_sMakeCPoint 0 0]
    set nDefaultFont [DboTclHelper_sMakeLOGFONT]
    set nIncrVal 20
    set nBundleMemberStartY 20    

    variable nStringTable
    array set nStringTable {
        IDS_PROP_REFERENCE "Reference"
        IDS_PROP_PART_VALUE "Value"
    }    
}

proc capDynObjects::evaluatorError {pType pEvaluator} {
    puts "ERROR: $pType $pEvaluator failed"
}

proc capDynObjects::addDisplayProp {pGraphicInst pPropText pPropValue pLocation} {
#---------------------------------------------------------------------
# Create a default display property for the name... 
#---------------------------------------------------------------------
    set lPropText [DboTclHelper_sMakeCString $pPropText]
    set lDispProp [$pGraphicInst NewDisplayProp \
        $::capDynObjects::nState \
        $lPropText \
        $::capDynObjects::nOrigin \
        $::DboValue_NOROTATION \
        $::capDynObjects::nDefaultFont \
        $::DboValue_DEFAULT_OBJECT_COLOR]

    #puts "Display prop created..."
    set lPropValue [DboTclHelper_sMakeCString $pPropValue]
    $lDispProp SetValueString $lPropValue [GetInstanceOccurrence]

    #---------------------------------------------------------------------
    # ...and position the name on the top of the drawn instance.
    #---------------------------------------------------------------------
    #puts "Display prop value set"
    $lDispProp SetLocation [capDboGeom::list2CPoint $pLocation]

    #puts "Display prop location set"    
}

proc capDynObjects::createDrawnInst { pOwner pName pType pLocation pBBox pRotation pMirror pColor } {
    #puts "createDrawnInst $pOwner $pName $pType $pLocation $pBBox $pRotation $pMirror $pColor ..."
    set lRet 0

    if {$::DboBaseObject_PAGE == [$pOwner GetObjectType]} {
        set lName [DboTclHelper_sMakeCString $pName]
        set lBBox [::capDboGeom::list2CRect $pBBox]
        set lLocation [::capDboGeom::list2CPoint $pLocation]
        set lRotation [::capDboGeom::rotation2DboRotation $pRotation]
        set lColor [color2DboColor $pColor]

        set lDrawnInst [$pOwner NewDrawnInst $::capDynObjects::nState $lName $lBBox $lLocation $lRotation $pMirror $lColor]

        if { 1 == [$::capDynObjects::nState OK] } {

            set ::capDynObjects::nState [$lDrawnInst SetReference $lName]

            if { 1 == [$::capDynObjects::nState OK] } {
                set ::capDynObjects::nState [$lDrawnInst SetIsPrimitiveProp $::DboValue_DEFAULT_OBJECT_PRIMITIVE]
            }

            if { 1 == [$::capDynObjects::nState Failed] } {
                set ::capDynObjects::nState [$lDrawnInst SetContentsLibName $::capDynObjects::nEmptyString]
            }

            if { 1 == [$::capDynObjects::nState Failed] } {
                set ::capDynObjects::nState [$lDrawnInst SetContentsViewName $::capDynObjects::nEmptyString]
            }

            if { 1 == [$::capDynObjects::nState Failed] } {
                set ::capDynObjects::nState [$lDrawnInst SetContentsViewType $pType]
            }

            if { 1 == [$::capDynObjects::nState Failed] } {
                DboPartInst_SetBoundingBox $lDrawnInst $lBBox
            }

            set lRet $lDrawnInst
        }
    }

    return $lRet
}

proc capDynObjects::addPin {pDrawnInst pPinName pIsBusPin pPinType pPinLocation pPinHotspot} {
    set lPortInst 0
    set lPinName [DboTclHelper_sMakeCString $pPinName]
    set lPinLocation [capDboGeom::list2CPoint $pPinLocation]
    set lPinHotspot [capDboGeom::list2CPoint $pPinHotspot]

    if { 1 == $pIsBusPin } {
        set lPortInst [$pDrawnInst NewPortInstBus \
            $::capDynObjects::nState \
            $lPinName \
            $pPinType \
            $lPinLocation \
            $lPinHotspot \
            1]
    } else {
        set lPortInst [$pDrawnInst NewPortInstScalar \
            $::capDynObjects::nState \
            $lPinName \
            $pPinType \
            $lPinLocation \
            $lPinHotspot \
            1]
    }

    # register id
    $lPortInst GetId $::capDynObjects::nState
    return $lPortInst
}

proc capDynObjects::addPins {pDrawnInst pBBox pPinList pShapeList} {
    set lLocY $::capDynObjects::nBundleMemberStartY

    foreach lPinData $pPinList {
        set lPinName [lindex $lPinData 0]
        set lPinRank [lindex $lPinData 1]
        set lPinClass [lindex $lPinData 2]

        set lPinIsBus 0

        if {"bus" == $lPinClass} {
            set lPinIsBus 1
        }

        if {"bundle" == $lPinRank} {
            set lLocation [list 0 [expr [capGeom::height $pBBox]/2]]
        } else {
            set lLocation [list [capGeom::width $pBBox] $lLocY]
            incr lLocY $::capDynObjects::nIncrVal
        }
        set lPinType [subst [lindex $lPinData 3]]
        set lHotspot $lLocation

        #puts "Name: $lPinName, IsBus: $lPinIsBus, Type: $lPinType, Location: $lLocation, Hotspot: $lHotspot"
        #puts " addPin $pDrawnInst $lPinName $lPinIsBus $lPinType $lLocation $lHotspot "
        addPin $pDrawnInst $lPinName $lPinIsBus $lPinType $lLocation $lHotspot
    }
}

proc capDynObjects::placePins {pDrawnInst pBBox pPinList pPinPlacementData pInstanceName} {

    array set lPinPlacementTable {} 

    foreach lPinPlacement $pPinPlacementData {
        set lPinPlacementTable([lindex $lPinPlacement 0]) [list [lindex $lPinPlacement 1] [lindex $lPinPlacement 2]]
    }

    foreach lPinData $pPinList {
        set lPinName [lindex $lPinData 0]
        set lPinRank [lindex $lPinData 1]
        set lPinClass [lindex $lPinData 2]
        
        set lPinIsBus 0
        if {"bus" == $lPinClass} {
            set lPinIsBus 1
        }
        set lPinType [subst [lindex $lPinData 3]]

        set lPlacementData $lPinPlacementTable($lPinName)

        #puts " addPin $pDrawnInst $lPinName $lPinIsBus $lPinType [lindex $lPlacementData 0] [lindex $lPlacementData 1]"
        addPin $pDrawnInst $lPinName $lPinIsBus $lPinType [lindex $lPlacementData 0] [lindex $lPlacementData 1]
    }    
}

proc capDynObjects::addShapes {pDrawnInst pBBox pPinList pShapeList} {
}

proc capDynObjects::calculateBBox {pName pPinList pShapeList} {
    return {{0 0} {100 100}}
}

proc capDynObjects::generateDrawnInst {pPage pName pType pLocation pRotation pMirror pColor pPinList pShapeList {pBBoxCalculator ""} {pPinPlacerProc ""} {pShapePlacerProc ""} {pPostProcessorProc ""}} {

# calculate the BBox
set lBBox {{0 0} {0 0}}

    if {$pBBoxCalculator != ""} {
        if {[catch {eval $pBBoxCalculator $pName [list $pPinList] [list $pShapeList]} lBBox]} {
            evaluatorError "Bounding box" $pBBoxCalculator
            return 0
        }
    } else {
        set lBBox [calculateBBox $pName $pPinList $pShapeList]
    }

    #puts "BBox evaluator $pBBoxCalculator returned $lBBox"

    if {0 == [capGeom::width $lBBox] || 0 == [capGeom::height $lBBox]} {
        puts "Bounding box dimension calculation failed..."
        puts "Unable to create dynamic object"
        return 0
    }

    # create the drawn inst
    #puts "Name $pName"
    set lDrawnInst [createDrawnInst $pPage $pName $pType $pLocation $lBBox $pRotation $pMirror $pColor]
    
    set id [$lDrawnInst GetId $::capDynObjects::nState]

    if {0 != $lDrawnInst} {
    # add display properties
    set lReferenceLoc {0 -10}

        #puts $lReferenceLoc
        #puts "adding Display prop..."
        addDisplayProp $lDrawnInst $::capDynObjects::nStringTable(IDS_PROP_REFERENCE) $pName $lReferenceLoc

        # add pins
        set lPinPlacementData {}

        if {$pPinPlacerProc != ""} {
            if {[catch {eval $pPinPlacerProc $lDrawnInst [list $lBBox] [list $pPinList] [list $pShapeList]} lPinPlacementData]} {
                evaluatorError "Pin placer" $pPinPlacerProc
                return $id
            } else {
                #puts "Placing pins using placement data"
                if {[llength $lPinPlacementData] > 0} {
                    placePins $lDrawnInst $lBBox $pPinList $lPinPlacementData $pName
                }
            }
        } else {
            addPins $lDrawnInst $lBBox $pPinList $pShapeList
        }

        # add shapes by calling the shape generator function
        if {$pShapePlacerProc != ""} {
            if {[catch {eval $pShapePlacerProc $lDrawnInst [list $lBBox] [list $pPinList] [list $pShapeList]}]} {
                evaluatorError "Shape placer" $pShapePlacerProc
                return $id
            }
        } else {
            addShapes $lDrawnInst $lBBox $pPinList $pShapeList
        }

        # add shapes by calling the shape generator function
        if {$pPostProcessorProc != ""} {
            if {[catch {eval $pPostProcessorProc $lDrawnInst}]} {
                evaluatorError "Post processor" $pPostProcessorProc
		        return $id
            }
        }
        
        return $id

    }
}

# end of file

