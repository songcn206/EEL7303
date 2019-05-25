#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capSearchExecute 1.0

namespace eval capSearchExecute {}

set capSearchExecute::nResults {}
set capSearchExecute::nDebug 0
set capSearchExecute::nNullObj NULL

proc capSearchExecute::dlog { pDebug pMsg } {
    if { 1 == $pDebug } {
        puts $pMsg
    }
}

proc capSearchExecute::propNameValMatchRE { pObject pProperties pPropNameRE pPropValRE } {
    set lFoundMatch 0
    foreach lPropPair $pProperties {
        set lName [lindex $lPropPair 0]
        set lVal [lindex $lPropPair 1]
        if { 1 == [regexp $pPropNameRE $lName] } {
            if { 1 == [regexp $pPropValRE $lVal] } {
                set lFoundMatch 1
                break;
            }
        }
    }
    return $lFoundMatch
}

proc capSearchExecute::propNameValMatch { pObject pProperties pPropName pPropVal } {
    set lFoundMatch 0
    foreach lPropPair $pProperties {
        set lName [lindex $lPropPair 0]
        set lVal [lindex $lPropPair 1]

        dlog $::capSearchExecute::nDebug "Matching |$pPropName| against |$lName|"
        if { 1 == [string match $pPropName $lName] } {
            dlog $::capSearchExecute::nDebug "Matching |$pPropVal| against |$lVal|"
            if { 1 == [string match $pPropVal $lVal] } {
                set lFoundMatch 1
                break;
            }
        }
    }
    return $lFoundMatch
}

proc capSearchExecute::loadProperties { pObject } {
    set lProps {}
    set lState [DboState]
    set lEPIter [$pObject NewEffectivePropsIter $lState]
    set lPropNameCStr [DboTclHelper_sMakeCString]
    set lPropValCStr [DboTclHelper_sMakeCString]    
    set lPropType [DboTclHelper_sMakeDboValueType]
    set lEditable [DboTclHelper_sMakeInt]
    set lRetState [$lEPIter NextEffectiveProp $lPropNameCStr $lPropValCStr $lPropType $lEditable]

    while { 1 == [$lRetState OK] } {
        set lPropNameStr [DboTclHelper_sGetConstCharPtr $lPropNameCStr]
        set lPropValStr [DboTclHelper_sGetConstCharPtr $lPropValCStr]

        lappend lProps [list $lPropNameStr $lPropValStr $lPropType [DboTclHelper_sGetInt $lEditable]]
        set lRetState [$lEPIter NextEffectiveProp $lPropNameCStr $lPropValCStr $lPropType $lEditable]
    }
    delete_DboEffectivePropsIter $lEPIter
    $lState -delete
    return $lProps
}

proc capSearchExecute::parsePropNameVal { pCriterion } {

    dlog $::capSearchExecute::nDebug "Criterion is : $pCriterion"

    set lPropName {}
    set lPropVal {}

    foreach lParts $pCriterion {
        set lVal [lindex $lParts 0]
        if { 1 == [string match -nocase "prop:name" $lVal] } {
            set lPropName [lindex $lParts 1]
        } elseif { 1 == [string match -nocase "prop:value" $lVal] } {
            set lPropVal [lindex $lParts 1]
        }
    }

    return [list $lPropName $lPropVal]
}

proc capSearchExecute::propSearch { pDoREMatch pSearchCriteria pAction pObject } {
    dlog $::capSearchExecute::nDebug "Searching for $pSearchCriteria on $pObject"
    set lMatch 0
    set lCombinedConditional {}
    set lCombinators {}

    set lRefDesPropCStr [DboTclHelper_sMakeCString "Part Reference"]
    set lRefDesValCStr [DboTclHelper_sMakeCString]

    $pObject GetEffectivePropStringValue $lRefDesPropCStr $lRefDesValCStr

    set lProperties [loadProperties $pObject]

    set lIdx 1
    foreach pCriterion $pSearchCriteria {
        if { 0 != [expr $lIdx % 2] } {
            set lPropNameValPair [parsePropNameVal $pCriterion]
            set lPropName [lindex $lPropNameValPair 0]
            set lPropVal [lindex $lPropNameValPair 1]

            if { 1 == $pDoREMatch } {
                dlog $::capSearchExecute::nDebug ">>>> doing regexp name:$lPropName value:$lPropVal Props: $lProperties"
                append lCombinedConditional [propNameValMatchRE $pObject $lProperties $lPropName $lPropVal]
            } else {
                dlog $::capSearchExecute::nDebug ">>>> doing string match name:$lPropName value:$lPropVal Props: $lProperties"
                append lCombinedConditional [propNameValMatch $pObject $lProperties $lPropName $lPropVal]
            }
        } else {
            if { $pCriterion == "and" } {
                append lCombinedConditional "*"
            } elseif { $pCriterion == "or" } {
                append lCombinedConditional "+"
            }
        }
        incr lIdx
    }

    set lMatch [expr $lCombinedConditional]
    dlog $::capSearchExecute::nDebug "Combined Conditional is : $lCombinedConditional, match is $lMatch"

    if { 0 != $lMatch } {
        set lNameCStr [DboTclHelper_sMakeCString]
        set lTypeNameCStr [DboTclHelper_sMakeCString] 

        $pObject GetName $lNameCStr
        $pObject GetTypeString $lTypeNameCStr

        set lRet [eval $pAction $pObject]

        set lResult {}
        lappend lResult [DboTclHelper_sGetConstCharPtr $lNameCStr] [DboTclHelper_sGetConstCharPtr $lRefDesValCStr] [DboTclHelper_sGetConstCharPtr $lTypeNameCStr] $lRet
        lappend ::nResults $lResult
    }    
}

proc capSearchExecute::iteratePageObjects { pPage pAction } { 
    set lStatus [DboState]
    set lPartInstIter [$pPage NewPartInstsIter $lStatus]
    set lPartInst [$lPartInstIter NextPartInst $lStatus]
    set lNullObj NULL

    while {$lPartInst!=$lNullObj} {
        set lPlacedInst [DboPartInstToDboPlacedInst $lPartInst]
        if {$lPlacedInst != $lNullObj} {
            eval $pAction $lPlacedInst
        }
        set lPartInst [$lPartInstIter NextPartInst $lStatus]
    }
    delete_DboPagePartInstsIter $lPartInstIter
    $lStatus -delete
    return
}

proc capSearchExecute::iteratePages { pSchematic pAction } { 
    set lStatus [DboState]
    set lPagesIter [$pSchematic NewPagesIter $lStatus]
    set lPage [$lPagesIter NextPage $lStatus]
    set lNullObj NULL

    while {$lPage!=$lNullObj} {
        eval $pAction $lPage
        iteratePageObjects $lPage $pAction
        set lPage [$lPagesIter NextPage $lStatus]
    }
    delete_DboSchematicPagesIter $lPagesIter
    $lStatus -delete

    return
}

proc capSearchExecute::iterateSchematics { pDesign pAction } {    
    set lStatus [DboState]
    set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
    set lSchematic [$lSchematicIter NextView  $lStatus]
    set lNullObj NULL
    while { $lSchematic!= $lNullObj} {
        set lObj [DboViewToDboSchematic $lSchematic]
        eval $pAction $lObj
        iteratePages $lObj $pAction
        set lSchematic [$lSchematicIter NextView  $lStatus]
    }
    delete_DboLibViewsIter $lSchematicIter
    $lStatus -delete
    return
}

proc capSearchExecute::iterateLibObjects { pLibrary pAction } {    

    set lState [DboState]
    set lLibPartsIter [new_DboLibPartsIter $pLibrary]
    set lLibPart  [$lLibPartsIter NextPart $lState]

    while { $::capSearchExecute::nNullObj != $lLibPart } {
        eval $pAction $lLibPart 
        set lLibPart  [$lLibPartsIter NextPart $lState]
    }

    $lState -delete
}

proc capSearchExecute::replacePropOnObject { pOldPropName pNewPropName pObject } {

    dlog $::capSearchExecute::nDebug "replacing prop on object $pObject"

    set lRet 0
    set lOldPropNameCStr [DboTclHelper_sMakeCString $pOldPropName]
    set lPropValCStr [DboTclHelper_sMakeCString ""]
    $pObject GetEffectivePropStringValue $lOldPropNameCStr $lPropValCStr

    # add the new prop
    set lNewPropNameCStr [DboTclHelper_sMakeCString $pNewPropName]
    set lState [$pObject SetEffectivePropStringValue $lNewPropNameCStr $lPropValCStr]

    if { 1 == [$lState OK] } {
    # remove the prop
        set lState [$pObject DeleteEffectiveProp $lOldPropNameCStr]
        if { 1 == [$lState OK] } {
            set lRet 1
        }
    } 

    if { 0 == $lRet } {
        dlog 1 ">>>>>>>>>>>>>>>>>>>>>>> Unable to replace property $pOldPropName with $pNewPropName on $pObject"
    }

    return $lRet
}

proc capGetActivePMLib {} {
    set lLibObj $::capSearchExecute::nNullObj
    set lLib [lindex [GetSelectedPMItems] 0]

    if { $lLib != "" } {
        set lStatus [DboState]

        set lSession $::DboSession_s_pDboSession
        DboSession -this $lSession

        set lLibCStr [DboTclHelper_sMakeCString $lLib]
        set lLibObj [$lSession GetLib $lLibCStr $lStatus]

        if { $lLibObj == $::capSearchExecute::nNullObj } {
            puts $lFile " : Open Failed"
        } 

        $lStatus -delete
    }

    return $lLibObj
}

proc capSearchExecute::main { pDBRootObject pDoREMatch pSearchString pAction } {
    set lAction ""
    set ::nResults {}
    append lAction "propSearch $pDoREMatch " $pSearchString " {" $pAction "}"

    dlog $::capSearchExecute::nDebug " ------------ Action: $:lAction "

    if { $::DboBaseObject_DESIGN == [$pDBRootObject GetObjectType] } {
        iterateSchematics $pDBRootObject $lAction
    } elseif { $::DboBaseObject_LIBRARY == [$pDBRootObject GetObjectType] } {
        iterateLibObjects $pDBRootObject $lAction
    }

    dlog $::capSearchExecute::nDebug " ------------ Results : $::nResults "
    return $::nResults
}

####################
# sample invocations
####################

# Replace property "TEST PROP" with value anything on all parts in the Library selected in the PM Window with property name "TEST NEW PROP"
# capSearchExecute::main [capGetActivePMLib] 0 {{{{prop:name {TEST PROP}} {prop:value *}}}} {replacePropOnObject {TEST PROP} {TEST NEW PROP}}

# Replace property "TEST PROP" with value anything on all part instances on the Design selected in the PM Window with property name "TEST NEW PROP"
# capSearchExecute::main [GetActivePMDesign] 0 {{{{prop:name {TEST PROP}} {prop:value *}}}} {replacePropOnObject {TEST PROP} {TEST NEW PROP}}

