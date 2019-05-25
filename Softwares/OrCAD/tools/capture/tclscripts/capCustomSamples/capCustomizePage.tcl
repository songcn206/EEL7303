#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomizePage.tcl
#            contains OrCAD Capture CustomTitleBlock util while new page creation 
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capCustomizePage 1.0


namespace eval ::capCustomizePage {
	
}

proc ::capCustomizePage::onPagePreCreate { pPage } {
	SetOptionBool ShowOnlyPageSizeSelection TRUE
	catch {Menu "Options::Design Template"}
	SetOptionBool ShowOnlyPageSizeSelection FALSE
}


proc ::capCustomizePage::onPagePostCreate { pPage } {

	::capCustomizePage::AddPageTitleblocks $pPage
			
}

proc ::capCustomizePage::onPageSizeChange { pPage } {

	::capCustomizePage::AddPageTitleblocks $pPage
	
}

proc ::capCustomizePage::doHelp {  } {
	set lTitleBlockLibName [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/TESTCUSTOMIZEPAGE.OLB"]
	set lSampleScriptName [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/capcustomizePage.tcl"]
	
	set lMessage "For your reference, the sample TCL script defines three procedures : \n\n\
	- ::capCustomizePage::onPagePreCreate to be called before the page is created. \n\
	\tThe sample procedure asks the user to specify the page size option. \n\n\
	- ::capCustomizePage::onPagePostCreate to be called after the page is created. \n\
	\tThe sample procedure places different titleblocks on the page boundary to give a frame look. \n\
	\tThe boundary titleblocks are placed if the page size chosen is any one of A3, A2, A1 or A0\n\
	\tThe default titleblock placed on the page is removed\n\n\
	- ::capCustomizePage::onPageSizeChange to be called when the page size changes through Options->Schematic Page Properties. \n\
	\tThe sample procedure replaces the titleblocks on the page boundary \n\
	\tThe boundary titleblocks are placed if the page size chosen is any one of A3, A2, A1 or A0 \n\n\
	The sample TCL script file is $lSampleScriptName\n\
	The sample titleblock library is $lTitleBlockLibName"
	
	tk_messageBox -type ok -message $lMessage -title "Capture Page Customization Sample"
}

proc ::capCustomizePage::AddPageTitleblocks { pPage } {
	
	set lTitleBlockLibName [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/TESTCUSTOMIZEPAGE.OLB"]
	
	set lSizeNameCStr [DboTclHelper_sMakeCString]
	$pPage GetSizeName $lSizeNameCStr
	set lSizeName [DboTclHelper_sGetConstCharPtr $lSizeNameCStr]
	
	set lIsMetric [$pPage GetIsMetric]
	
	if { $lIsMetric == 1} {
		
		set lPlaceTitleBlocks 0
		
		switch $lSizeName {
		    
			"A4" {
				
			}
			    
			
			"A3" {
				set lPlaceTitleBlocks 1
				
				set lLeftTitleBlock  	"A3Left"
				set lRightTitleBlock  	"A3Right"
				set lTopTitleBlock  	"A3Top"
				set lBottomTitleBlock  	"A3Bottom"
			}
			    
			
			"A2" {
				set lPlaceTitleBlocks 1
				
				set lLeftTitleBlock  	"A2Left"
				set lRightTitleBlock  	"A2Right"
				set lTopTitleBlock  	"A2Top"
				set lBottomTitleBlock  	"A2Bottom"
			}
			    
			
			"A1" {
				set lPlaceTitleBlocks 1
				
				set lLeftTitleBlock  	"A1Left"
				set lRightTitleBlock  	"A1Right"
				set lTopTitleBlock  	"A1Top"
				set lBottomTitleBlock  	"A1Bottom"
			}
			    
			
			"A0" {
				set lPlaceTitleBlocks 1
				
				set lLeftTitleBlock  	"A0Left"
				set lRightTitleBlock  	"A0Right"
				set lTopTitleBlock  	"A0Top"
				set lBottomTitleBlock  	"A0Bottom"
			}
			    
			"Custom" {
				# place a title block depending upon the page width and height
				# place the code here
			}
			    
			default {
			}
		    
		}
		
		if { $lPlaceTitleBlocks == 1} {
			#puts "Placing boundary titleblocks on page size $lSizeName"
			
			#remove any existing title  block
			::capCustomizePage::RemovePageTitleblocks $pPage
			
			# place boundary title-blocks
			::capCustomizePage::PlaceTitleBlock $pPage $lTitleBlockLibName $lLeftTitleBlock $lLeftTitleBlock "Left"
			::capCustomizePage::PlaceTitleBlock $pPage $lTitleBlockLibName $lTopTitleBlock $lTopTitleBlock  "Top"
			::capCustomizePage::PlaceTitleBlock $pPage $lTitleBlockLibName $lBottomTitleBlock $lBottomTitleBlock "Bottom"
			::capCustomizePage::PlaceTitleBlock $pPage $lTitleBlockLibName $lRightTitleBlock $lRightTitleBlock "Right"
		}
	
	} else {
	
		switch $lSizeName {
		   
			"A" {
			}
		    
			"B" {
			}
		    
			"C" {
			}
		    
			"D" {
				
			}
		    
			"E" {
			}
		    
			"Custom" {
				# place a title block depending upon the page width and height
				# place the code here
			}
		    
			default {
			}
		}
	}
	
}

proc ::capCustomizePage::ConvertUserToDoc { pPage pUser } {
	set lDocDouble [expr "[$pPage GetPhysicalGranularity] * $pUser * 1.0 + 0.5"]
	set lDoc [expr "round($lDocDouble)"]
	
	#puts "User = $pUser ---> Doc = $lDoc"
	return $lDoc
}

proc ::capCustomizePage::AdjustPinToPinScaleFactor { pPage pDoc } {
	set lDocDouble [expr "[$pPage GetPinToPinScaleFactor] * $pDoc * 1.0 + 0.5"]
	set lDoc [expr "round($lDocDouble)"]
	
	return $lDoc
}

proc ::capCustomizePage::NewTitleBlock { pPage pLibName pSymbolName pInstName } {

	set lNullObj NULL
	set lStatus [DboState]
	
	#puts "Inside NewTitleBlock"
	
	set lSession $::DboSession_s_pDboSession
	 DboSession -this $lSession
	 
	set lLibName [DboTclHelper_sMakeCString $pLibName]
	
	set lLib [$lSession GetLib $lLibName $lStatus]
	if { $lLib == $lNullObj } {
		return $lNullObj
	}
	#puts $lLib
	
	set lSymbolName [DboTclHelper_sMakeCString $pSymbolName]
	set lDboSymbol [$lLib GetSymbol $lSymbolName $lStatus]
	if { $lDboSymbol == $lNullObj } {
		return $lNullObj
	}
	#puts $lDboSymbol
	
	set lTitleBlockSymbol [DboSymbolToDboTitleBlockSymbol $lDboSymbol]
	#puts $lTitleBlockSymbol
	set lInstName [DboTclHelper_sMakeCString $pInstName]
	
	set lDboTitleBlock [$pPage NewTitleBlock $lStatus $lTitleBlockSymbol $lInstName]
	
	$lStatus -delete
	
	#puts $lDboTitleBlock
	
	return $lDboTitleBlock
}		
	

proc ::capCustomizePage::PlaceTitleBlock { pPage pLibName pSymbolName pInstName pSide } {

	set lNullObj NULL
	set lTitleBlock [::capCustomizePage::NewTitleBlock $pPage $pLibName $pSymbolName $pInstName]
	
	set lPageWidth [$pPage GetPageWidth]
	set lPageHeight [$pPage GetPageHeight]

	set lPageWidthtUser [expr "$lPageWidth/1000.0"]
	set lPageHeightUser [expr "$lPageHeight/1000.0"]
	
	#puts "PageWidth is $lPageWidth ---> $lPageWidthtUser"
	#puts "PageHeight is $lPageHeight ---> $lPageHeightUser"
	
	if { $lTitleBlock != $lNullObj} {
		if {$pSide == "Top"} {
			
			set pX 0
			set pY 0
		
		} elseif {$pSide == "Left"} {
			
			set pX 0
			set pY 0
		
		} elseif {$pSide == "Right"} {
			
			set pX [::capCustomizePage::ConvertUserToDoc $pPage $lPageWidthtUser]
			set pY 0
			
			#offset towards left equal to the width of titleblock
			set x1 [DboTclHelper_sGetCPointX [DboTclHelper_sGetCRectTopLeft [$lTitleBlock GetBoundingBox]]]
			set x2 [DboTclHelper_sGetCPointX [DboTclHelper_sGetCRectBottomRight [$lTitleBlock GetBoundingBox]]]
			
			set x1 [::capCustomizePage::AdjustPinToPinScaleFactor $pPage $x1]
			set x2 [::capCustomizePage::AdjustPinToPinScaleFactor $pPage $x2]
			
			#puts "Placing $pSide with $pX - abs($x2-$x1)"
			set pX [expr "$pX - abs($x2-$x1)"]
		
		} elseif {$pSide == "Bottom"} {
			
			set pX 0
			set pY [::capCustomizePage::ConvertUserToDoc $pPage $lPageHeightUser]
			
			#offset towards top equal to the height of titleblock 
			set y1 [DboTclHelper_sGetCPointY [DboTclHelper_sGetCRectTopLeft [$lTitleBlock GetBoundingBox]]]
			set y2 [DboTclHelper_sGetCPointY [DboTclHelper_sGetCRectBottomRight [$lTitleBlock GetBoundingBox]]]
			
			set y1 [::capCustomizePage::AdjustPinToPinScaleFactor $pPage $y1]
			set y2 [::capCustomizePage::AdjustPinToPinScaleFactor $pPage $y2]
			
			#puts "Placing $pSide with $pY - abs($y2-$y1)"
			set pY [expr "$pY - abs($y2-$y1)"]
		
		}
		
		#puts [concat $pSide $pX $pY]
		set lLocation [DboTclHelper_sMakeCPoint $pX $pY]
		$lTitleBlock SetLocation $lLocation
		$lTitleBlock SetKeepInLowerRightCorner 0
	} else {
		puts [concat "Title Block symbol " $pSymbolName " in library " $pLibName " not found"]
	}

	return
}

proc ::capCustomizePage::RemovePageTitleblocks { pPage } {
	set lStatus [DboState]
	set lNullObj NULL
	
	#puts "Inside ::capCustomizePage::RemovePageTitleblocks"
	
	set lAllPageTitleBlocks [list]
	
	set pTitleBlocksIter [$pPage NewTitleBlocksIter $lStatus]
	set pTitle [$pTitleBlocksIter NextTitleBlock $lStatus]
	while {$pTitle!=$lNullObj} {
		lappend lAllPageTitleBlocks $pTitle
		set pTitle [$pTitleBlocksIter NextTitleBlock $lStatus]
	}
	delete_DboPageTitleBlocksIter $pTitleBlocksIter
	
	foreach lTitleBlock $lAllPageTitleBlocks {
		#puts [concat "Deleting title block " $lTitleBlock]
		$pPage DeleteTitleBlock $lTitleBlock
	}
	
	$lStatus -delete
}

