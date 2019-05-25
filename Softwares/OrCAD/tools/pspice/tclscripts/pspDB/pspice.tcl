#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspice.tcl
#            contains samples for running OrCAD PSpice Simulation, Modify Simulation profile
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl
package require OrLibJSON 16.6
package require PspCtrlTcl 16.6.0
package require orPspEng 16.6.0
package provide pspice 1.0

set JSON_NULL \0
set JSON_STRING \1
set JSON_NUMBER \2
set JSON_BOOL \3
set JSON_ARRAY \4
set JSON_NODE \5
set gNullObj {}

interp alias {} ? {} puts $errorInfo

namespace eval pspice {
	variable mSimInterface
	variable mISim
	variable mProfilePath
}

proc sleep {time} {
      after $time set end 1
      vwait end
}

proc ::pspice::openProfile {pProfilePath} {
	if {$pProfilePath == ""} {
		set pProfilePath {D:\CUSTOMERS\TCL\sim\example-PSpiceFiles\example\tran.sim}
	}
	set ::pspice::mProfilePath $pProfilePath
}

proc ::pspice::loadSim {iSim} {
	$iSim loadDesign
	
	set status 0
	$iSim getRunStatus status
	
	while { $status != $::SIM_ACTION_COMPLETE} {
	                #puts "Waiting for load to complete $status"
	                sleep 100
	                $iSim getRunStatus status
	}
	return $status
}

proc ::pspice::runSim {iSim} {
	$iSim run 
	
	set status 0
	$iSim getRunStatus status
	while { $status == $::SIM_RUNNING} {
	                #puts "Waiting for run to complete $status"
	                sleep 100
	                $iSim getRunStatus status
	}
	#puts $status
	if {$status == $::SIM_ACTION_COMPLETE} {
		puts "Simulation successful."
	} { ##	$status == $::SIM_NOTIFY_CNVRGFAIL
		puts "Simulation failure."
	}
	return $status
}

proc ::pspice::simulate {} {
	set lSimInterface [new_OrISimObj]
	$lSimInterface createOrISimObj $::pspice::mProfilePath
	set iSim [$lSimInterface getISim]
	$iSim setLicenseOption 0
	$iSim setLicenseType 1
	$iSim setSolver 0
	
	loadSim $iSim
	set status [runSim $iSim]
	
	$iSim terminate

	delete_OrISimObj $lSimInterface
	
	if {$status == $::SIM_ACTION_COMPLETE} {
		openDatFile
	}
}

proc ::pspice::openDatFile {} {
	##OpenDat {D:\CUSTOMERS\TCL\sim\example-PSpiceFiles\example\tran\tran.dat}
	set tempFile $::pspice::mProfilePath
	set ind [string last / $tempFile]
	if {$ind == -1} {
		set ind [string last \\ $tempFile]
	}

	set datFile [string range $::pspice::mProfilePath 0 $ind]
	set name [string range $tempFile [incr ind] end-4]
	set datFile ${datFile}/$name/${name}.dat
	OpenDat $datFile
}

proc ::pspice::simsettingsReadWriteJSON { } {
	if {$::pspice::mProfilePath == ""} {
		return
	}
	
	set ::pspice::mSimInterface [new_OrISimObj]
	$::pspice::mSimInterface createOrISimObj $::pspice::mProfilePath
	set ::pspice::iSim [$::pspice::mSimInterface getISim]
	set text {}
	$::pspice::iSim loadProfileToJSON $::pspice::mProfilePath text
			
#	puts "JSON Text Read is ...."
#	puts ""
#	puts $text
#	puts ""
#	puts ""
	$::pspice::iSim writeProfileFromJSON $::pspice::mProfilePath $text
	$::pspice::iSim loadProfileToJSON $::pspice::mProfilePath text
#	puts "JSON Text Re Read is...."
#	puts ""
#	puts $text
#	puts ""
#	puts ""
		  
       return $text
}



variable gIndent "-"
variable gLevel 1
variable gFindName ""
variable gVarValue ""
variable gVarType ""
variable gNode {}

proc processArray {pNode pProcessor} {
    set lSize [orjson_size $pNode]
    for {set i 0} {$i < $lSize} {incr i} {
        set lNode [orjson_at $pNode $i]
        processNode $lNode $pProcessor
    }
}

proc processNode {pNode pProcessor} {
    incr ::gLevel
    set lName [orjson_name $pNode]
    set lType [orjson_type $pNode]
    $pProcessor "PRE" $lName [getTypeString $lType] {}

    if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } { 
        set lSize [orjson_size $pNode]
        for {set i 0} {$i < $lSize} {incr i} {
            if { $lType == $::JSON_ARRAY || $lType == $::JSON_NODE } {
                set found [processNode [orjson_at $pNode $i] $pProcessor ]
                if {$found == 1} {
                	return $found
                }
            } 
        }
    } else {
        set found [$pProcessor "IN" $lName [getTypeString $lType] [getValue $pNode]]
        if {$found == 1} {
               	set ::gNode $pNode
        	return $found
        }
    }    
    $pProcessor "POST" $lName [getTypeString $lType] {}
    incr ::gLevel -1
    return found
}

proc getTypeString {pType} {
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

proc getValue {pNode} {
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

proc parseJSON { pInput processor } {
    #puts "in parseJSON"
    set ::jsonNode {}
    set ::jsonNode [orjson_parse $pInput]
    if { $::jsonNode == $::gNullObj || $::jsonNode == $::JSON_NULL} {
        puts "Error on parsing JSON $::jsonNode"
        return;
    }

    set found [processNode $::jsonNode $processor]
    if {$found == 1} {
    	return
    }

    #set jsonIter [orjson_begin $jsonNode]
    #JSONNODE node -this $jsonIter
    #while { $jsonIter != [orjson_end $jsonNode]} {
    #                             if {[orjson_type $jsonIter] == $JSON_NODE} {
    #                                             set jsonNode [parseJSON $jsonIter]
    #                             }
    #                             set nodeName [orjson_name $jsonIter]
    #}
    #
}

proc sampleProcessor {pCallType pName pType pValue} {
#    puts "[string repeat $::gIndent $::gLevel] $pCallType - Name: $pName, Type: $pType, Value: $pValue"
    if {$pCallType == "IN" &&  $pName == $::gFindName} {
    	#puts FOUND$pValue
    	set ::gVarValue $pValue
    	set ::gVarType $pType
        return 1
    } {
    	return 0
    }
}

proc ::pspice::setVal {name value} {
    set ::gFindName $name
    set ::gVarType ""
    set text [::pspice::simsettingsReadWriteJSON]
    parseJSON $text sampleProcessor
    
    if {$::gVarType == "string"} {
    	puts "Setting $name to $value"
    	orjson_set_a $::gNode $value
    }
    if {$::gVarType == "bool" || $::gVarType == "number"} {
    	puts "Setting $name to $value"
    	orjson_set_f $::gNode $value
    }
    
    set text [orjson_write $::jsonNode]
    $::pspice::iSim writeProfileFromJSON $::pspice::mProfilePath $text
    ##simulate $::pspice::mProfilePath 
}

proc ::pspice::getVal {name} {
    set ::gFindName $name
    set ::gVarType ""
    set ::gVarValue ""
    set text [::pspice::simsettingsReadWriteJSON]
    parseJSON $text sampleProcessor
    return $::gVarValue
}

proc ::pspice::setAutoConverge {} {
	::pspice::setVal autoconverge 1
	::pspice::setVal RELTOL 1
	::pspice::setVal ABSTOL 1
	::pspice::setVal VNTOL 1
}



#####################################################################################################

# Set license to start with 
##PSpiceSetLicenseBatchMode PSpiceAD

# Run simulation
##::pspice::openProfile {D:\CUSTOMERS\TCL\sim\example-PSpiceFiles\example\tran.sim}
##::pspice::simulate
## Dat file opens – it shows stopTime of 1us

# Set and get run time simulation parameters
##::pspice::getVal FTime
## 1000ns
##::pspice::setVal FTime 2000ns
##::pspice::getVal FTime
## 2000ns

# Run simulation, convergence failure happens, set auto converge, and resimulate 
##::pspice::openProfile {D:\CUSTOMERS\TCL\conv\converg3-PSpiceFiles\SCHEMATIC1\conv.sim}
##::pspice::simulate
##”Simulation Failure”
##::pspice::setAutoConverge
##::pspice::simulate

# Sim Settings JSON
##::pspice::simsettingsReadWriteJSON {D:\CUSTOMERS\TCL\sim\example-PSpiceFiles\example\tran.sim}