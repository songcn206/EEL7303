#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2012 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////
package require Tcl 8.4
package require orPrmWebComp 1.0
package require Capture 16.6
package require orPrmUtils
package provide  learningResources 16.6

namespace eval ::learningResources {
	set lScriptDir [file dirname [info script]]
	variable WidgetId
	namespace export openApp
	namespace export TclDirectoryListing
	namespace export openProject
	namespace export TclFileRead
	namespace export addMenu
}

proc ::learningResources::openApp { args } {

	set url [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid caplearningresources.htm]]
	set id [orPrm::CreateWidget $::orPrm::WTYPE_VIEW]
	set ::learningResources::WidgetId $id
	orPrm::SetTitle $id "Learning PSpice"
	# after idle ::learningResources::showHTML $id $url
	orPrm::LoadResource $id $url
}
 
proc ::_DummyTrue { args } {
    return true
}

proc ::learningResources::openProjectSim {Bookname Chapter DesignFolderName DesignName SchematicName PageName ProfileName } {
	set path [correctUNCPath [file join $::env(HOME) cdssetup OrCAD_Capture 16.6.0 tclscripts caplearningresources hybrid supportfiles $Bookname $Chapter $DesignFolderName $DesignName.opj]]
	set SourcePath [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid supportfiles $Bookname $Chapter $DesignFolderName]]
	set ExampleRunFromMode [GetOptionString LearningAppExampleFromHier]
	set exampleLocalCopy [file exists $path]
# ExampleMode =1 represent that user would like run these from Hier itself. 
	if { $ExampleRunFromMode == "1" } {
	DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Opening Design from Install Hier" ]
	set path [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid supportfiles $Bookname $Chapter $DesignFolderName $DesignName.opj]]
	} else {
	if { $exampleLocalCopy == "0" } {
		::learningResources::CopyExample $Bookname $Chapter $DesignFolderName
		} 			
	}

#	set path [file join $::learningResources::lScriptDir ../ hybrid supportfiles $Bookname $Chapter $DesignFolderName $DesignName.opj]
	Open $path
	SelectPMItem "Design Resources"
	capDesignOpenMessage
	capEventNotify 4004 [capGetPMId]
	SelectPMItem "${SchematicName}-${ProfileName}"
	catch {Menu "PSpice::Make Active"} err
	if {$err=="Menu Disabled for Current Selection" } {  
} 

	SelectPMItem "${SchematicName}/${PageName}"
	OPage "${SchematicName}" "${PageName}" 
	ZoomAll
     	}


proc ::learningResources::openProject {Bookname Chapter DesignFolderName DesignName SchematicName PageName} {
	set path [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid supportfiles $Bookname $Chapter $DesignFolderName $DesignName.opj]]
	Open $path
	SelectPMItem "Design Resources"
	capDesignOpenMessage
	capEventNotify 4004 [capGetPMId]
	SelectPMItem "${SchematicName}/${PageName}"
	OPage "${SchematicName}" "${PageName}" 
	ZoomAll
}

proc ::learningResources::addMenu { } {

set bookPath [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid supportfiles]]
set avlbBooks [glob -nocomplain -directory $bookPath -type d *];
if { $avlbBooks != "" } {
	RegisterAction "_OpenBasic" "::_DummyTrue" "" "::learningResources::openApp" "" 
	RegisterAction "procTrueOnlearningResources" "::_DummyTrue" "" "::_DummyTrue" ""
	InsertXMLMenu [list [list "Help" "LearningResources"] "0" "HelpLearningOrCADCapture" [list "action" "Learning &PSpice"  "0" "_OpenBasic" "procTrueOnlearningResources" ]]
	DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Adding Learning Resources ... under Help Menu"]
	}

}

proc ::learningResources::showHTML { id url } {
orPrm::LoadResource $id $url
# SetSize $id 60 30
# ShowWidget $id 1
}


proc ::learningResources::TclDirectoryListing {directorypath} {
	set lst [glob -nocomplain $directorypath/topics.json];
	set ret [join $lst "*$"];
	return $ret;
}

proc ::learningResources::TclFileRead {pFilename} {
    set lRetVal {}
    if { 1 == [catch {set lFH [open $pFilename r]}] } {
        set lRetVal "Unable to open $pFilename"
    } else {
        set lRetVal [read $lFH]
        close $lFH
    }
    return $lRetVal
}

proc ::learningResources::TclSubDirectoryListing {directorypath} {
	set lst [glob -nocomplain -directory $directorypath -type d *];
	set ret [join $lst "*$"];
	return $ret;
}

proc ::learningResources::CopyExample {Bookname Chapter DesignFolderName} {
		set SourcePath [correctUNCPath [file join $::learningResources::lScriptDir .. hybrid supportfiles $Bookname $Chapter $DesignFolderName]]
		set AppExampleFrmHomePath [correctUNCPath [file join $::env(HOME) cdssetup OrCAD_Capture 16.6.0 tclscripts caplearningresources hybrid supportfiles $Bookname $Chapter]]
		set AppExamplePath [correctUNCPath [file join $::env(HOME) cdssetup OrCAD_Capture 16.6.0 tclscripts caplearningresources hybrid supportfiles $Bookname $Chapter $DesignFolderName]]
		file mkdir $AppExampleFrmHomePath
		DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Copying example design files to $AppExampleFrmHomePath" ]
		if {[catch { file copy -force $SourcePath $AppExampleFrmHomePath
			 eval exec [auto_execok attrib] -r "$AppExamplePath/*.*" /s } sError]} {
 	  	DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Copy of example design files to $AppExampleFrmHomePath failed" ]
		} else {
		DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Copy of example design files to $AppExampleFrmHomePath completed" ]
			}
}



