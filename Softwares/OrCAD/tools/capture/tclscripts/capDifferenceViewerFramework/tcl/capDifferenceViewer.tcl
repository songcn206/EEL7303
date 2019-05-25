#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDifferenceViewer.tcl
#            contains Diff and Merge GUI Framework
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDifferenceViewerFramework\tcl\capDifferenceViewer.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require orPrmJSON
package require orPrmStreamer
package require orPrmDebug
package require orPrmDboHierStreamer
package require orPrmUtils 1.0
package require orPrmWebComp

package provide capDifferenceViewer 1.0


namespace eval ::capDifferenceViewer {
	set gScriptDir [file dirname [info script]]
	set gRootDir [file join $::capDifferenceViewer::gScriptDir ..]
	set gWidgetId 0
}

proc ::capDifferenceViewer::capLaunchWidget {args} {

    set lModalId [orPrm::GetNextId]
    set ::capDifferenceViewer::gWidgetId $lModalId
    set res [correctUNCPath [file join $::capDifferenceViewer::gRootDir hybrid DiffViewer.html]]
    set actualDialogId [orPrm::CreateModalDialog $lModalId $res "Diff And Merge" 780 225 1]

}

proc ::capDifferenceViewer::capGetActiveDesign {} {
	set lDesign [GetActivePMDesign]
	set lDesignNameString [DboTclHelper_sMakeCString]
	$lDesign GetName $lDesignNameString
	set lDesignName [DboTclHelper_sGetConstCharPtr $lDesignNameString]
	return $lDesignName

}

proc ::capDifferenceViewer::capOpenFileChooser {} {

	set lDesignNameString [capOpenFileDialog 0]
	set lDesignName [DboTclHelper_sGetConstCharPtr $lDesignNameString]
	return $lDesignName
}

proc ::capDifferenceViewer::capGetJSONData { path } {
	set JsonData [orPrmDboHierStreamer::getInstHierStreamFromFile $path $::DboBaseObject_PAGE]
	set JsonData [string map {\\ \\\\} $JsonData]
	return $JsonData
}

proc ::capDifferenceViewer::capCloseWidget {} {
	orPrm::DestroyWidget $::capDifferenceViewer::gWidgetId
}

proc ::capDifferenceViewer::capHelpDifferenceViewer {} {
}

proc ::capDifferenceViewer::capShowDifferences { args } {
	
	capDifferenceViewer::capCloseWidget
	
	set lOccMode 	[lindex $args 0]
	set lCompKey 	[lindex $args 1]
	set lDesign1 	[lindex $args 2]
	set lSchm1 	 	[lindex $args 3]
	set lPage1   	[lindex $args 4]
	set lDesign2 	[lindex $args 5]
	set lSchm2    	[lindex $args 6]
	set lPage2     	[lindex $args 7]
	set lSelectMod 	[lindex $args 8]
	
	if { $lCompKey == 0 } {
		SetOptionString DFE_Use_REFDES_ASKEY TRUE
	} else {
		SetOptionString DFE_Use_REFDES_ASKEY FALSE
	}
	
	if { $lSelectMod == 0 } {
		puts "svsDiffDesigns $lDesign1 $lDesign2 $lOccMode"
		svsDiffDesigns $lDesign1 $lDesign2 $lOccMode
	} elseif { $lSelectMod == 1 } {
		puts "svsDiffDesigns $lDesign1 $lDesign2 $lOccMode SCHEMATIC_VIEW $lSchm1 $lSchm2"
		svsDiffDesigns $lDesign1 $lDesign2 $lOccMode SCHEMATIC_VIEW $lSchm1 $lSchm2
	
	} elseif { $lSelectMod == 2 } {
		set lPagePath1  "$lSchm1!$lPage1"
		set lPagePath2  "$lSchm2!$lPage2"
		puts "svsDiffDesigns $lDesign1 $lDesign2 $lOccMode SCHEMATIC_PAGE $lPagePath1 $lPagePath2"
		svsDiffDesigns $lDesign1 $lDesign2 $lOccMode SCHEMATIC_PAGE $lPagePath1 $lPagePath2
	} else {
		#For Future use
	}
	
	
}

proc ::capDifferenceViewer::capFileExist { path } {
	return [file isfile $path]
}

proc ::capDifferenceViewer::capSetSize { pMode } {
	if { $pMode == 0 } {
		orPrm::SetSize $::capDifferenceViewer::gWidgetId 780 190
	} elseif { $pMode == 1 }  {
		orPrm::SetSize $::capDifferenceViewer::gWidgetId 780 225
	} else {
		orPrm::SetSize $::capDifferenceViewer::gWidgetId 780 527
	}
}

