#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: ibisnetlist.tcl
#
#/////////////////////////////////////////////////////////////////////////////////

package ifneeded OrCommonTcl 1.0 [list load orCommonTcl.dll orCommonTcl]
package ifneeded PspCtrlTcl 16.6.0 [list load orpsp_wobj.dll PspCtrlTcl]
package ifneeded orPSpiceIBISParser 16.6.0 [list load orPSpiceIBISParser.dll orPSpiceIBISParser]
package ifneeded ibistopspice 1.0 [list source ibistopspice.tcl]
package ifneeded ibisnetlist 1.0 [list source ibisnetlist.tcl]

package require Tcl 8.4
package require Capture 16.6.0
package require OrCommonTcl
package require PspCtrlTcl 16.6.0

package require OrLibJSON 16.6
package require orPSpiceIBISParser 16.6.0

package provide ibisnetlist 16.6.0

namespace eval ::ibisnetlist {
#	namespace export checknUpdateSim
#	namespace export includeAppsLib
	variable lLibFound 0
	variable pSimInterface
	variable lIncLibPath
}

## Generate correct pspice libs and add to profile
proc ::ibisnetlist::run {} {
	set dml [getDml]
	genLib $dml
	set lib [string replace $dml end-3  end ".lib"]
	
	set lSimActive [pspGetActiveSimFile]
	set lPspfolder [pspGetProfileFolder $lSimActive]
	puts [file tail $lib]
	set filename [file tail $lib]
	file copy -force $filename $lPspfolder
	set profilelib $lPspfolder/$filename
	puts $profilelib
	includeAppsLib $profilelib
}

## Get DML File Path

proc ::ibisnetlist::getDml {} {
	set sysMgr [orSysObjectsManager_GetInstance ]
	
	set lDesign [GetActivePMDesign]
	set lNameCStr [DboTclHelper_sMakeCString ""]
	$lDesign GetName $lNameCStr
	set lDsn [DboTclHelper_sGetConstCharPtr $lNameCStr]

	set modelPath [  $sysMgr GetDmlFileForModel $lDsn EPCS64_ASDI ]
	set dml [ DboTclHelper_sGetConstCharPtr $modelPath ]
	puts $dml
	return $dml
}

## Convert DML to PSpice Lib
proc ::ibisnetlist::genLib {dml} {
	set initialized [info exists ibis]
	if {$initialized != 0} {
		delete_PIbisDMLParser $ibis
		unset ibis
	}
	set ibis [createIBISParser]
	$ibis setStimulusParams 8e-10 8e-10  10e-9 20e-9
	set out [$ibis getModelsForTCL $dml 0 1]
	$ibis generateLib "" 0 20 0 50 1 0
}

## Add lib to profile
#::ibisnetlist::includeAppsLib { libpath }

## Netlist correctly and simulate - Done in C++ code



set JSON_NULL \0
set JSON_STRING \1
set JSON_NUMBER \2
set JSON_BOOL \3
set JSON_ARRAY \4
set JSON_NODE \5
set gNullObj {}
set gIndent "-"
set gLevel 1


interp alias {} ? {} puts $errorInfo


proc ::ibisnetlist::processNode {pNode pProcessor} {
    incr ::gLevel
    set lName [orjson_name $pNode]
    set lType [orjson_type $pNode]

    $pProcessor "PRE" $lName [::ibisnetlist::getTypeString $lType] { }

    if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } { 
        set lSize [orjson_size $pNode]
        for {set i 0} {$i < $lSize} {incr i} {
            if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } {
                ::ibisnetlist::processNode [orjson_at $pNode $i] $pProcessor 
                set NodeType [::ibisnetlist::getTypeString $lType]
            } 
        }
    } else {
        $pProcessor "IN" $lName [::ibisnetlist::getTypeString $lType] [::ibisnetlist::getValue $pNode]
	set lLibName [::ibisnetlist::getValue $pNode]
#	string match -nocase "*pspicemodelapps_include.lib*" $libname
	if { [string match -nocase "*pspicemodelapps_include.lib*" $lLibName] } { 
		set ::ibisnetlist::lLibFound 1
		} 
    }    
    $pProcessor "POST" $lName [::ibisnetlist::getTypeString $lType] {}
    incr ::gLevel -1
}

proc ::ibisnetlist::updateNode {pNode pProcessor} {
    incr ::gLevel
    set lName [orjson_name $pNode]
    set lType [orjson_type $pNode]
#

	if { $lName== "LocalLibs" && $::ibisnetlist::lLibFound != 1} { 

		set ljsonObj [orjson_new $::JSON_STRING]	
#		set NEW "PSpiceModelApps_Include.lib"
#		set OpjL [string trimright [string tolower [set Opj [GetActiveOpjName]]] ".opj"]
#		set NEW	[concat $OpjL-PSpiceFiles\\PSpiceModelApps\\PSpiceModelApps_Include.lib ]
	        orjson_set_a $ljsonObj $::ibisnetlist::lIncLibPath
	        puts $::ibisnetlist::lIncLibPath
		orjson_push_back $pNode $ljsonObj
		set ::ibisnetlist::lLibFound 1
	}
#
    	$pProcessor "PRE" $lName [::ibisnetlist::getTypeString $lType] { }


    	if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } { 
	        set lSize [orjson_size $pNode]
	        for {set i 0} {$i < $lSize} {incr i} {
	            if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } {
	                updateNode [orjson_at $pNode $i] $pProcessor 
			set llName [orjson_name	[orjson_at $pNode $i]]
	
	            } 
		}
	} else {
        $pProcessor "IN" $lName [::ibisnetlist::getTypeString $lType] [::ibisnetlist::getValue $pNode]

    }    
    $pProcessor "POST" $lName [::ibisnetlist::getTypeString $lType] {}
    incr ::gLevel -1
}

proc ::ibisnetlist::getTypeString {pType} {
    set lRet {}

    switch $pType $::JSON_NULL {
        set lRet "NULL"
    } $::JSON_STRING {
        set lRet "string"
    } $::JSON_NUMBER {
        set lRet "number"
    } $::JSON_BOOL {
        set lRet "bool"
    } $::JSON_ARRAY {
        set lRet "array"
    } $::JSON_NODE {
        set lRet "object"
    }
    return $lRet
}

proc ::ibisnetlist::getValue {pNode} {
    set lValue {}
    set lType [orjson_type $pNode]

    switch $lType $::JSON_STRING {
        set lValue [orjson_as_string $pNode]
    } $::JSON_NUMBER {
        set lValue [orjson_as_int $pNode]
    } $::JSON_BOOL {
        set lValue [orjson_as_bool $pNode]
    }
    return $lValue
}

proc ::ibisnetlist::parseJSON { pInput processor } {
    set jsonNode [orjson_parse $pInput]
    if { $jsonNode == $::gNullObj || $jsonNode == $::JSON_NULL} {
        puts "Error on parsing JSON $jsonNode"
        return;
}

processNode $jsonNode $processor


}

proc ::ibisnetlist::modifyJSON { pInput processor } {
    set jsonNode [orjson_parse $pInput]
    if { $jsonNode == $::gNullObj || $jsonNode == $::JSON_NULL} {
        puts "Error on parsing JSON $jsonNode"
        return;
	}

	updateNode $jsonNode $processor
	return $jsonNode
 
}

proc ::ibisnetlist::Processor {pCallType pName pType pValue} {

#    puts "[string repeat $::gIndent $::gLevel] $pCallType - Name: $pName, Type: $pType, Value: $pValue"

}

proc ::ibisnetlist::checknUpdateSim {SimTextJS} {
    	::ibisnetlist::parseJSON  $SimTextJS ::ibisnetlist::Processor
	return $::ibisnetlist::lLibFound



}


proc ::ibisnetlist::init { } {
	set ::ibisnetlist::pSimInterface [new_OrISimObj]
}

proc ::ibisnetlist::createInterface { profilePath } {
	$::ibisnetlist::pSimInterface createOrISimObj $profilePath 
}

proc ::ibisnetlist::simsettingsReadJSON { profilePath } {
set iSim [$::ibisnetlist::pSimInterface getISim]

		set jsonText {}
                $iSim loadProfileToJSON $profilePath jsonText
		return $jsonText
                
}

proc ::ibisnetlist::includeAppsLib { libpath } {
set libFound 0
set ::ibisnetlist::lLibFound 0
set ::ibisnetlist::lIncLibPath $libpath
#puts $::ibisnetlist::lIncLibPath
::ibisnetlist::init
 set lSimActive [pspGetActiveSimFile]
# puts "Active sim profile $lSimActive"
if { $lSimActive != "" } {

::ibisnetlist::createInterface $lSimActive

set SimTextJS [::ibisnetlist::simsettingsReadJSON $lSimActive]
# puts " Simulation profile Text after read is "
# puts $SimTextJS
set libFound [::ibisnetlist::checknUpdateSim $SimTextJS]

#puts "Lib Status is $libFound"

    if { $libFound != 1} {
#     	puts $SimTextJS
	set updatedSimJS [::ibisnetlist::modifyJSON $SimTextJS ::ibisnetlist::Processor]
	set updatedSimTextJS [orjson_write $updatedSimJS] 

	set iSim [$::ibisnetlist::pSimInterface getISim]
	$iSim writeProfileFromJSON $lSimActive $updatedSimTextJS
#	puts "JSON String output"
	set updatedSimTextJS [orjson_write $updatedSimJS] 
#	puts $updatedSimTextJS
	delete_OrISimObj $::ibisnetlist::pSimInterface 
}

} else { puts "No Simulation profile defined. Library file can not be added" }

}

# ::ibisnetlist::includeAppsLib 

