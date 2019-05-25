#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDesignUtil.tcl
#            contains OrCAD Capture Design utlities
#
# You can run the script in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. package require capDesignUtil

#2. capDesignUtil::searchText <text>
#    e.g. capDesignUtil::searchText "USB1.0"

#3. capDesignUtil::replaceText <text to search> <text to replace with>
#    e.g. capDesignUtil::replaceText "USB1.0" "USB2.0"

#4. For searching aliases in the currently active design
#   ::capDesignUtil::searchAlias <pAliasToSearch>
#    e.g.:-          ::capDesignUtil:: searchAlias  _2

#5 For replacing aliases in the currently active design
# ::capDesignUtil::replaceAlias <pAliasToSearch> <pAliasToReplaceWith>
#    e.g.:-          ::capDesignUtil::replaceAlias   _2   _3

#6. For searching aliases in the currently active page
#  ::capDesignUtil::capVisitPageAliases [GetActivePage] Search <pAliasToSearch> “”
#  e.g.:-          ::capDesignUtil::capVisitPageAliases [GetActivePage] Search  _2    “”

# 7. For replacing aliases in the currently active page
# ::capDesignUtil::capVisitPageAliases [GetActivePage] Replace <pAliasToSearch> <pAliasToReplaceWith>
# e.g.:-          ::capDesignUtil::capVisitPageAliases [GetActivePage] Replace  _2    _3

#8 For searching offpage text in the currently active design
# ::capDesignUtil::searchOffPageText <pOffPageToSearch>
# e.g.:-          ::capDesignUtil:: searchOffPageText  _3

# 9. For replacing offpage text in the currently active design
# ::capDesignUtil::replaceOffPageText <pOffPageToSearch> <pOffPageToReplaceWith>
#  e.g.:-          ::capDesignUtil::replaceOffPageText  _3  _4

# 10. For searching offpage text in the currently active page
# ::capDesignUtil::capVisitPageOffPages [GetActivePage] Search  <pOffPageToSearch> “”
# e.g.:-          ::capDesignUtil::capVisitPageOffPages [GetActivePage] Search  _3   “”

#11. For replacing offpage text in the currently active page
# ::capDesignUtil::capVisitPageOffPages [GetActivePage] Replace  <pOffPageToSearch> <pOffPageToReplaceWith>
# e.g.:-          ::capDesignUtil::capVisitPageOffPages [GetActivePage] Replace  _3   _4

#12 For searching Global text in the currently active design
# ::capDesignUtil::searchGlobalText <pGlobalToSearch>
# e.g.:-          ::capDesignUtil:: searchGlobalText  _3

# 13. For replacing Global text in the currently active design
# ::capDesignUtil::replaceGlobalText <pGlobalToSearch> <pGlobalToReplaceWith>
#  e.g.:-          ::capDesignUtil::replaceGlobalText  _3  _4

# 14. For searching Global text in the currently active page
# ::capDesignUtil::capVisitPageGlobals [GetActivePage] Search  <pGlobalToSearch> “”
# e.g.:-          ::capDesignUtil::capVisitPageGlobals [GetActivePage] Search  _3   “”

#15. For replacing Global text in the currently active page
# ::capDesignUtil::capVisitPageGlobals [GetActivePage] Replace  <pGlobalToSearch> <pGlobalToReplaceWith>
# e.g.:-          ::capDesignUtil::capVisitPageGlobals [GetActivePage] Replace  _3   _4

#16 For searching Port text in the currently active design
# ::capDesignUtil::searchPortText <pPortToSearch>
# e.g.:-          ::capDesignUtil:: searchPortText  _3

# 17. For replacing Port text in the currently active design
# ::capDesignUtil::replacePortText <pPortToSearch> <pPortToReplaceWith>
#  e.g.:-          ::capDesignUtil::replacePortText  _3  _4

# 18. For searching Port text in the currently active page
# ::capDesignUtil::capVisitPagePorts [GetActivePage] Search  <pPortToSearch> “”
# e.g.:-          ::capDesignUtil::capVisitPagePorts [GetActivePage] Search  _3   “”

#19. For replacing Port text in the currently active page
# ::capDesignUtil::capVisitPagePorts [GetActivePage] Replace  <pPortToSearch> <pPortToReplaceWith>
# e.g.:-          ::capDesignUtil::capVisitPagePorts [GetActivePage] Replace  _3   _4

#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capDesignUtil 1.0

namespace eval ::capDesignUtil {
	namespace export searchText
	namespace export replaceText
	namespace export searchAlias
	namespace export replaceAlias
	namespace export searchOffPageText
	namespace export replaceOffPageText
	namespace export searchGlobalText
	namespace export replaceGlobalText
	namespace export searchPortText
	namespace export replacePortText
	namespace export reevaluateAllPages
}

# pTextToSearch can be a regular expression as understood by regexp
proc ::capDesignUtil::searchText { pTextToSearch } { 
	set lNullObj NULL
	if { $pTextToSearch == $lNullObj ||
		$pTextToSearch == ""  } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceCommentText Search $pTextToSearch ""
}

# pTextToSearch and pTextToReplaceWith can be regular expressions as understood by regexp and regsub
proc ::capDesignUtil::replaceText { pTextToSearch pTextToReplaceWith } {    
	set lNullObj NULL
	if { $pTextToSearch == $lNullObj ||
		$pTextToSearch == "" ||
		$pTextToReplaceWith == $lNullObj ||
		$pTextToReplaceWith == "" } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceCommentText Replace $pTextToSearch $pTextToReplaceWith
}

# pAliasToSearch can be a regular expression as understood by regexp
proc ::capDesignUtil::searchAlias { pAliasToSearch } { 
	set lNullObj NULL
	if { $pAliasToSearch == $lNullObj ||
		$pAliasToSearch == ""  } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceAlias Search $pAliasToSearch ""
}

# pAliasToSearch and pAliasToReplaceWith can be regular expressions as understood by regexp and regsub
proc ::capDesignUtil::replaceAlias { pAliasToSearch pAliasToReplaceWith } {    
	set lNullObj NULL
	if { $pAliasToSearch == $lNullObj ||
		$pAliasToSearch == "" ||
		$pAliasToReplaceWith == $lNullObj ||
		$pAliasToReplaceWith == "" } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceAlias Replace $pAliasToSearch $pAliasToReplaceWith
}

# pOffPageToSearch can be a regular expression as understood by regexp
proc ::capDesignUtil::searchOffPageText { pOffPageToSearch } { 
	set lNullObj NULL
	if { $pOffPageToSearch == $lNullObj ||
		$pOffPageToSearch == ""  } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceOffPage Search $pOffPageToSearch ""
}

# pOffPageToSearch and pOffPageToReplaceWith can be regular expressions as understood by regexp and regsub
proc ::capDesignUtil::replaceOffPageText { pOffPageToSearch pOffPageToReplaceWith } {    
	set lNullObj NULL
	if { $pOffPageToSearch == $lNullObj ||
		$pOffPageToSearch == "" ||
		$pOffPageToReplaceWith == $lNullObj ||
		$pOffPageToReplaceWith == "" } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceOffPage Replace $pOffPageToSearch $pOffPageToReplaceWith
}

# pGlobalToSearch can be a regular expression as understood by regexp
proc ::capDesignUtil::searchGlobalText { pGlobalToSearch } { 
	set lNullObj NULL
	if { $pGlobalToSearch == $lNullObj ||
		$pGlobalToSearch == ""  } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceGlobal Search $pGlobalToSearch ""
}

# pGlobalToSearch and pGlobalToReplaceWith can be regular expressions as understood by regexp and regsub
proc ::capDesignUtil::replaceGlobalText { pGlobalToSearch pGlobalToReplaceWith } {    
	set lNullObj NULL
	if { $pGlobalToSearch == $lNullObj ||
		$pGlobalToSearch == "" ||
		$pGlobalToReplaceWith == $lNullObj ||
		$pGlobalToReplaceWith == "" } {
		puts "Incorrect usage"
		return
	}
	searchAndReplaceGlobal Replace $pGlobalToSearch $pGlobalToReplaceWith
}

# pPortToSearch can be a regular expression as understood by regexp
proc ::capDesignUtil::searchPortText { pPortToSearch } { 
	set lNullObj NULL
	if { $pPortToSearch == $lNullObj ||
		$pPortToSearch == ""  } {
		puts "Incorrect usage"
		return
	}
	searchAndReplacePort Search $pPortToSearch ""
}

# pPortToSearch and pPortToReplaceWith can be regular expressions as understood by regexp and regsub
proc ::capDesignUtil::replacePortText { pPortToSearch pPortToReplaceWith } {    
	set lNullObj NULL
	if { $pPortToSearch == $lNullObj ||
		$pPortToSearch == "" ||
		$pPortToReplaceWith == $lNullObj ||
		$pPortToReplaceWith == "" } {
		puts "Incorrect usage"
		return
	}
	searchAndReplacePort Replace $pPortToSearch $pPortToReplaceWith
}

proc ::capDesignUtil::capVisitPageCommentTexts { pPage pMode pTextToSearch  pTextToReplaceWith } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	set lGraphicIter [$pPage NewCommentGraphicsIter $lStatus]
	set lGraphic [$lGraphicIter NextCommentGraphic $lStatus]
	while {$lGraphic!=$lNullObj} {
		
		set lComment [DboGraphicInstanceToDboGraphicCommentTextInst $lGraphic]
		
		if {$lComment!=$lNullObj} {
			set lDef [$lComment GetDboCommentText]
			
			if { $lDef != $lNullObj} {
				set lText [DboTclHelper_sMakeCString]
				set lStatus1 [$lDef  GetText $lText]
				set lTextStr [DboTclHelper_sGetConstCharPtr $lText]
				$lStatus1 -delete
				
				set lSearchResult [regexp $pTextToSearch $lTextStr]
				if { $lSearchResult == 1 } {
					set lMessage [concat "Found text : " $pTextToSearch " as " $lTextStr " on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
					set lMessageStr [DboTclHelper_sMakeCString $lMessage]
					DboState_WriteToSessionLog $lMessageStr
				
					if { $pMode == "Replace"} {
						regsub -all $pTextToSearch $lTextStr $pTextToReplaceWith pReplacedText
						set lMessage [concat ".     .Replaced text : " $pTextToSearch " found as " $lTextStr " replaced with " $pReplacedText "on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
						set lMessageStr [DboTclHelper_sMakeCString $lMessage]
						DboState_WriteToSessionLog $lMessageStr
						
						set pReplacedTextCStr [DboTclHelper_sMakeCString $pReplacedText]
						$lDef SetText $pReplacedTextCStr
						$pPage MarkModified
					}
				}
			}
		}
		
		set lGraphic [$lGraphicIter NextCommentGraphic $lStatus]
	}
	delete_DboPageCommentGraphicsIter $lGraphicIter
	
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPageAliases { pPage pMode pAliasToSearch pAliasToReplaceWith } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	
	set pWiresIter [$pPage NewWiresIter $lStatus]
	 set pWire [$pWiresIter NextWire $lStatus] 
	 while {$pWire !=$lNullObj} {
		
		set pAliasIter [$pWire NewAliasesIter $lStatus]
		set pAlias [$pAliasIter NextAlias $lStatus]
		while { $pAlias!=$lNullObj} {
			
			set lAliasName [DboTclHelper_sMakeCString]
			$pAlias GetName $lAliasName
			
			set lAliasStr [DboTclHelper_sGetConstCharPtr $lAliasName]
	 
			set lSearchResult [regexp $pAliasToSearch $lAliasStr]
			if { $lSearchResult == 1 } {
				set lMessage [concat "Found Alias : " $pAliasToSearch " as " $lAliasStr " on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
			
				if { $pMode == "Replace"} {
					regsub -all $pAliasToSearch $lAliasStr $pAliasToReplaceWith pReplacedAlias
					set lMessage [concat ".     .Replaced Alias : " $pAliasToSearch " found as " $lAliasStr " replaced with " $pReplacedAlias "on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
					set lMessageStr [DboTclHelper_sMakeCString $lMessage]
					DboState_WriteToSessionLog $lMessageStr
					
					set pReplacedAliasCStr [DboTclHelper_sMakeCString $pReplacedAlias]
					$pAlias SetName $pReplacedAliasCStr
					$pPage MarkModified
				}
			}
			
			set pAlias [$pAliasIter NextAlias $lStatus]
		 }
		 delete_DboWireAliasesIter $pAliasIter
		 $pAliasIter -delete
			
		unset pWire
		set pWire [$pWiresIter NextWire $lStatus] 
	 }
	 delete_DboPageWiresIter $pWiresIter
	 $pWiresIter -delete
	 unset pWire
	
	set lIsPageModified [$pPage IsModified $lStatus]
	if { $lIsPageModified == 1 } {
		catch {DboTclHelper_sEvalPage $pPage}
		catch {Menu "View::Zoom::Redraw"}
	}

	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPageOffPages { pPage pMode pOffPageToSearch pOffPageToReplaceWith } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	set pOffPageConnectorsIter [$pPage NewOffPageConnectorsIter $lStatus $::IterDefs_ALL]
	set pOffPage [$pOffPageConnectorsIter NextOffPageConnector $lStatus]
	while {$pOffPage!=$lNullObj} {
		
		set lOffPageName [DboTclHelper_sMakeCString]
		$pOffPage GetName $lOffPageName
		
		set lOffPageStr [DboTclHelper_sGetConstCharPtr $lOffPageName]
 
		set lSearchResult [regexp $pOffPageToSearch $lOffPageStr]
		if { $lSearchResult == 1 } {
			set lMessage [concat "Found OffPage : " $pOffPageToSearch " as " $lOffPageStr " on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
			set lMessageStr [DboTclHelper_sMakeCString $lMessage]
			DboState_WriteToSessionLog $lMessageStr
		
			if { $pMode == "Replace"} {
				regsub -all $pOffPageToSearch $lOffPageStr $pOffPageToReplaceWith pReplacedOffPage
				set lMessage [concat ".     .Replaced OffPage : " $pOffPageToSearch " found as " $lOffPageStr " replaced with " $pReplacedOffPage "on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
				
				set pReplacedOffPageCStr [DboTclHelper_sMakeCString $pReplacedOffPage]
				$pOffPage SetName $pReplacedOffPageCStr
				$pPage MarkModified
			}
		}
		
		unset pOffPage
		set pOffPage [$pOffPageConnectorsIter NextOffPageConnector $lStatus]
	}
	delete_DboPageOffPageConnectorsIter $pOffPageConnectorsIter
	$pOffPageConnectorsIter -delete
	unset pOffPage
	
	set lIsPageModified [$pPage IsModified $lStatus]
	if { $lIsPageModified == 1 } {
		catch {DboTclHelper_sEvalPage $pPage}
		catch {Menu "View::Zoom::Redraw"}
	}

	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPageGlobals { pPage pMode pGlobalToSearch pGlobalToReplaceWith } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	
	set pGlobalsIter [$pPage NewGlobalsIter $lStatus]
	 set pGlobal [$pGlobalsIter NextGlobal $lStatus]
	 while { $pGlobal!=$lNullObj } { 
		 
		 set lGlobalName [DboTclHelper_sMakeCString]
		$pGlobal GetName $lGlobalName
		
		set lGlobalstr [DboTclHelper_sGetConstCharPtr $lGlobalName]
 
		set lSearchResult [regexp $pGlobalToSearch $lGlobalstr]
		if { $lSearchResult == 1 } {
			set lMessage [concat "Found Global : " $pGlobalToSearch " as " $lGlobalstr " on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
			set lMessageStr [DboTclHelper_sMakeCString $lMessage]
			DboState_WriteToSessionLog $lMessageStr
		
			if { $pMode == "Replace"} {
				regsub -all $pGlobalToSearch $lGlobalstr $pGlobalToReplaceWith pReplacedGlobal
				set lMessage [concat ".     .Replaced Global : " $pGlobalToSearch " found as " $lGlobalstr " replaced with " $pReplacedGlobal "on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
				
				set pReplacedGlobalCStr [DboTclHelper_sMakeCString $pReplacedGlobal]
				$pGlobal SetName $pReplacedGlobalCStr
				$pPage MarkModified
			}
		}
		
		unset pGlobal
		set pGlobal [$pGlobalsIter NextGlobal $lStatus]
	 }
	delete_DboPageGlobalsIter $pGlobalsIter
	$pGlobalsIter -delete
	unset pGlobal

	set lIsPageModified [$pPage IsModified $lStatus]
	if { $lIsPageModified == 1 } {
		catch {DboTclHelper_sEvalPage $pPage}
		catch {Menu "View::Zoom::Redraw"}
	}

	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagePorts { pPage pMode pPortToSearch pPortToReplaceWith } { 
	set lStatus [DboState]
	set lNullObj NULL
	
	set lPageName [DboTclHelper_sMakeCString]
	$pPage GetName $lPageName
	set lPageNameStr [DboTclHelper_sGetConstCharPtr $lPageName]
	
	set lSchematicName [DboTclHelper_sMakeCString]
	set lSchematic [$pPage GetOwner]
	$lSchematic GetName $lSchematicName
	set lSchematicNameStr [DboTclHelper_sGetConstCharPtr $lSchematicName]
	
	set pPortsIter [$pPage NewPortsIter $lStatus]
	 set pPort [$pPortsIter NextPort $lStatus]
	 while { $pPort!=$lNullObj } { 
		 
		 set lPortName [DboTclHelper_sMakeCString]
		$pPort GetName $lPortName
		
		set lPortstr [DboTclHelper_sGetConstCharPtr $lPortName]
 
		set lSearchResult [regexp $pPortToSearch $lPortstr]
		if { $lSearchResult == 1 } {
			set lMessage [concat "Found Port : " $pPortToSearch " as " $lPortstr " on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
			set lMessageStr [DboTclHelper_sMakeCString $lMessage]
			DboState_WriteToSessionLog $lMessageStr
		
			if { $pMode == "Replace"} {
				regsub -all $pPortToSearch $lPortstr $pPortToReplaceWith pReplacedPort
				set lMessage [concat ".     .Replaced Port : " $pPortToSearch " found as " $lPortstr " replaced with " $pReplacedPort "on schematic : " $lSchematicNameStr " on page : " $lPageNameStr]
				set lMessageStr [DboTclHelper_sMakeCString $lMessage]
				DboState_WriteToSessionLog $lMessageStr
				
				set pReplacedPortCStr [DboTclHelper_sMakeCString $pReplacedPort]
				$pPort SetName $pReplacedPortCStr
				$pPage MarkModified
			}
		}
		
		unset pPort
		set pPort [$pPortsIter NextPort $lStatus]
	 }
	delete_DboPagePortsIter $pPortsIter
	$pPortsIter -delete
	unset pPort

	set lIsPageModified [$pPage IsModified $lStatus]
	if { $lIsPageModified == 1 } {
		catch {DboTclHelper_sEvalPage $pPage}
		catch {Menu "View::Zoom::Redraw"}
	}

	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagesForCommentTexts { pSchematic pMode pTextToSearch  pTextToReplaceWith } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPageCommentTexts $lPage $pMode $pTextToSearch  $pTextToReplaceWith
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagesForAliases { pSchematic pMode pAliasToSearch  pAliasToReplaceWith } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPageAliases $lPage $pMode $pAliasToSearch  $pAliasToReplaceWith
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagesForOffPages { pSchematic pMode pOffPageToSearch  pOffPageToReplaceWith } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPageOffPages $lPage $pMode $pOffPageToSearch  $pOffPageToReplaceWith
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagesForGlobals { pSchematic pMode pGlobalToSearch  pGlobalToReplaceWith } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPageGlobals $lPage $pMode $pGlobalToSearch  $pGlobalToReplaceWith
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitPagesForPorts { pSchematic pMode pPortToSearch  pPortToReplaceWith } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		capVisitPagePorts $lPage $pMode $pPortToSearch  $pPortToReplaceWith
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitSchematicsForCommentTexts { pDesign pMode pTextToSearch  pTextToReplaceWith } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForCommentTexts $lObj $pMode $pTextToSearch  $pTextToReplaceWith
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

proc ::capDesignUtil::capVisitSchematicsForAliases { pDesign pMode pAliasToSearch  pAliasToReplaceWith } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForAliases $lObj $pMode $pAliasToSearch  $pAliasToReplaceWith
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

proc ::capDesignUtil::capVisitSchematicsForOffPages { pDesign pMode pOffPageToSearch  pOffPageToReplaceWith } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForOffPages $lObj $pMode $pOffPageToSearch  $pOffPageToReplaceWith
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

proc ::capDesignUtil::capVisitSchematicsForGlobals { pDesign pMode pGlobalToSearch  pGlobalToReplaceWith } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForGlobals $lObj $pMode $pGlobalToSearch  $pGlobalToReplaceWith
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

proc ::capDesignUtil::capVisitSchematicsForPorts { pDesign pMode pPortToSearch  pPortToReplaceWith } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 
		capVisitPagesForPorts $lObj $pMode $pPortToSearch  $pPortToReplaceWith
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

# pMode = Search | Replace
proc ::capDesignUtil::searchAndReplaceCommentText { pMode pTextToSearch  pTextToReplaceWith} {    
	 
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [GetActivePMDesign]
	 if { $lDesign == $lNullObj} {
		#set lError [DboTclHelper_sMakeCString "Active design not found"]
		#DboState_WriteToSessionLog $lError
		return
	 }
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [$lDesign GetRootName $lName]	
	 $lStatus -delete
	 
	 capVisitSchematicsForCommentTexts $lDesign $pMode $pTextToSearch  $pTextToReplaceWith
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 return
}

# pMode = Search | Replace
proc ::capDesignUtil::searchAndReplaceAlias { pMode pAliasToSearch  pAliasToReplaceWith} {    
	 
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [GetActivePMDesign]
	 if { $lDesign == $lNullObj} {
		#set lError [DboTclHelper_sMakeCString "Active design not found"]
		#DboState_WriteToSessionLog $lError
		return
	 }
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [$lDesign GetRootName $lName]	
	 $lStatus -delete
	 
	 capVisitSchematicsForAliases $lDesign $pMode $pAliasToSearch  $pAliasToReplaceWith
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 return
}

# pMode = Search | Replace
proc ::capDesignUtil::searchAndReplaceOffPage { pMode pOffPageToSearch  pOffPageToReplaceWith} {    
	 
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [GetActivePMDesign]
	 if { $lDesign == $lNullObj} {
		#set lError [DboTclHelper_sMakeCString "Active design not found"]
		#DboState_WriteToSessionLog $lError
		return
	 }
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [$lDesign GetRootName $lName]	
	 $lStatus -delete
	 
	 capVisitSchematicsForOffPages $lDesign $pMode $pOffPageToSearch  $pOffPageToReplaceWith
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 return
}

# pMode = Search | Replace
proc ::capDesignUtil::searchAndReplaceGlobal { pMode pGlobalToSearch  pGlobalToReplaceWith} {    
	 
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [GetActivePMDesign]
	 if { $lDesign == $lNullObj} {
		#set lError [DboTclHelper_sMakeCString "Active design not found"]
		#DboState_WriteToSessionLog $lError
		return
	 }
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [$lDesign GetRootName $lName]	
	 $lStatus -delete
	 
	 capVisitSchematicsForGlobals $lDesign $pMode $pGlobalToSearch  $pGlobalToReplaceWith
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 return
}

# pMode = Search | Replace
proc ::capDesignUtil::searchAndReplacePort { pMode pPortToSearch  pPortToReplaceWith} {    
	 
	 set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 set lNullObj NULL
	 set lDesign [GetActivePMDesign]
	 if { $lDesign == $lNullObj} {
		#set lError [DboTclHelper_sMakeCString "Active design not found"]
		#DboState_WriteToSessionLog $lError
		return
	 }
	 
	 set lName [DboTclHelper_sMakeCString]
	 set lStatus [$lDesign GetRootName $lName]	
	 $lStatus -delete
	 
	 capVisitSchematicsForPorts $lDesign $pMode $pPortToSearch  $pPortToReplaceWith
	 
	 DboTclHelper_sReleaseAllCreatedPtrs
	 
	 return
}

proc ::capDesignUtil::capVisitPagesForReevaluation { pSchematic } { 
	set lStatus [DboState]
	set lPagesIter [$pSchematic NewPagesIter $lStatus]
	set lPage [$lPagesIter NextPage $lStatus]
	set lNullObj NULL
	
	while {$lPage!=$lNullObj} {
		
		set lName [DboTclHelper_sMakeCString]
		set lStatus [$lPage GetName $lName]	
		set lMessage [concat "......Page : " [DboTclHelper_sGetConstCharPtr $lName]]
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
		 
		catch {DboTclHelper_sEvalPage $lPage}
		set lPage [$lPagesIter NextPage $lStatus]
	}
	delete_DboSchematicPagesIter $lPagesIter
	$lStatus -delete
	
	return
}

proc ::capDesignUtil::capVisitSchematicsForPagesReevaluation { pDesign } {    
	set lStatus [DboState]
	 set lSchematicIter [$pDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	 set lSchematic [$lSchematicIter NextView  $lStatus]
	 set lNullObj NULL
	 while { $lSchematic!= $lNullObj} {
		set lObj [DboViewToDboSchematic $lSchematic]
	 	
		set lName [DboTclHelper_sMakeCString]
		set lStatus [$lObj GetName $lName]	
		set lMessage [concat "... Schematic : " [DboTclHelper_sGetConstCharPtr $lName]]
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
		 
		capVisitPagesForReevaluation $lObj
		set lSchematic [$lSchematicIter NextView  $lStatus]
	 }
	 delete_DboLibViewsIter $lSchematicIter
	 $lStatus -delete
	 return
}

proc ::capDesignUtil::reevaluateAllPagesOfOpenDesigns { } {    
	
	set lStatus [DboState]
	set lSession $::DboSession_s_pDboSession
	DboSession -this $lSession
	set lDesignIter [$lSession NewDesignsIter $lStatus]
	set lDesign [$lDesignIter NextDesign $lStatus]
	set lNullObj NULL
	while { $lDesign!= $lNullObj} {
		set lName [DboTclHelper_sMakeCString]
		set lStatus [$lDesign GetName $lName]	
		set lMessage [concat "Reevaluating Design : " [DboTclHelper_sGetConstCharPtr $lName]]
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
		       
		capVisitSchematicsForPagesReevaluation $lDesign
		
		set lDesign [$lDesignIter NextDesign $lStatus]
	}
	delete_DboSessionDesignsIter $lDesignIter
	
	DboTclHelper_sReleaseAllCreatedPtrs
	 
	return
}



