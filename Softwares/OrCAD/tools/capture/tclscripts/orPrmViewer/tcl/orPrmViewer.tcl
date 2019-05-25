#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmViewer.tcl
#            OrCAD Viewer Main file
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmWebComp 1.0
package require orPrmDboStreamer 16.6
package require orPrmDebug 1.0
package require orPrmUtils 1.0

package provide orPrmViewer 1.0

namespace eval orPrmViewer {
    set scriptDir [file dirname [info script]]

    variable nDebugLevels
    array set nDebugLevels {
        GET_OBJECT_STREAM 1
        MAIN 1
        OBJECT_LOAD  1
        RESOURCE_LOAD 1
    }

    variable nWidget2ObjectStream
    array unset nWidget2ObjectStream
    array set nWidget2ObjectStream {}

    variable nWidget2Object
    array unset nWidget2Object
    array set nWidget2Object {}

    variable nObject2Stream
    array unset nObject2Stream
    array set nObject2Stream {}

    set nModuleName "VIEWER"

    orPrmDebug::setDebugLevels $nModuleName ::orPrmViewer::nDebugLevels
    orPrmDebug::enableDebug $nModuleName 0
}

proc orPrmViewer::getEntryPagePath { pPage } {
    set res [correctUNCPath [file join $::orPrmViewer::scriptDir .. hybrid $pPage]]
}

proc orPrmViewer::createViewer {pType pEntryPage} {
    set id [orPrm::CreateWidget $pType]
    orPrm::SetTitle $id "$id: OrCAD Prime Viewer"

    variable nModuleName
    fDbg $nModuleName RESOURCE_LOAD "Resource is: $pEntryPage"
    orPrm::LoadResource $id $pEntryPage
    return $id
}

proc orPrmViewer::generateObjectStream {pObj} {
    set lStream {}
    set lType [$pObj GetObjectType]
    if { $lType == $::DboBaseObject_PAGE } {
        set lStream [orPrmJSON::encode [orPrmDboStreamer::streamPage $pObj]]
    } elseif { $lType == $::DboBaseObject_PACKAGE } {
        set lStream [orPrmJSON::encode [orPrmDboStreamer::streamPackage $pObj]]
    } elseif { $lType == $::DboBaseObject_LIBRARY } {
        set lStream [orPrmJSON::encode [orPrmDboStreamer::streamLibrary $pObj]]
    }

    return $lStream
}

proc orPrmViewer::getObjectStream {pObj} { 
    variable nObject2Stream
    set lStream [getValSafe nObject2Stream $pObj]

    if { $lStream == "" } {
        set lStream [generateObjectStream $pObj]
        set nObject2Stream($pObj) $lStream
    }
    return $lStream
}

proc orPrmViewer::getSymbolNames {pObj} {
    return [orPrmJSON::encode [orPrmDboStreamer::streamSymbolNames $pObj]]
}

proc orPrmViewer::loadStreamInDiv {pId pDiv pType pStream} {
    variable nModuleName
    fDbg $nModuleName OBJECT_LOAD "Loading object in $pId at $pDiv"
    orPrm::Execute $pId "viewObjectInDiv(\"$pDiv\", $pStream, \"$pType\");"
}

proc orPrmViewer::loadInit {pId pDiv pType} {
    # fetch the object pStream
    set lKey $pId,$pDiv
    set lObj $orPrmViewer::nWidget2Object($lKey)

    variable nObject2Stream
    set lStream $nObject2Stream($lObj)

    variable nModuleName
    fDbg $nModuleName OBJECT_LOAD "Key: $lKey, Stream: $lStream"

    # load the stuff
    loadStreamInDiv $pId $pDiv $pType $lStream
}

proc orPrmViewer::loadObjectInDiv {pObj pId pDiv pType} {
    set lStream [getObjectStream $pObj]
    loadStreamInDiv $pId $pDiv $pType $lStream
}

proc orPrmViewer::main {pObj pViewerType pHostPage pDiv} {
    set lObj $pObj
    set lType {}

    if { 1 == [catch { set lType [$lObj GetObjectType] } ] } {
        set lObj [orPrmDboUtils::getLibObject $lObj]
        set lType [$lObj GetObjectType]
    }

    set lStream [getObjectStream $lObj]

    variable nModuleName
    fDbg $nModuleName MAIN "Object Stream is: $lStream"

    if { {} != $lStream } {
        set lId [createViewer $::WTYPE_VIEW $pHostPage]
        set lKey $lId,$pDiv
        set orPrmViewer::nWidget2Object($lKey) $lObj
    } else {
        puts "Error loading object"
    }
}


