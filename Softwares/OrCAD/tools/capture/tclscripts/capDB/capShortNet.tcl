#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDesignUtil.tcl
#            contains OrCAD Capture Design utlities
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g. source d:/workdata/capture/dbcheck/Published/capDesignUtil.tcl
#2. capDesignUtil::searchText <text>
#    e.g. capDesignUtil::searchText "USB1.0"
#3. capDesignUtil::replaceText <text to search> <text to replace with>
#    e.g. capDesignUtil::replaceText "USB1.0" "USB2.0"
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capShortNetUtil 1.0

namespace eval ::capShortNetUtil {
	variable aliaseName [list]
	variable dupaliaseName [list]
	
}


proc ::capShortNetUtil::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capShortNetUtil::ThrowErrorMessage { pPage } {

	set lNullObj NULL
	
	if { $pPage ==$lNullObj } {
		return
	}
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	set lMessage [concat "(::capShortNetUtil::searchAShortedNetsOnSchematic) : Duplicate aliases found : "  $::capShortNetUtil::dupaliaseName]
	set lMessage [concat $lMessage  "On Page : "]
	set lMessage [concat $lMessage  $lPageNameStr]
	set lMessage [concat $lMessage  "Of Schematic : "]
	set lMessage [concat $lMessage  $lSchematicNameStr]
	
	
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr

}
 
proc ::capShortNetUtil::capVisitAliasForShortedNets { pAlias } {
	
	set lStatus [DboState]
	set lNullObj NULL

	set lAlsName [DboTclHelper_sMakeCString]
	
	$pAlias GetName  $lAlsName
	set lAlsNameStr [DboTclHelper_sGetConstCharPtr $lAlsName]
	
	set lSearchIndex [lsearch $::capShortNetUtil::aliaseName $lAlsNameStr]
	if {  $lSearchIndex == -1  }  {
		lappend ::capShortNetUtil::aliaseName $lAlsNameStr
	} else { 
		set lSearchIndex1 [lsearch $::capShortNetUtil::dupaliaseName $lAlsNameStr]
		if {  $lSearchIndex1== -1  }  {
			lappend ::capShortNetUtil::dupaliaseName $lAlsNameStr
		}
	}
	return
}


proc ::capShortNetUtil::capVisitWireForShortedNets { pWire }  {
	
	set lStatus [DboState]
	set lNullObj NULL
	
	DboWireAliasesIter AliasesIter $pWire 
	set lAlias [AliasesIter NextAlias $lStatus]
	while {$lAlias!=$lNullObj} {
		
		capVisitAliasForShortedNets $lAlias
		set lAlias [AliasesIter NextAlias $lStatus]
	}
}

proc ::capShortNetUtil::capVisitNetForShortedNets { pNet  pSchematic} {
	set lStatus [DboState]
	set lNullObj NULL
	set lNetAlsName [DboTclHelper_sMakeCString]
	set lSchNetName [DboTclHelper_sMakeCString]
	
	#set pDboSchematicNet [ $pSchematic GetNet $pNet  $lStatus ]
	#$pDboSchematicNet GetName $lSchNetName
	#set lSchNetNameStr [DboTclHelper_sGetConstCharPtr $lSchNetName]
	
	#DboNetAliasesIter lnetAliasesIter $pNet
	#set lStatus [ lnetAliasesIter NextAlias $lNetAlsName]
	#while {[$lStatus OK ]} {
	#	set lNetAlsNameStr [DboTclHelper_sGetConstCharPtr $lNetAlsName]
	#	puts $lNetAlsNameStr
	#	set lStatus [ lnetAliasesIter NextAlias $lNetAlsName]
	#}
	
	
	DboNetWiresIter lWiresIter $pNet  $::IterDefs_ALL
	set lWire [lWiresIter NextWire $lStatus]
	while {$lWire!=$lNullObj} {
		capVisitWireForShortedNets $lWire
		set lWire [lWiresIter NextWire $lStatus]
	}
	

}

proc ::capShortNetUtil::capVisitPageShortedNets { pPage } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	DboPageNetsIter lPageNetsIter $pPage $::IterDefs_ALL
	set lnet [lPageNetsIter NextNet $lStatus]
	while {$lnet!=$lNullObj} {
		capVisitNetForShortedNets $lnet $lSchematic
		set lnet [lPageNetsIter NextNet $lStatus]
	}
	$lStatus -delete
	return
}

proc ::capShortNetUtil::capVisitPagesForShortedNets { pSchematic } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPageShortedNets $lPage
		ThrowErrorMessage $lPage
		set ::capShortNetUtil::aliaseName [clearList $::capShortNetUtil::aliaseName]
		set ::capShortNetUtil::dupaliaseName [clearList $::capShortNetUtil::dupaliaseName]
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capShortNetUtil::capVisitSchematicsForShortedNets { pDesign } {    
	set lStatus [DboState]
	set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	set lSchematic [$lSchematicIter NextView  $lStatus]
	set lNullObj NULL
	while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForShortedNets $lObj
		set lSchematic [$lSchematicIter NextView  $lStatus]
	}
	delete_DboLibViewsIter $lSchematicIter
	$lStatus -delete
	return
}

proc ::capShortNetUtil::searchAShortedNetsOnSchematic { } {
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	set lNullObj NULL
	set lDesign [$lSession GetActiveDesign]
	if { $lDesign == $lNullObj} {
		return
	}
	set lName [DboTclHelper_sMakeCString]
	set lStatus [$lDesign GetRootName $lName]	
	$lStatus -delete
	capVisitSchematicsForShortedNets $lDesign
	DboTclHelper_sReleaseAllCreatedPtrs
	return
}