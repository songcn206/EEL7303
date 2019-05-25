#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  
#/////////////////////////////////////////////////////////////////////////////////


package require Tcl 8.4
package require capProcessDRC
package provide capRecurseParts 1.0

variable lStatus [DboState]

namespace eval ::capRecurseParts {
    
    namespace export processAllInstOccsInDesign
    namespace export processAllPartInstsInDesign
    namespace export processAllInstOccs
}

#capProcessDRC::capProcessSelectionOccurences "capDumpRefDes" $dsn

proc ::capRecurseParts::processAllInstOccsInDesign {dsn fname} {
    set ::lStatus [DboState]
    set lRootOcc [$dsn GetRootOccurrence $::lStatus]
    set lRootOcc [DboOccurrenceToDboInstOccurrence $lRootOcc] 
    processAllInstOccs $lRootOcc $fname
} 

proc ::capRecurseParts::processAllInstOccs {pInstOcc  fname} {
    # set lRootOcc [$dsn GetRootOccurrence $::lStatus]
    # if { $pInstOcc != $lRootOcc } {
    # 	$fname $pInstOcc
    # }

    $fname $pInstOcc

    set lInstOccIter [$pInstOcc NewChildrenIter $::lStatus  $::IterDefs_INSTS]
    $lInstOccIter Sort $::lStatus
    set lChildOcc [$lInstOccIter NextOccurrence $::lStatus]
    while { $lChildOcc!= "NULL"} {

	#get the DboInstOccurrence pointer from DboOccurrence pointer
	set lInstOcc [DboOccurrenceToDboInstOccurrence $lChildOcc] 
	
	processAllInstOccs $lInstOcc $fname
	
	set lChildOcc [$lInstOccIter NextOccurrence $::lStatus]
    }
    delete_DboOccurrenceChildrenIter $lInstOccIter
}

proc ::capRecurseParts::processAllPartInstsInDesign {dsn fname} {
    set schIter [$dsn NewViewsIter $::lStatus $::IterDefs_ALL]
    set schm [$schIter NextView $::lStatus]
    set schm [DboViewToDboSchematic $schm]
    while {$schm!="NULL"} {
	set pageIter [$schm NewPagesIter $::lStatus]
	set page [$pageIter NextPage $::lStatus]
	while {$page!="NULL"} {
	    set instIter [$schm NewInstsIter $::lStatus]
	    set partinst [$instIter NextInst $::lStatus]
	    while {$partinst!="NULL"} {
		$fname $partinst
		set partinst [$instIter NextInst $::lStatus]
	    }
	    delete_DboSchematicInstsIter $instIter
	    set page [$pageIter NextPage $::lStatus]
	}
	delete_DboSchematicPagesIter $pageIter
	set schm [$schIter NextView $::lStatus]	
	set schm [DboViewToDboSchematic $schm]
    }
    delete_DboLibViewsIter $schIter
}
