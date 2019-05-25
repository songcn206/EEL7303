#/////////////////////////////////////////////////////////////////////////////////
# Copyright Cadence Design Systems, Inc. 2012 All Rights Reserved.
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
# Cadence Design Systems, Inc is not responsible for any deviation between 
# actual device behavior and results obtained from simulation.
#  TCL file: capPSpiceModelApp.tcl
#            Modeling application to creating and editing spice models for various devices.
# 	Currently supported list of device are: Transformer, Inductor
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {<INSTALLDIR>\capPSpiceModelingApps\capPSpiceModelApp.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require DboTclWriteBasic 16.3.0 
package provide capPSpiceModelAppBase 1.0

proc capPSpAppEnabler { args } {

	if { [IsSchematicViewActive] == 1} {
		return true
		}
    return false
	
}

proc capPSpAppTrue { args } {
    return true
}

RegisterAction "_ModelAppEnabler" "capPSpAppTrue" "" "capPSpAppEnabler" ""
RegisterAction "_Transformer" "capPSpAppTrue" "" "_LaunchTransfromer" ""
RegisterAction "Edit PSpice Component" "_EditEnable" "" "_Edit" "Schematic"
RegisterAction "_Inductor" "capPSpAppTrue" "" "_LaunchInductor" ""
# InsertXMLMenu [list [list "Place" "PSpiceComponent"] "1" "PlacePart"  [list "popup" "P&Spice Component..."  "" "" "" "" ""] ""]
InsertXMLMenu [list [list "Place" "PSpiceComponent" "ModelApp"] "" ""  [list "popup" "&Modeling Application..."  "" "" "" "" ""] ""]
InsertXMLMenu [list [list "Place" "PSpiceComponent" "ModelApp" "Transformer"] "" "" [list "action" "&Transformer"  "0" "_Transformer" "_ModelAppEnabler" "" "tip"] ""]
InsertXMLMenu [list [list "Place" "PSpiceComponent" "ModelApp" "Inductor"] "" "" [list "action" "&Inductor"  "0" "_Inductor" "_ModelAppEnabler" "" "tipAAA"] ""]

proc _LaunchTransfromer {} { 
package require capPSpiceModelAppBase 1.0
::capPSpiceModelAppBase::Transformer all all
}

proc _Edit {} { 
package require capPSpiceModelAppBase 1.0
::ModelAppUtils::ModelAppLauncher

}

proc _EditEnable {} { 
package require capPSpiceModelAppBase 1.0
set lEnableRotate 0 
# Get the selected objects 
set lSelObjs [GetSelectedObjects] 
# Enable only for single object selection 
if { [llength $lSelObjs] == 1 } { 
# Enable only if a part or a hierarchical block is selected 
set lObj [lindex $lSelObjs 0] 
set lObjType [DboBaseObject_GetObjectType $lObj] 
if { $lObjType == 13 || $lObjType == 12 } { 
set AppCompType [::capPSpiceModelAppBase::GetAppType $lSelObjs]
if { $AppCompType != ""} {
	set lEnableRotate 1 
	}
} 
} 

return $lEnableRotate 
} 


proc _LaunchInductor {} { 
package require capPSpiceModelAppBase 1.0
::capPSpiceModelAppBase::Inductor all all
}


namespace eval ::capPSpiceModelAppBase {
#	namespace export Transformer
#	namespace export Inductor
	variable jFilePath "JJ"
	variable mFilePath "MM"
	variable FilePath "FF"
	variable ImplementationProp ""
	namespace export ReadJs
	namespace export WriteJs
	namespace export CreateAppsDir
	namespace export ReadOpjPath
	variable AppName "None"
	set lScriptDir [file dirname [info script]]
	set lRootDir [file join $::capPSpiceModelAppBase::lScriptDir ..]
	set DefaultValJSON {{"Transformer": [{"Name": "MyTrModel", "Type": "ST","LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"100n","Rst":"1" }],
	"Inductor": [{"Name": "MyIndModel", "Type": "IND","ind": "100u","rdc": "10m","qfac": "33","srf": "2Meg","res": "100Meg" }]}}
}

namespace eval ::ModelAppUtils { 
	namespace export ModelAppEnabler 
	namespace export ModelAppLauncher 
	variable mLaunched 0
	variable mSelectedObject NULL
	variable JsData 0
	variable WidgetId 0
} 

namespace eval ::capEventHandlerUtil {
	
}

proc ::ModelAppUtils::ModelAppEnabler {} {set lEnableRotate 0 
# Get the selected objects 
set lSelObjs [GetSelectedObjects] 
# Enable only for single object selection 
if { [llength $lSelObjs] == 1 } { 
# Enable only if a part or a hierarchical block is selected 
set lObj [lindex $lSelObjs 0] 
set lObjType [DboBaseObject_GetObjectType $lObj] 
if { $lObjType == 13 || $lObjType == 12 } { 
 if { $::ModelAppUtils::mLaunched == 0} {
	set lEnableRotate 1 
	}
} 
} 
#elseif {[llength $lSelObjs] == 0} {
#	set lEnableRotate 0 
#}
return $lEnableRotate 
} 

proc ::ModelAppUtils::ModelAppLauncher {} { 
set ::ModelAppUtils::mSelectedObject [GetSelectedObjects] 
set ::ModelAppUtils::mLaunched 0
global AppType
global ModelType
global Ref
::capPSpiceModelAppBase::ReadOpjPath
::capPSpiceModelAppBase::CreateAppsDir
::capPSpiceModelAppBase::ReadJs
::capPSpiceModelAppBase::GetAppType $::ModelAppUtils::mSelectedObject
DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Launching $AppType PSpice Modeling App"]
eval ::capPSpiceModelAppBase::$AppType $ModelType $Ref


}

proc ::capPSpiceModelAppBase::ReadOpjPath {} {
set OpjL [string trimright [string tolower [set Opj [GetActiveOpjName]]] ".opj"]

set lCString [DboTclHelper_sMakeCString]
set lDesign [GetActivePMDesign]
set lStatus [DboState]
set lSch [$lDesign GetRootSchematic $lStatus]
$lSch GetName $lCString
set SchName [DboTclHelper_sGetConstCharPtr $lCString]
# set ::capPSpiceModelAppBase::FilePath [concat $OpjL-PSpiceFiles\\$SchName\\Model_$SYM\_$RefDes.lib ]
# set ::capPSpiceModelAppBase::jFilePath [concat $OpjL-PSpiceFiles\\$SchName\\PSpiceModelApps_data.json ]
# set ::capPSpiceModelAppBase::mFilePath [concat $OpjL-PSpiceFiles\\$SchName\\PSpiceModelApps_Include.lib ]
set ::capPSpiceModelAppBase::jFilePath [concat $OpjL-PSpiceFiles\\PSpiceModelApps\\PSpiceModelApps_data.json ]
set ::capPSpiceModelAppBase::mFilePath [concat $OpjL-PSpiceFiles\\PSpiceModelApps\\PSpiceModelApps_Include.lib ]
}


proc ::capPSpiceModelAppBase::WriteModel {ModelText SYM RefDes} {
set OpjL [string trimright [string tolower [set Opj [GetActiveOpjName]]] ".opj"]
set lCString [DboTclHelper_sMakeCString]
set lDesign [GetActivePMDesign]
set lStatus [DboState]
set lSch [$lDesign GetRootSchematic $lStatus]
$lSch GetName $lCString
set SchName [DboTclHelper_sGetConstCharPtr $lCString]
# set ::capPSpiceModelAppBase::FilePath [concat $OpjL-PSpiceFiles\\$SchName\\Model_$SYM\_$RefDes.lib ]
set ::capPSpiceModelAppBase::FilePath [concat $OpjL-PSpiceFiles\\PSpiceModelApps\\Model_$RefDes.lib ]
set fd [open $::capPSpiceModelAppBase::FilePath w+]
puts $fd $ModelText
close $fd
DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Updated $::capPSpiceModelAppBase::FilePath Model library File for Model $RefDes"]


if {[file exists $::capPSpiceModelAppBase::mFilePath] == 1} {
set found 0
set fp [open $::capPSpiceModelAppBase::mFilePath r]
while {-1 != [gets $fp line]} {
		string toupper $SYM
		string toupper $line
		if {[regexp -nocase Model_$RefDes $line] == 1} {
		set found 1
		break
		}
		
				}
	
	if {$found != 1} { 
#		set LibName [concat .lib Model_$SYM\_$RefDes.lib]
		set LibName [concat .lib Model_$RefDes.lib]
		set fd [open $::capPSpiceModelAppBase::mFilePath a+]
		puts $fd $LibName
		close $fd

		}

} else {
set fd1 [open $::capPSpiceModelAppBase::mFilePath a+]
puts $fd1 "*PSpice Modeling Apps Index library File" 
#		set LibName [concat .lib Model_$SYM\_$RefDes.lib]
		set LibName [concat .lib Model_$RefDes.lib]
		puts $fd1 $LibName
close $fd1
DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Updated PSpice Modeling Apps Index library File for Model_$RefDes.lib"]
}
}

proc ::capPSpiceModelAppBase::UpdateModel {ModelName} {
set lSelObjs1 $::ModelAppUtils::mSelectedObject
set lObj1 [lindex $lSelObjs1 0] 
set lPropNameCStr [DboTclHelper_sMakeCString "Implementation"] 
set lPropValueCStr [DboTclHelper_sMakeCString $ModelName] 
set lStatus [$lObj1 SetEffectivePropStringValue $lPropNameCStr $lPropValueCStr]

}

proc getStream {url} {
return $url
}
proc ::capPSpiceModelAppBase::showHTML { id url } {
LoadResource $id $url
# SetSize $id 60 30
# ShowWidget $id 1
}

proc ::capPSpiceModelAppBase::GetAppType {lObject} {
global AppType
global ModelType
global Ref
set lStatus [DboState]
set lPrpName [DboTclHelper_sMakeCString "PSpiceModelingAppType"] 
set lPrpValue [DboTclHelper_sMakeCString]
set lModelVal [DboTclHelper_sMakeCString]
set lRef [DboTclHelper_sMakeCString]
$lObject GetEffectivePropStringValue $lPrpName $lPrpValue
set AppType [DboTclHelper_sGetConstCharPtr $lPrpValue]
set ::capPSpiceModelAppBase::AppName $AppType
$lObject GetSourcePackageName $lModelVal
set ModelType [DboTclHelper_sGetConstCharPtr $lModelVal]
# $lObject GetReference $lRef
# set Ref [DboTclHelper_sGetConstCharPtr $lRef]
set lPropNameCStr [DboTclHelper_sMakeCString "Implementation"] 
set lImpPrpValue [DboTclHelper_sMakeCString]
$lObject GetEffectivePropStringValue $lPropNameCStr $lImpPrpValue
set Ref [DboTclHelper_sGetConstCharPtr $lImpPrpValue]
return $::capPSpiceModelAppBase::AppName
}

proc ::capPSpiceModelAppBase::Transformer {type Ref} {
set ::capPSpiceModelAppBase::AppName "Transformer"
if {$type == "all"} { set ::ModelAppUtils::mSelectedObject NULL}
# set url "D:/Work/JAVA_Script/Transfomer/Grid_View/Transformer.htm?"
# set url [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir capPSpiceModelApp Transformer hybrid Transformer.htm?]]
set url [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir Transformer hybrid Transformer.htm?]]
# set url ${url}Type=${type}&Refdes=${Ref}&JD=${::ModelAppUtils::JsData}
set url ${url}Type=${type}&Refdes=${Ref}
set id [CreateWidget $::WTYPE_VIEW]
set ::ModelAppUtils::WidgetId $id
# puts "create id --- $id and $::ModelAppUtils::WidgetId"
SetTitle $id "Transformer Model"
after idle ::capPSpiceModelAppBase::showHTML $id $url
}

proc ::capPSpiceModelAppBase::Inductor {type Ref} {
set ::capPSpiceModelAppBase::AppName "Inductor"
if {$type == "all"} { set ::ModelAppUtils::mSelectedObject NULL}
#set url "D:/Work/JAVA_Script/Inductor/Inductor.htm?"
set url [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir Inductor hybrid Inductor.htm?]]
set url ${url}Type=${type}&Refdes=${Ref}
# puts $url
set id [CreateWidget $::WTYPE_VIEW]
SetTitle $id "Inductor Model"
set ::ModelAppUtils::WidgetId $id
after idle ::capPSpiceModelAppBase::showHTML $id $url
}


proc ::capPSpiceModelAppBase::WriteJs {data} {
::capPSpiceModelAppBase::ReadOpjPath
set JsPath $::capPSpiceModelAppBase::jFilePath
set fdwjs [open $JsPath w+]
puts $fdwjs $data
close $fdwjs
# puts $data
}

proc ::capPSpiceModelAppBase::ReadJs {} {
::capPSpiceModelAppBase::ReadOpjPath
set JsPath $::capPSpiceModelAppBase::jFilePath
if {[file exists $JsPath]==1} {
set fdjs [open $JsPath r]
set ::ModelAppUtils::JsData [read $fdjs]
close $fdjs
} else { 
set fdjs [open $JsPath a+]
# set NewData {{"Transformer": [{"Name": "MyTrModel", "Type": "ST","LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"100n","Rst":"1" }]}}
# set NewData $::capPSpiceModelAppBase::DefaultValJSON
puts $fdjs $::capPSpiceModelAppBase::DefaultValJSON
close $fdjs
set ::ModelAppUtils::JsData $::capPSpiceModelAppBase::DefaultValJSON }
return $::ModelAppUtils::JsData
}

proc ::capPSpiceModelAppBase::CreateAppsDir {} {
set OpjL [string trimright [string tolower [set Opj [GetActiveOpjName]]] ".opj"]
if {[file isdirectory $OpjL-PSpiceFiles\\PSpiceModelApps] ==0} {
DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Creating PSpice Modeling Apps Data Folder $OpjL-PSpiceFiles\\PSpiceModelApps"]
file mkdir $OpjL-PSpiceFiles\\PSpiceModelApps
}
}

proc ::capPSpiceModelAppBase::PlaceSym {type ModelName} {
# set lOlbPath [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir capPSpiceModelApp Transformer supportfiles Transformer.OLB]]
# set lOlbPath [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir Transformer supportfiles Transformer.OLB]]
set lOlbPath [correctUNCPath [file join $::capPSpiceModelAppBase::lRootDir $::capPSpiceModelAppBase::AppName supportfiles $::capPSpiceModelAppBase::AppName.OLB]]
set lMostRecentSchFrameID [DboTclHelper_sGetConstCharPtr [capGetMostRecentSchFrameID]]
ui::SchematicActivate $lMostRecentSchFrameID
UnSelectAll
set ::capPSpiceModelAppBase::ImplementationProp $ModelName
DboState_WriteToSessionLog [DboTclHelper_sMakeCString "Placing symbol instance for model $ModelName"]
PlaceNew $lOlbPath $type 0
RegisterAction "_cdnOrSchViewCmdComplete" "::capEventHandlerUtil::needsCallback1" "Ctrl+1" "::capEventHandlerUtil::enumerateDiffs" "Schematic"

}


proc ::capEventHandlerUtil::needsCallback1 { pCommandName } {
	
	set ret 1
	
	if {$pCommandName=="OnSize"} {
		set ret 0
	}
	
	if {$pCommandName=="OnSwapIn"} {
		set ret 0
	}
	
	if {$pCommandName=="OnMouseWheel"} {
		set ret 0
	}
	
	if {$pCommandName=="OnKeyDown"} {
		set ret 0
	}
	
	if {$pCommandName=="OnLButtonDown"} {
		set ret 0
	}
	
	if {$pCommandName=="OnRButtonDown"} {
		set ret 0
	}
	
	if {$pCommandName=="OnRButtonUp"} {
		set ret 0
	}
	
	if {$pCommandName=="OnScroll"} {
		set ret 0
	}
	
	if {$pCommandName=="OnActivateView"} {
		set ret 0
	}
	
	if {$pCommandName=="OnLButtonUp"} {
		set ret 1
	} else {
		set ret 0
	}
	return $ret
}

proc ::capEventHandlerUtil::enumerateDiffs { pCommandName } {  
UnregisterAction "_cdnOrSchViewCmdComplete"
EndPlace
set ::ModelAppUtils::mSelectedObject [GetSelectedObjects]
::capPSpiceModelAppBase::UpdateModel $::capPSpiceModelAppBase::ImplementationProp
DestroyWidget $::ModelAppUtils::WidgetId
}


# RegisterAction "PSpice_Modeling_Apps" "::ModelAppUtils::ModelAppEnabler" "" "::ModelAppUtils::ModelAppLauncher" "Schematic"
# RegisterAction "_Transformer" "::capCloseAllChildWindows::shouldProcess" "" "::capPSpiceModelAppBase::Transformer all all" ""

# RegisterAction "Edit PSpice Component" "::ModelAppUtils::ModelAppEnabler" "" "::ModelAppUtils::ModelAppLauncher" "Schematic"

