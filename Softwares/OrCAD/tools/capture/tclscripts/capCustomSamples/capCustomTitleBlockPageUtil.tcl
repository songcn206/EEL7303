#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomTitleBlockPageUtil.tcl
#            contains OrCAD Capture CustomTitleBlock util while new page creation 
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capCustomTitleBlockPageUtil 1.0


namespace eval ::capCustomTitleBlockPageUtil {
	
}

proc ::capCustomTitleBlockPageUtil::RemovePageTitleblocks { pPage } {
	set lStatus [DboState]
	set lNullObj NULL
	
	#puts "Inside ::capCustomTitleBlockPageUtil::RemovePageTitleblocks"
	
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

proc ::capCustomTitleBlockPageUtil::AddPageTitleblocks { pPage } {
	
	::capCustomTitleBlockPageUtil::RemovePageTitleblocks $pPage
	
	set lTitleBlockLibName "D:/TEMP/TITLEBLOCK-614.OLB"
	
	set lSizeNameCStr [DboTclHelper_sMakeCString]
	$pPage GetSizeName $lSizeNameCStr
	set lSizeName [DboTclHelper_sGetConstCharPtr $lSizeNameCStr]
	puts $lSizeName
	
	set lIsMetric [$pPage GetIsMetric]
	
	if { $lIsMetric == 1} {
		
		set lPlaceTitleBlocks 0
		
		switch $lSizeName {
		    
			"A4" {
				#set lPlaceTitleBlocks 1
				
				#set lLeftTitleBlock  	"A4Left"
				#set lRightTitleBlock  	"A4Right"
				#set lTopTitleBlock  	"A4Top"
				#set lBottomTitleBlock  	"A4Bottom"
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
				set lPageWidth [$pPage GetPageWidth]
				set lPageHeight [$pPage GetPageHeight]
	
				if { $lPageWidth == 210000 && $lPageHeight == 297000} {
					set lPlaceTitleBlocks 	1
					
					# these titleblocks are designed for rotated A4
					set lLeftTitleBlock  	"A4Left"
					set lRightTitleBlock  	"A4Right"
					set lTopTitleBlock  	"A4Top"
					set lBottomTitleBlock  	"A4Bottom"
				}
				
				# place a title block depending upon the page width and height
				# place the code here
			}
			    
			default {
			}
		    
		}
		
		if { $lPlaceTitleBlocks == 1} {
			::capCustomTitleBlockPageUtil::PlaceTitleBlock $pPage $lTitleBlockLibName $lLeftTitleBlock $lLeftTitleBlock "Left"
			::capCustomTitleBlockPageUtil::PlaceTitleBlock $pPage $lTitleBlockLibName $lTopTitleBlock $lTopTitleBlock  "Top"
			::capCustomTitleBlockPageUtil::PlaceTitleBlock $pPage $lTitleBlockLibName $lBottomTitleBlock $lBottomTitleBlock "Bottom"
			::capCustomTitleBlockPageUtil::PlaceTitleBlock $pPage $lTitleBlockLibName $lRightTitleBlock $lRightTitleBlock "Right"
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

proc ::capCustomTitleBlockPageUtil::ConvertUserToDoc { pPage pUser } {
	set lDocDouble [expr "[$pPage GetPhysicalGranularity] * $pUser + 0.5"]
	set lDoc [expr "round($lDocDouble)"]
	return $lDoc
}

proc ::capCustomTitleBlockPageUtil::NewTitleBlock { pPage pLibName pSymbolName pInstName } {

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
	

proc ::capCustomTitleBlockPageUtil::PlaceTitleBlock { pPage pLibName pSymbolName pInstName pSide } {

	set lNullObj NULL
	set lTitleBlock [::capCustomTitleBlockPageUtil::NewTitleBlock $pPage $pLibName $pSymbolName $pInstName]
	
	set lPageWidth [$pPage GetPageWidth]
	set lPageHeight [$pPage GetPageHeight]
	
	set lPageWidthtUser [expr "$lPageWidth/1000"]
	set lPageHeightUser [expr "$lPageHeight/1000"]
	
	if { $lTitleBlock != $lNullObj} {
		if {$pSide == "Top"} {
			
			set pX 0
			set pY 0
		
		} elseif {$pSide == "Left"} {
			
			set pX 0
			set pY 0
		
		} elseif {$pSide == "Right"} {
			
			set pX [::capCustomTitleBlockPageUtil::ConvertUserToDoc $pPage $lPageWidthtUser]
			set pY 0
			
			#offset towards left equal to the width of titleblock
			set x1 [DboTclHelper_sGetCPointX [DboTclHelper_sGetCRectTopLeft [$lTitleBlock GetBoundingBox]]]
			set x2 [DboTclHelper_sGetCPointX [DboTclHelper_sGetCRectBottomRight [$lTitleBlock GetBoundingBox]]]
			set pX [expr "$pX - abs($x2-$x1)"]
		
		} elseif {$pSide == "Bottom"} {
			
			set pX 0
			set pY [::capCustomTitleBlockPageUtil::ConvertUserToDoc $pPage $lPageHeightUser]
			
			#offset towards top equal to the height of titleblock 
			set y1 [DboTclHelper_sGetCPointY [DboTclHelper_sGetCRectTopLeft [$lTitleBlock GetBoundingBox]]]
			set y2 [DboTclHelper_sGetCPointY [DboTclHelper_sGetCRectBottomRight [$lTitleBlock GetBoundingBox]]]
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

proc ::capCustomTitleBlockPageUtil::AddPageTitleblocksPreCreate { pPage } {
	SetOptionBool ShowOnlyPageSizeSelection TRUE
	catch {Menu "Options::Design Template"}
	SetOptionBool ShowOnlyPageSizeSelection FALSE
}

proc ::capCustomTitleBlockPageUtil::capTrue { pPage } {
	return 1
}

proc ::capCustomTitleBlockPageUtil::ReplacePageTitleblocks { pPage pOcc } {
	#puts "Inside  ::capCustomTitleBlockPageUtil::ReplacePageTitleblocks"
	::capCustomTitleBlockPageUtil::AddPageTitleblocks $pPage
	Menu "View::Zoom::Redraw"
}

proc ::capCustomTitleBlockPageUtil::AddCustomMenuP { } {
	AddAccessoryMenu "Title Block" "Replace" "::capCustomTitleBlockPageUtil::ReplacePageTitleblocks"
}

proc ::capCustomTitleBlockPageUtil::capMenuTrue { } {
	return 1
}

#RegisterAction "_cdnCapTclAddPageCustomMenu" "::capCustomTitleBlockPageUtil::capMenuTrue" "" "::capCustomTitleBlockPageUtil::AddCustomMenuP" ""
RegisterAction "_cdnOrOnNewSchematicPage" "::capCustomTitleBlockPageUtil::capTrue" "" "::capCustomTitleBlockPageUtil::AddPageTitleblocks" ""
RegisterAction "_cdnOrOnNewSchematicPagePreCreate" "::capCustomTitleBlockPageUtil::capTrue" "" "::capCustomTitleBlockPageUtil::AddPageTitleblocksPreCreate" ""
RegisterAction "_cdnOrOnSchematicPageAttributeChange" "::capCustomTitleBlockPageUtil::capTrue" "" "::capCustomTitleBlockPageUtil::AddPageTitleblocks" ""

