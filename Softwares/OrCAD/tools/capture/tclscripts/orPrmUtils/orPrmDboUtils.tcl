#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orPrmDboUtils.tcl
#            Base Dbo utilities
#/////////////////////////////////////////////////////////////////////////////////

package require orPrmDboInclude 16.6
package provide orPrmDboUtils 16.6

namespace eval orPrmDboUtils {
    variable nTempStr [DboTclHelper_sMakeCString]
    variable nStatus [DboState]
    variable nSession NULL
}

# calls Dbo function that returns a CString and
# converts the return value into a Tcl string
# pObj  : object on which the proc needs to be called
# pProc : the procedure that needs to be called
# pArgs : arguments required by the proc if any

proc orPrmDboUtils::execStrProc { pObj pProc {pArgs {}} } {
    variable nTempStr

    if { {} == $pArgs } {
        set lStat [$pObj $pProc $nTempStr]
    } else {
        set lStat [$pObj $pProc $pArgs $nTempStr]
    }
    return [DboTclHelper_sGetConstCharPtr $nTempStr]
}

proc orPrmDboUtils::initSession {} {
    variable nSession
    if { $nSession == "NULL" } {
        set nSession [DboTclHelper_sCreateSession]
    }
    return $nSession
}

proc orPrmDboUtils::isLib { pObj } {
    set lObj $pObj
    return [regexp -nocase {\.*\.OLB$} $lObj]
}

proc orPrmDboUtils::isDBObject { pObj } {
    set lRet 0
    if { 0 == [catch { set lType [$pObj GetObjectType] } ] } {
        set lRet 1
    }
    return $lRet
}

proc orPrmDboUtils::isDBType { pObj pDBType } {
    set lRet 0
    if { 1 == [isDBObject $pObj] && [$pObj GetObjectType] == $pDBType } {
        set lRet 1
    }
    return $lRet
}

proc orPrmDboUtils::getLibObject { pFile } {
    variable nSession

    set lObj {}
    if { 1 == [orPrmDboUtils::isLib $pFile] } {
        set lFile [file normalize $pFile]
        set lFileCStr [DboTclHelper_sMakeCString $lFile]
        set lObj [$nSession GetLibAndSchematics $lFileCStr $orPrmDboStreamer::nStatus]
    }
    return $lObj
}

proc orPrmDboUtils::getDesign { pDesignName } {
    variable nStatus
    variable nSession

    initSession

    set lDesignNameCStr [DboTclHelper_sMakeCString $pDesignName]
    return [$nSession GetDesign $lDesignNameCStr $nStatus]
}

proc orPrmDboUtils::getPackage { pLibObject pPackageName } {
    set lRet {}
    if { "" != $pLibObject } {
        set lPackageNameCStr [DboTclHelper_sMakeCString $pPackageName]

        variable nStatus
        set lRet [$pLibObject GetPackage $lPackageNameCStr $nStatus]
    }    
    return $lRet
}

proc orPrmDboUtils::getSchematic { pDesign pSchName } {
    variable nStatus
    set lSchNameCStr [DboTclHelper_sMakeCString $pSchName]
    return [$pDesign GetSchematic $lSchNameCStr $nStatus]
}

proc orPrmDboUtils::getPage { pSch pPageName } {
    variable nStatus
    set lPageNameCStr [DboTclHelper_sMakeCString $pPageName]
    return [$pSch GetPage $lPageNameCStr $nStatus]
}

proc orPrmDboUtils::openPage { pDesignName pSchName pPageName } {
    set lRet NULL
    initSession
    set lDesign [getDesign $pDesignName]

    if { $lDesign != "NULL" } {
        set lSch [getSchematic $lDesign $pSchName]
        if { $lSch != "NULL" } {
            set lRet [getPage $lSch $pPageName]
        }
    }
    return $lRet
}

proc orPrmDboUtils::openPackage { pLibraryFile pPackageName } {
    set lRet NULL
    initSession

    set lLibObject [getLibObject $pLibraryFile]
    return [getPackage $lLibObject $pPackageName]
}

