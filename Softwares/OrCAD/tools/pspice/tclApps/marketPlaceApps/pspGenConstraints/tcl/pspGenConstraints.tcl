#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2012 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////
package require orPrmUtils
load orevalexpr.dll
package require orevalexpr 
package provide sdl 1.0

namespace eval ::sdl {
	set gScriptDir [file dirname [info script]]
	set gRootDir [file join $::sdl::gScriptDir ..]
	set gWidgetId 0
	set gSaveMode 0
	set gStrFullProjectPath ""
	set gAnnotateMinLineWidth true
	set gAnnotateMinSpacing true
	set gAnnotateVMax true
	set gAnnotateVRms true
	set gAnnotateIMax true
	set gAnnotateDIdt true
	set gAnnotateWAvg true
	set gAnnotateWRms true
	set gAnnotateWPeak true
}

proc ::sdl::registerActions {} {
	RegisterAction "_cdnPspSDL" "::sdl::EnableSDL" "" "::sdl::start" ""
	RegisterAction "_cdnPspSDLUpdate" "::sdl::EnableSDL" "" "::sdl:EnableSDL" ""
}

#proc _cdnPspSDL {} {
#	::sdl::open 
#}

proc ::sdl::EnableSDL {} {
	return true
}


proc ::sdl::start {} {
	set lModalId [orPrm::GetNextId]
	set ::sdl::gWidgetId $lModalId
	set res [correctUNCPath [file join $::sdl::gRootDir hybrid sdl.html]]
	set ::actualDialogId [orPrm::CreateModalDialog $lModalId $res "SPICE Driven Layout" 500 660 0]
}

proc ::sdl::getSimProfile {} {
	set lSimActive [pspGetActiveSimFile]
	set lProfileDisp [pspGetProfileDispNameForPath $lSimActive]
	return $lProfileDisp
}

proc ::sdl::setProps {props } {
	set mylist [split $props " "]
	set ::sdl::gAnnotateMinLineWidth [lindex $mylist 0]
	puts $::sdl::gAnnotateMinLineWidth
	set ::sdl::gAnnotateMinSpacing [lindex $mylist 1]
	set ::sdl::gAnnotateVMax [lindex $mylist 2]
	set ::sdl::gAnnotateVRms [lindex $mylist 3]
	set ::sdl::gAnnotateIMax [lindex $mylist 4]
	set ::sdl::gAnnotateDIdt [lindex $mylist 5]
	set ::sdl::gAnnotateWAvg [lindex $mylist 6]
	set ::sdl::gAnnotateWRms [lindex $mylist 7]
	set ::sdl::gAnnotateWPeak [lindex $mylist 8]
}

proc ::sdl::run { parameter } {
	set mylist [split $parameter " "]
	set profile [lindex $mylist 0]
	set unitsMil [lindex $mylist 1]
	set lConductorType [lindex $mylist 2]
	set lLayer [lindex $mylist 3]
	set lThickness [lindex $mylist 4]
	set lTempRise [lindex $mylist 5]
	set lMinWidth [lindex $mylist 6]
	#puts "$profile, unitsMil=$unitsMil, $lConductorType, $lLayer, $lThickness, $lTempRise, $lMinWidth"
	#pspTest
	set origPath [pwd]

	set path [pspGetActiveSimFile]
	if {$path == ""} {
		puts "Select a simulation profile."
		return 
	}
	set lProfileFolder [pspGetProfileFolder $path]	
	cd $lProfileFolder

	#set datFile tran.dat
	set datFileName [pspGetProfileNameForPath $path]
	set datFile ${datFileName}.dat

	set rslFile smoke.rsl

	set fileExists [file exists $datFile]
	if {$fileExists == 0} {
		puts "$datFile does not exist in $lProfileFolder"
		return
	}

	#set hier [exec cds_root psp_cmd]
	#load ${hier}/tools/pspice/orevalexpr.dll


	::sdl::pspGenerateLayoutConstraints $datFile $rslFile $unitsMil $lConductorType $lLayer $lThickness $lTempRise $lMinWidth
	#puts $pMessage	
	#return "Add"
	
	annotateProps
	
	set lProfileFolder [pspGetProfileFolder [pspGetActiveSimFile]]
	#OpenURL $lProfileFolder/report.html  "SDL"
	openHTML $lProfileFolder/report.html  "SPICE-driven Constraints Report"
	cd $origPath
	orPrm::DestroyWidget $::sdl::gWidgetId
}

proc ::sdl::cancel {} {
	orPrm::DestroyWidget $::sdl::gWidgetId
	unset $::sdl::gWidgetId
}

### Sample output:
### {
###	"Design": "tran.dat",
###	"Nets": {
###		"Net1": {
###			"IMax": "1",
###			"dI_dtMax": ".1",
###			"Connections": {
###				"R1.1": {
###					"IMax": "1",
###					"dI_dtMax": ".1"
###				},
###			}
###		}
###	},
###	"Instances": {
###		"V1": {
###			"WMax": "1.2"
###		}
###	},
###	"Nodes": {
###		"N1": {
###			"VMax": "3.3",
###			"dV_dtMax": ".12"
###		}
###	}
### }

### Data structures needed:
### Array of Nets : Key : BaseName Value : List of aliases/connections    arrayNets
### Array of IMax : Key : pin name (base/alias), value : IMax             arrayIMax
### Array of VMax : Key : Node Name, value : VMax                         arrayVMax
### Array of WMax : Key : Device Name, value : WMax                       arrayWMax
### Array of IrmsMax : Key : Pin Name, value: IrmsMax			  arrayIrmsMax
### Array of VrmsMax : Key : Node Name, value: VrmsMax			  arrayVrmsMax
### Array of di/dt|max : Key : Pin Name, value: di/dt|max		  arraydIdtMax
### Array of dv/dt|max : Key : Node Name, value: dv/dt|max		  arraydVdtMax
### Array of Vcoup|max i.e. max of difference between voltages of 2 nets  arrayVcoupMax

### Following constraints will be generated:
### PSP_MIN_LINE_WIDTH
### PSP_MIN_SPACING

### Also, the following data will be generated:
### HOT DEVICES LIST
### arrayWrmsSmoke, arrayWavgSmoke, arrayWPeakSmoke


proc ::sdl::pspGenerateLayoutConstraints {datFile rslFile pUnitsMil pConductorType lLayer lThickness lTempRise lMinWidth} {
	#puts "$datFile, $rslFile, $pConductorType, $lLayer, $lThickness, $lTempRise"

	orExprEval objFile
	objFile loadFile $datFile

	objFile getNumberofBlocks
	objFile setBlock 0
	objFile getDataNames 0
	objFile getHeaderList
	objFile getHeaderData "NumberofAnalogRows"
	set data [objFile getDataNames 0]
	#puts $data
	set list [split $data " "]
	
	global arrayVMax
	global arrayVrmsMax
	global arraydVdtMax
	global arrayIMax
	global arrayIrmsMax
	global arraydIdtMax
	
	array set allCurrentNodes {}
	#array set arrayNets {}
	array set arrayIMax {}
	array set arrayVMax {}
	array set arrayIrmsMax {}
	array set arrayVrmsMax {}
	array set arraydIdtMax {}
	array set arraydVdtMax {}

	pspCreateVoltageAlias $list 
	#[array get arrayNets ]
	
	pspCreateAllCurrentNodes $list [array get allCurrentNodes]
	
	pspCreatePowerData $list objFile
	
	foreach node [array names ::arrayNets] {
		set var "Max(V(${node}))"
		set value [objFile evaluate $var]
		set valueabs [expr abs($value)]
		set arrayVMax($node) $valueabs

		set var "Max(RMS(V(${node})))"
		set value [objFile evaluate $var]
		set valueabs [expr abs($value)]
		set arrayVrmsMax($node) $valueabs

		set var "Max(D(V(${node})))"
		set value [objFile evaluate $var]
		set valueabs [expr abs($value)]
		set arraydVdtMax($node) $valueabs
	}

	for { set ii 0 } { $ii < [array size ::allCurrentNodes] } { incr ii } {
		set current $::allCurrentNodes($ii)
		for {set jj 0 } {$jj < [llength $current]} {incr jj} {
			set currentItem [lindex $current $jj]
			
			set nodeName [pspGetNode $currentItem]
				
			set maxCurrent 0
			set maxrmsCurrent 0
			set maxdIdt 0
			for {set kk 0} {$kk < [llength $nodeName]} {incr kk} {
				set dataOfInterest [lindex $nodeName $kk]
				set var "Max(I(${dataOfInterest}))"
				set value [objFile evaluate $var]
				set valueabs [expr abs($value) ]
				set arrayIMax($dataOfInterest) $valueabs
				if {$valueabs > $maxCurrent} {
					set maxCurrent $valueabs
				}

				set var "Max(RMS(I(${dataOfInterest})))"
				set value [objFile evaluate $var]
				set valueabs [expr abs($value) ]
				set arrayIrmsMax($dataOfInterest) $valueabs
				if {$valueabs > $maxrmsCurrent} {
					set maxrmsCurrent $valueabs
				}

				set var "Max(D(I(${dataOfInterest})))"
				set value [objFile evaluate $var]
				set valueabs [expr abs($value) ]
				set arraydIdtMax($dataOfInterest) $valueabs
				if {$valueabs > $maxdIdt} {
					set maxdIdt $valueabs
				}
			}
			set arrayIMax($nodeName) $maxCurrent
			set arrayIrmsMax($nodeName) $maxrmsCurrent
			set arraydIdtMax($nodeName) $maxdIdt
		}
	}

	pspComputeNetCurrents
	
	setGlobalData
	pspGetVcoupMax
	pspComputeMinSpacing $pUnitsMil $pConductorType 
	pspComputeMinLineWidth $pUnitsMil $lLayer $lThickness $lTempRise $lMinWidth
	pspListHotDevices $rslFile
	
	pspCreateJSON [array get ::arrayNets] [array get arrayIMax] [array get arrayVMax] [array get arrayIrmsMax] [array get arrayVrmsMax] [array get arraydIdtMax] [array get arraydVdtMax]

	writeHtmlNodes [array get ::arrayMinLineWidth] [array get ::arrayVMax] [array get ::arrayVrmsMax] [array get ::arraydVdtMax]
	writeHtmlPins [array get ::arrayIMax] [array get ::arrayIrmsMax] [array get ::arraydIdtMax]
	writeHtmlInsts [array get ::arrayWPeakSmoke] [array get ::arrayWavgSmoke] [array get ::arrayWrmsSmoke]
	writeHtmlNetPairs [array get ::arrayMinSpacing] [array get ::arrayVcoupMax]
}


proc ::sdl::pspComputeNetCurrents {} {
	foreach net [array names ::arrayNets] {
		set aliases $::arrayNets($net)
		
		set imax 0;
		set irmsmax 0;	
		set didtmax 0;
		foreach alias $aliases {
			if {! [info exists ::arrayIMax($alias) ] } {
				continue
			}
	
			set value $::arrayIMax($alias)
			if {$value > $imax} {
				set imax $value
			}
	
			set value $::arrayIrmsMax($alias)
			if {$value > $irmsmax} {
				set irmsmax $value
			}
	
			set value $::arraydIdtMax($alias)
			if {$value > $didtmax} {
				set didtmax $value
			}
		}
		set ::arrayIMax($net) $imax
		set ::arrayIrmsMax($net) $irmsmax
		set ::arraydIdtMax($net) $didtmax
	}
}

proc ::sdl::pspGetVcoupMax {} {
	global arrayVcoupMax
	array set arrayVcoupMax {}
	foreach node1 [array names ::arrayNets] {
		foreach node2 [array names ::arrayNets] {
			if {$node1 == $node2} {
				set arrayVcoupMax($node1,$node2) 0
			} else {
				set var "Max(V(${node1}, ${node2}))"
				set value [objFile evaluate $var]
				set valueabs [expr abs($value)]
				set arrayVcoupMax($node1,$node2) $valueabs
			}
		}
	}
}

#Is input a Current Node?
proc ::sdl::pspIsCurrentData { data } {
	set starts [string first "I(" $data]
	if {$starts == 0} {
		set colon [string first ":" $data]
		if {$colon > 0} {
			return 1
		}
	}
	return 0
}

#get Node name after removing extraneous text like V() and I()
proc ::sdl::pspGetNode { data } {
	set newString [string replace $data 0 1 ""]
	set len [string length $newString]
	set newString2 [string replace $newString [expr $len-1] [expr $len-1] ""]
	return $newString2
}

#get Voltage Node Name if it is a voltage node else empty string
proc ::sdl::pspGetVoltageNode { data } {
	set starts [string first "V(" $data]
	if {$starts == 0} {
		return [pspGetNode $data]
	} else {
		return ""
	}
}

#get Power Device Name if it is a Power node else empty string
proc ::sdl::pspGetPowerNode { data } {
	set starts [string first "W(" $data]
	if {$starts == 0} {
		return [pspGetNode $data]
	} else {
		return ""
	}
}

## Power Nodes Parse : Create Max Device Power array
proc ::sdl::pspCreatePowerData {list objFile} {
	global arrayWMax
	array set arrayWMax {}

	foreach item $list {
		set itemdata [split $item ";"]
		
		for { set i 0 } { $i <= [llength $itemdata] } { incr i } {
			set dataOfInterest [lindex $itemdata $i]
				
			set Node [pspGetPowerNode $dataOfInterest]
			if {$Node != ""} {
				set var "Max(W(${Node}))"
				set value [$objFile evaluate $var]
				set valueabs [expr abs($value)]
				set arrayWMax($Node) $valueabs
			}
		}
	}
}

## Voltage Nodes Parse : Create voltage alias list
proc ::sdl::pspCreateVoltageAlias {list } {
	#listNets
	global arrayNets
	array set arrayNets {}
	set VoltageNodeFound 0
	set iNet 0
	set Nets [list]
	foreach item $list {
		set itemdata [split $item ";"]
	
		## Isolate Pins
		set VoltageNodeFound 0
	
		for { set i 0 } { $i <= [llength $itemdata] } { incr i } {
			set dataOfInterest [lindex $itemdata $i]
				
			set Node [pspGetVoltageNode $dataOfInterest]
			if {$Node != ""} {
				set VoltageNodeFound 1
				if {$i == 0} { ##master
					lappend Nets $Node
				} else {
					set xx [lindex $Nets $iNet]
					lappend xx $Node
					set Nets [lreplace $Nets $iNet $iNet $xx]
				}
			}
		}
	
		if {$VoltageNodeFound == 1} {
			incr iNet
		}
	}
	
	## Save mapping of nodes to pins
	## (Search for all pins connected to current nodes by looking into the voltage array)

	foreach mynet $Nets {
		for {set i 0} { $i < [llength $mynet] } {incr i} {
			set mynode [lindex $mynet $i]
			set colonExists [string first ":" $mynode]
			if { $colonExists == -1 } {
				set arrayNets($mynode) $mynet
				break
			}
		}
	}
}
##pspCreateVoltageAlias

proc ::sdl::pspCreateAllCurrentNodes {list listAllCurrentNodes} {
	global allCurrentNodes
	array set allCurrentNodes $listAllCurrentNodes
	set iCur 0
	foreach item $list {
		set itemdata [split $item ";"]
		## Isolate Pins
		set CurrentNodeFound 0
		
		set synonymCurrentNodes [list]
		#puts $itemdata
		for { set i 0 } { $i < [llength $itemdata] } { incr i } {
			set dataOfInterest [lindex $itemdata $i]
			if { [pspIsCurrentData $dataOfInterest] } {
				set CurrentNodeFound 1
				lappend synonymCurrentNodes $dataOfInterest
			}
		}
		if {$CurrentNodeFound == 1} {
			set allCurrentNodes($iCur) $synonymCurrentNodes
			incr iCur
		}
	}
}


proc ::sdl::pspCreateJSON {lNets lIMax lVMax lIrmsMax lVrmsMax ldIdtMax ldVdtMax} {
#Output example:
#"Design":"tran.dat","Nets":{"Net1":{"IMax":"1","dI_dtMax":".1","Connections":{"R1.1":{"IMax":"1","dI_dtMax":".1"},"Q1.1":{"IMax":".8"}}}},"Instances":{"V1":{"WMax":"1.2"}},"Nodes":{"N1":{"VMax":"3.3","dV_dtMax":".12"}}	
		
	#set fp [open "capProp.json" r]
	#set file_data [read $fp]
	#close $fp
	#set json [orjson_parse $file_data]
	#puts $json
	#set json_list [orjson_write $json]
	
	#puts $json_list


	set json_list "\{\"Design\":\"tran.dat\",\n"
	
	set json_list $json_list\"Nets\":\{
			
	array set lArrayNets $lNets
	array set lArrayIMax $lIMax
	array set lArrayVMax $lVMax
	array set lArrayIrmsMax $lIrmsMax
	array set lArrayVrmsMax $lVrmsMax
	array set lArraydIdtMax $ldIdtMax
	array set lArraydVdtMax $ldVdtMax
	
	foreach net [array names lArrayNets] {
		set aliases $lArrayNets($net)
		
		set json_list $json_list\"$net\":\{
			
		set json_list $json_list\"Connections\":\{
		foreach alias $aliases {
			if {! [info exists lArrayIMax($alias) ] || $net == $alias} {
				continue
			}
			set json_list $json_list\"$alias\":\{

			set value $lArrayIMax($alias)
			set json_list "$json_list\"IMax\": \"$value\","

			set value $lArrayIrmsMax($alias)
			set json_list "$json_list\"IrmsMax\": \"$value\","
			
			set value $lArraydIdtMax($alias)
			set json_list "$json_list\"dIdtMax\": \"$value\""
			
			set json_list $json_list\},
		}

		#For Connections
		set imax $lArrayIMax($net)
		set irmsmax $lArrayIrmsMax($net)
		set didtmax $lArraydIdtMax($net)
		
		set json_list $json_list\},
		set json_list "$json_list\"IMax\": \"$imax\","
		set json_list "$json_list\"IrmsMax\": \"$irmsmax\","
		set json_list "$json_list\"dIdtMax\": \"$didtmax\","
		set json_list $json_list\},			

	}		

	#For Nets
	set json_list $json_list\},
	
	#For Node-voltages
	set json_list "$json_list\"Nodes\": \{"
	foreach node [array names lArrayVMax] {
		set json_list "$json_list\"$node\": \{"

		set value $lArrayVMax($node)
		set json_list "$json_list\"VMax\": \"$value\","

		set value $lArrayVrmsMax($node)
		set json_list "$json_list\"VrmsMax\": \"$value\","

		set value $lArraydVdtMax($node)
		set json_list "$json_list\"dVdtMax\": \"$value\","

		set value $::arrayMinLineWidth($node)
		set json_list "$json_list\"PSP_MIN_LINE_WIDTH\": \"$value\","

		set json_list $json_list\},			
	}
	set json_list $json_list\},

	#For Device-Power
	set json_list "$json_list\"Instances\": \{"
	
#Overriding the following by smoke data - use this if smoke output is not available
#	foreach node [array names ::arrayWMax] {
#		set value $::arrayWMax($node)
#		set json_list "$json_list\"$node\": \{"
#		set json_list "$json_list\"WMax\": \"$value\","
#		set json_list $json_list\},			
#	}


	foreach node [array names ::arrayWrmsSmoke] {
		set json_list "$json_list\"$node\": \{"
		set value $::arrayWrmsSmoke($node)
		set json_list "$json_list\"Wrms\": \"$value\","
		set value $::arrayWavgSmoke($node)
		set json_list "$json_list\"Wavg\": \"$value\","
		set value $::arrayWPeakSmoke($node)
		set json_list "$json_list\"WPeak\": \"$value\","
		set json_list $json_list\},			
	}

	set json_list $json_list\},			
	
	
	# For coupled voltages
	set json_list "$json_list\"Node1,Node2\": \{"
	foreach node [array names ::arrayVcoupMax] {
		set json_list "$json_list\"$node\": \{"
		set value $::arrayVcoupMax($node)
		set json_list "$json_list\"VcoupMax\": \"$value\","
		set value $::arrayMinSpacing($node)
		set json_list "$json_list\"PSP_MIN_SPACING\": \"$value\","
		set json_list $json_list\},			
	}
	set json_list $json_list\},			

	#For top-level
	set json_list $json_list\}
	#puts $json_list
	
	set jsonFile [open "sdl.json" w]
	set json [orjson_parse $json_list]
	set json_list [orjson_write_formatted $json]
	puts $jsonFile $json_list
	close $jsonFile
}


proc ::sdl::pspComputeMinSpacing {pUnitsMil lConductorType } {
	global arrayMinSpacing 
	#global arrayMinSpacingIPCInternal
	## Key: Node1,Node2  Value: Spacing in mils
	## UI Input: mil / mm
	## UI Input: Conductor type
	#set lConductorType "Internal"
	
	
	#set lName arrayMinSpacingIPC$lConductorType
	#puts $lName

	set arrayKey 0
	foreach node [array names ::arrayVcoupMax] {
		set value $::arrayVcoupMax($node)
		if { [expr $value < 15] } {
			set arrayKey 15
		} elseif { [expr $value >= 15 && $value < 30] } {
			set arrayKey 30
		} elseif { [expr $value >= 30 && $value < 50] } {
			set arrayKey 50
		} elseif { [expr $value >= 50 && $value < 100] } {
			set arrayKey 100
		} elseif { [expr $value >= 100 && $value < 150] } {
			set arrayKey 150
		} elseif { [expr $value >= 150 && $value < 170] } {
			set arrayKey 170
		} elseif { [expr $value >= 170 && $value < 250] } {
			set arrayKey 250
		} elseif { [expr $value >= 250 && $value < 300] } {
			set arrayKey 300
		} elseif { [expr $value >= 300 && $value < 500] } {
			set arrayKey 500
		} elseif { [expr $value >= 500 && $value < 1000] } {
			set arrayKey 1000
		} elseif { [expr $value >= 1000 && $value < 2000] } {
			set arrayKey 2000
		} elseif { [expr $value >= 2000 && $value < 3000] } {
			set arrayKey 3000
		} elseif { [expr $value >= 3000 && $value < 4000] } {
			set arrayKey 4000
		} elseif { [expr $value >= 4000 && $value < 5000] } {
			set arrayKey 5000
		} 

		set value 0
		if {! [string compare $lConductorType Internal] } {
			set value $::arrayMinSpacingIPCInternal($arrayKey)
		} elseif { ! [string compare $lConductorType ExtUncoat] } {
			set value $::arrayMinSpacingIPCExtUncoat($arrayKey)
		} elseif { ! [string compare $lConductorType ExtUncoatLarge] } {
			set value $::arrayMinSpacingIPCExtUncoatLarge($arrayKey)
		} elseif { ! [string compare $lConductorType ExtCoat] } {
			set value $::arrayMinSpacingIPCExtCoat($arrayKey)
		} elseif { ! [string compare $lConductorType ExtConformal] } {
			set value $::arrayMinSpacingIPCExtConformal($arrayKey)
		} elseif { ! [string compare $lConductorType ExtLeadsUncoat] } {
			set value $::arrayMinSpacingIPCExtLeadsUncoat($arrayKey)
		} elseif { ! [string compare $lConductorType ExtLeadsCoat] } {
			set value $::arrayMinSpacingIPCExtLeadsCoat($arrayKey)
		} else {
			set value NotDefined
		}
		
		if {$pUnitsMil == false && $value != "NotDefined"} {
			set value [expr $val * .0254]
		}
		set arrayMinSpacing($node) $value
	}
}

proc ::sdl::pspComputeMinLineWidth {pUnitsMil lLayer lThickness lTempRise pMinMultiple} {
	global arrayMinLineWidth ## Key: Node  Value: Min Width in mils
	## UI Input: mil / mm
	## UI Input: Layer type
	## UI Input: Max Temperature change
	## UI Input: Thickness (in oz)
	## UI Input: Minimum Multiple
	#set lLayer "Internal"
	#set lThickness 1
	#set lTempRise 20
	
	## Hardcoded Data based on IPC-2221A :
	array set arrayMinLineWidth {}
	
	## Area is in mil^2, Current is in Amps, Temperature is in degrees Celsius, Width is in mils
	set k 0
	set b 0
	set c 0
	
	if {! [string compare lLayer Internal]} {
		set k .024
		set b .44
		set c .725
	} else { 
		##external
		set k .048
		set b .44
		set c .725
	}
	
	foreach node [array names ::arrayVMax] {
		set Ival $::arrayIMax($node)
		set lArea [expr $Ival/pow(($k * pow($lTempRise, $b)),1/$c) ] 
		set lWidth [expr $lArea / ($lThickness * 1.378) ]
		
		if {$pUnitsMil == false} {
			set lWidth [expr $lWidth * .0254]
		}
		
		set lNormalizedWidthFactor [expr int($lWidth / $pMinMultiple)]
		set lNormalizedWidth [expr $lNormalizedWidthFactor * $pMinMultiple]
		set diff [expr $lWidth - $lNormalizedWidth]
		if {$diff > 0} {
			set lNormalizedWidth [expr $lNormalizedWidth + $pMinMultiple ]
		}
		set arrayMinLineWidth($node) $lNormalizedWidth
	}
	
}

proc ::sdl::pspListHotDevices {file} {
	set len [string length $file]
	if {$len == 0} {
		return
	}
	set fileExists [file exists $file]
	if {$fileExists == 0} {
		return
	}

	set fp [open $file r]
	set data [read $fp]
	close $fp
	
	global arrayWrmsSmoke
	global arrayWavgSmoke
	global arrayWPeakSmoke
	
	array set arrayWrmsSmoke {}
	array set arrayWavgSmoke {}
	array set arrayWPeakSmoke {}

	set dataLines [split $data "\n"]
	
	foreach line $dataLines {
		set i 0
		set component ""
		set PDMFound 0
		
		set fields [split $line]
		foreach field $fields {
			if {0 == [llength $field]} {
				continue
			}
			#puts $field
			if {$i == 0} {
				set component $field
			}
			if {$i == 1} {
				if {0 == [string compare $field PDM]} {
					set PDMFound 1
				}
			}
			if {$i == 4 && $PDMFound == 1} {
				set arrayWrmsSmoke($component) $field
			}
			if {$i == 8 && $PDMFound == 1} {
				set arrayWavgSmoke($component) $field
			}
			if {$i == 12 && $PDMFound == 1} {
				set arrayWPeakSmoke($component) $field
			}
			incr i
		}
	}
#::csv::split ? -alternate ? line {sepChar ,} {delChar "} 
}

proc ::sdl::setGlobalData {} {
	## Hardcoded Data based on IPC-2221A :
	global	arrayMinSpacing
	global arrayMinSpacingIPCInternal
	global arrayMinSpacingIPCExtUncoat
	global arrayMinSpacingIPCExtUncoatLarge
	global arrayMinSpacingIPCExtCoat 
	global arrayMinSpacingIPCExtConformal
	global arrayMinSpacingIPCExtLeadsUncoat
	global arrayMinSpacingIPCExtLeadsCoat

	array set arrayMinSpacing {}
	array set arrayMinSpacingIPCInternal {}
	array set arrayMinSpacingIPCExtUncoat {}
	array set arrayMinSpacingIPCExtUncoatLarge {}
	array set arrayMinSpacingIPCExtCoat {}
	array set arrayMinSpacingIPCExtConformal {}
	array set arrayMinSpacingIPCExtLeadsUncoat {}
	array set arrayMinSpacingIPCExtLeadsCoat {}
	
	set arrayMinSpacingIPCInternal(15) 2
	set arrayMinSpacingIPCInternal(30) 2
	set arrayMinSpacingIPCInternal(50) 4
	set arrayMinSpacingIPCInternal(100) 4
	set arrayMinSpacingIPCInternal(150) 8
	set arrayMinSpacingIPCInternal(170) 8
	set arrayMinSpacingIPCInternal(250) 8
	set arrayMinSpacingIPCInternal(300) 8
	set arrayMinSpacingIPCInternal(500) 10
	set arrayMinSpacingIPCInternal(1000) 60
	set arrayMinSpacingIPCInternal(2000) 158
	set arrayMinSpacingIPCInternal(3000) 256
	set arrayMinSpacingIPCInternal(4000) 355
	set arrayMinSpacingIPCInternal(5000) 453
	
	set arrayMinSpacingIPCExtUncoat(15) 4
	set arrayMinSpacingIPCExtUncoat(30) 4
	set arrayMinSpacingIPCExtUncoat(50) 24
	set arrayMinSpacingIPCExtUncoat(100) 60
	set arrayMinSpacingIPCExtUncoat(150) 126
	set arrayMinSpacingIPCExtUncoat(170) 126
	set arrayMinSpacingIPCExtUncoat(250) 252
	set arrayMinSpacingIPCExtUncoat(300) 492
	set arrayMinSpacingIPCExtUncoat(500) 492
	set arrayMinSpacingIPCExtUncoat(1000) 984
	set arrayMinSpacingIPCExtUncoat(2000) 1970
	set arrayMinSpacingIPCExtUncoat(3000) 2950
	set arrayMinSpacingIPCExtUncoat(4000) 3940
	set arrayMinSpacingIPCExtUncoat(5000) 4920
	
	set arrayMinSpacingIPCExtUncoatLarge(15) 4
	set arrayMinSpacingIPCExtUncoatLarge(30) 4
	set arrayMinSpacingIPCExtUncoatLarge(50) 24
	set arrayMinSpacingIPCExtUncoatLarge(100) 60
	set arrayMinSpacingIPCExtUncoatLarge(150) 126
	set arrayMinSpacingIPCExtUncoatLarge(170) 126
	set arrayMinSpacingIPCExtUncoatLarge(250) 252
	set arrayMinSpacingIPCExtUncoatLarge(300) 492
	set arrayMinSpacingIPCExtUncoatLarge(500) 492
	set arrayMinSpacingIPCExtUncoatLarge(1000) 984
	set arrayMinSpacingIPCExtUncoatLarge(2000) 1970
	set arrayMinSpacingIPCExtUncoatLarge(3000) 2950
	set arrayMinSpacingIPCExtUncoatLarge(4000) 3940
	set arrayMinSpacingIPCExtUncoatLarge(5000) 4920
	
	set arrayMinSpacingIPCExtCoat(15) 2
	set arrayMinSpacingIPCExtCoat(30) 2
	set arrayMinSpacingIPCExtCoat(50) 6
	set arrayMinSpacingIPCExtCoat(100) 6
	set arrayMinSpacingIPCExtCoat(150) 16
	set arrayMinSpacingIPCExtCoat(170) 16
	set arrayMinSpacingIPCExtCoat(250) 16
	set arrayMinSpacingIPCExtCoat(300) 16
	set arrayMinSpacingIPCExtCoat(500) 32
	set arrayMinSpacingIPCExtCoat(1000) 92
	set arrayMinSpacingIPCExtCoat(2000) 212
	set arrayMinSpacingIPCExtCoat(3000) 332
	set arrayMinSpacingIPCExtCoat(4000) 452
	set arrayMinSpacingIPCExtCoat(5000) 572
	
	set arrayMinSpacingIPCExtConformal(15) 6
	set arrayMinSpacingIPCExtConformal(30) 6
	set arrayMinSpacingIPCExtConformal(50) 6
	set arrayMinSpacingIPCExtConformal(100) 6
	set arrayMinSpacingIPCExtConformal(150) 16
	set arrayMinSpacingIPCExtConformal(170) 16
	set arrayMinSpacingIPCExtConformal(250) 16
	set arrayMinSpacingIPCExtConformal(300) 16
	set arrayMinSpacingIPCExtConformal(500) 32
	set arrayMinSpacingIPCExtConformal(1000) 92
	set arrayMinSpacingIPCExtConformal(2000) 212
	set arrayMinSpacingIPCExtConformal(3000) 332
	set arrayMinSpacingIPCExtConformal(4000) 452
	set arrayMinSpacingIPCExtConformal(5000) 572
	
	set arrayMinSpacingIPCExtLeadsUncoat(15) 6
	set arrayMinSpacingIPCExtLeadsUncoat(30) 10
	set arrayMinSpacingIPCExtLeadsUncoat(50) 16
	set arrayMinSpacingIPCExtLeadsUncoat(100) 20
	set arrayMinSpacingIPCExtLeadsUncoat(150) 32
	set arrayMinSpacingIPCExtLeadsUncoat(170) 32
	set arrayMinSpacingIPCExtLeadsUncoat(250) 32
	set arrayMinSpacingIPCExtLeadsUncoat(300) 32
	set arrayMinSpacingIPCExtLeadsUncoat(500) 60
	set arrayMinSpacingIPCExtLeadsUncoat(1000) 120
	set arrayMinSpacingIPCExtLeadsUncoat(2000) 240
	set arrayMinSpacingIPCExtLeadsUncoat(3000) 360
	set arrayMinSpacingIPCExtLeadsUncoat(4000) 480
	set arrayMinSpacingIPCExtLeadsUncoat(5000) 600
	
	set arrayMinSpacingIPCExtLeadsCoat(15) 6
	set arrayMinSpacingIPCExtLeadsCoat(30) 6
	set arrayMinSpacingIPCExtLeadsCoat(50) 6
	set arrayMinSpacingIPCExtLeadsCoat(100) 6
	set arrayMinSpacingIPCExtLeadsCoat(150) 16
	set arrayMinSpacingIPCExtLeadsCoat(170) 16
	set arrayMinSpacingIPCExtLeadsCoat(250) 16
	set arrayMinSpacingIPCExtLeadsCoat(300) 32
	set arrayMinSpacingIPCExtLeadsCoat(500) 32
	set arrayMinSpacingIPCExtLeadsCoat(1000) 92
	set arrayMinSpacingIPCExtLeadsCoat(2000) 212
	set arrayMinSpacingIPCExtLeadsCoat(3000) 332
	set arrayMinSpacingIPCExtLeadsCoat(4000) 452
	set arrayMinSpacingIPCExtLeadsCoat(5000) 572
}


proc ::sdl::pspTest {} {
	set datFile tran.dat
	set rslFile smoke.rsl
	#set rslFile ""
	set lConductorType "Internal"
	set lLayer "Internal"
	set lThickness 1	
	set lTempRise 20
	catch {	pspGenerateLayoutConstraints $datFile $rslFile $lConductorType $lLayer $lThickness $lTempRise}

#	puts $::errorInfo
}
## Trace width
## Trace spacing - depends on di/dt, v1-v2
## Compute vmax, vmin - compute real v1-v2 only for worst cases
## http://circuitcalculator.com/wordpress/2006/01/31/pcb-trace-width-calculator/
## http://www.smpspowersupply.com/ipc2221pcbclearance.html
## http://www.desmith.net/NMdS/Electronics/TraceWidth.html


proc ::sdl::writeHtmlNodes {listMinLineWidth listVMax listVrmsMax listdVdtMax} {
	set myhtml "<h1>Constraints generated from Simulation Data</h1>"

	set myhtml "$myhtml <TABLE border=\"1\""
	set myhtml "$myhtml          summary=\"Constraints data generated from simulation outputs\">"
	set myhtml "$myhtml <CAPTION align=\"left\">\"Net-based constraints\"</CAPTION>"
	
	set myhtml "$myhtml <TR> <TH>\"Node Name\"</TH>  <TH>\"PSP_MIN_LINE_WIDTH\"</TH>  <TH>\"VMax\"</TH> <TH>\"VrmsMax\"</TH> <TH>\"dV/dt(Max)\"</TH>" 
	for {set jj 0 } {$jj < [llength $listMinLineWidth]} {incr jj} {
		set myhtml "$myhtml <TR>"
		set item [lindex $listVMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		incr jj
		set item [lindex $listMinLineWidth $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listVMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listVrmsMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listdVdtMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
	}
	
	set myhtml "$myhtml</TABLE>"
	
	set htmlreport [open "report.html" w]
	puts $htmlreport $myhtml
	close $htmlreport

}

proc ::sdl::writeHtmlPins {listIMax listIrmsMax listdIdtMax} {

	set myhtml "<p>     </p>"
	set myhtml "$myhtml <TABLE border=\"1\""
	#set myhtml "$myhtml          summary=\"Constraints data generated from simulation outputs\">"
	#set myhtml "$myhtml <CAPTION align=\"left\">\"Constraints generated from Simulation Data\"</CAPTION>"
	set myhtml "$myhtml <CAPTION>\"Pin-based constraints\"</CAPTION>"
	
	set myhtml "$myhtml <TR> <TH>\"Pin Name\"</TH>  <TH>\"IMax\"</TH> <TH>\"IrmsMax\"</TH> <TH>\"dI/dt(Max)\"</TH>" 
	for {set jj 0 } {$jj < [llength $listIMax]} {incr jj} {
		set item [lindex $listIMax $jj]
		set pinFound [string first ":" $item]
		if {$pinFound == -1} {
			continue
		}
		
		
		set myhtml "$myhtml <TR>"
		set myhtml "$myhtml <TH>$item</TH>"
		incr jj
		set item [lindex $listIMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listIrmsMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listdIdtMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
	}
	
	set myhtml "$myhtml</TABLE>"
	
	set html [open "report.html" a]
	puts $html $myhtml
	close $html

}

proc ::sdl::writeHtmlInsts {listWPeak listWavg listWrmsMax} {
	set myhtml "<p>     </p>"
	set myhtml "$myhtml <TABLE border=\"1\""
	set myhtml "$myhtml <CAPTION>\"Instance-based constraints\"</CAPTION>"
	
	set myhtml "$myhtml <TR> <TH>\"Instance Name\"</TH>  <TH>\"WPeak\"</TH> <TH>\"Wavg\"</TH> <TH>\"WrmsMax\"</TH>" 
	for {set jj 0 } {$jj < [llength $listWPeak]} {incr jj} {
		set item [lindex $listWPeak $jj]		
		
		set myhtml "$myhtml <TR>"
		set myhtml "$myhtml <TH>$item</TH>"
		incr jj
		set item [lindex $listWPeak $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listWavg $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listWrmsMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
	}
	
	set myhtml "$myhtml</TABLE>"
	
	set html [open "report.html" a]
	puts $html $myhtml
	close $html
}

proc ::sdl::writeHtmlNetPairs {listMinSpacing listVcoupMax} {
	set myhtml "<p>     </p>"
	set myhtml "$myhtml <TABLE border=\"1\""
	set myhtml "$myhtml <CAPTION align=\"left\">\"Constraints for coupled nets\"</CAPTION>"
	
	set myhtml "$myhtml <TR> <TH>\"Net1\"</TH>  <TH>\"Net2\"</TH>  <TH>\"PSP_MIN_SPACING\"</TH> <TH>\"VCoupMax\"</TH>" 
	for {set jj 0 } {$jj < [llength $listMinSpacing]} {incr jj} {
		set item [lindex $listMinSpacing $jj]		
		set comma [string first "," $item]
		set first [string range $item 0 [expr $comma-1] ]
		set second [string range $item [incr comma] end]
		set same [string compare $first $second]
		if {$same == 0} {
			incr jj
			continue
		}
		
		set myhtml "$myhtml <TR>"
		set myhtml "$myhtml <TH>$first</TH>"
		set myhtml "$myhtml <TH>$second</TH>"
		incr jj
		set item [lindex $listMinSpacing $jj]
		set myhtml "$myhtml <TH>$item</TH>"
		set item [lindex $listVcoupMax $jj]
		set myhtml "$myhtml <TH>$item</TH>"
	}
	
	set myhtml "$myhtml</TABLE>"
	
	set html [open "report.html" a]
	puts $html $myhtml
	close $html
}

#proc ::sdl::annotateProps {} {
#	set pwd [pwd]
#	cd ../../..
#	set newpwd [pwd]

#	set propsFile [open "netprops.imp" w]	
#	set props "\"DESIGN\"		\"$newpwd\\BPF.DSN"
#	set props "$props \"HEADER\"	\"ID\"	\"PSP_MIN_LINE_WIDTH\"
	
#	menu "Tools::Import Properties" | FileDialog  "OK" "netprops.imp" 1
	
#	cd $pwd
#}

proc ::sdl::annotateProps {} {
	set pwd [pwd]
	cd ../../..
	set newpwd [pwd]

	#set netPropsFileName "netprops.exp"
	#set propsFile [open netPropsFileName w]	
	#set props "\"DESIGN\"		\"$newpwd\\BPF.DSN"
	#set props "$props \"HEADER\"	\"ID\"	\"MIN_LINE_WIDTH\""
	
	if {$::sdl::gAnnotateMinLineWidth == true} {
		annotateNets "PSP_MIN_LINE_WIDTH" [array get ::arrayMinLineWidth] 
	}
	
	if {$::sdl::gAnnotateVMax == true} {
		annotateNets "PSP_VMAX" [array get ::arrayVMax]
	}
	
	if {$::sdl::gAnnotateVRms == true} {
		annotateNets "PSP_VRMSMAX" [array get ::arrayVrmsMax]
	}
	##annotateNets "PSP_dVdtMax" [array get ::arraydVdtMax] ## Not needed right now
	
	if {$::sdl::gAnnotateDIdt == true} {
		annotatePins "PSP_dIdtMAX" [array get ::arraydIdtMax]
	}

	
#	selectRootDesign
#	menu "Tools::Import Properties" | FileDialog  "OK" "brfnets.exp" 1
	
	cd $pwd
}

proc sdl::annotateNets { pProp pList } {
	array set lArrayProps $pList
	set lStatus [DboState]
	set lNullObj NULL
	set lDesign [GetActivePMDesign]
	set lFlatNetsIter [$lDesign NewFlatNetsIter $lStatus]
	#get the first flat net of design 
	set lFlatNet [$lFlatNetsIter NextFlatNet $lStatus]
	set lPropName [DboTclHelper_sMakeCString $pProp]
	while {$lFlatNet!=$lNullObj} { 
		#store all flat net in a List
		set lNetName [DboTclHelper_sMakeCString]
		$lFlatNet GetName $lNetName 
		set lNetNameChar [DboTclHelper_sGetConstCharPtr $lNetName]
		foreach node [array names lArrayProps] {
			
			if { [string compare -nocase $node $lNetNameChar] == 0} {
				set lValue $lArrayProps($node)
				set lPropValue [DboTclHelper_sMakeCString $lValue]
				$lFlatNet SetEffectivePropStringValue $lPropName $lPropValue 
			}
		}
		set lFlatNet [$lFlatNetsIter NextFlatNet $lStatus] 
	}
}

proc sdl::annotatePins { pProp pList } {
	array set lArrayProps $pList
	set lStatus [DboState]
	set lNullObj NULL
	set lDesign [GetActivePMDesign]
	set  lPartsIter [$lDesign NewPartsIter $lStatus]

	set lPart [$lPartsIter NextPart $lStatus]
	set lPropName [DboTclHelper_sMakeCString $pProp]
	set lPartName [DboTclHelper_sMakeCString]
	set lPinName [DboTclHelper_sMakeCString]
	set lRefDes ""

	set lSchematicIter [$lDesign NewViewsIter $lStatus $::IterDefs_SCHEMATICS]
	set lView [$lSchematicIter NextView $lStatus] 
	while { $lView != $lNullObj} {
		set lSchematic [DboViewToDboSchematic $lView]
		set lPagesIter [$lSchematic NewPagesIter $lStatus] 
		set lPage [$lPagesIter NextPage $lStatus]
		while {$lPage!=$lNullObj} { 
			set lPartInstsIter [$lPage NewPartInstsIter $lStatus] 
			set lInst [$lPartInstsIter NextPartInst $lStatus] 
			while {$lInst!=$lNullObj} { 
				set lRefDes ""
				set lPlacedInst [DboPartInstToDboPlacedInst $lInst]
	 			if {$lPlacedInst != $lNullObj} { 
					$lPlacedInst GetName $lPartName 
					set lPartNameChar [DboTclHelper_sGetConstCharPtr $lPartName]	
					#puts "PART = $lPartNameChar"
					set lPropsIter [$lInst NewEffectivePropsIter $lStatus]
					set lPrpName [DboTclHelper_sMakeCString]
					set lPrpValue [DboTclHelper_sMakeCString] 
					set lPrpType [DboTclHelper_sMakeDboValueType] 
					set lEditable [DboTclHelper_sMakeInt] 
					set lStatus [$lPropsIter NextEffectiveProp $lPrpName $lPrpValue $lPrpType $lEditable] 
					while {[$lStatus OK] == 1} { 
						set lPropNameChar [DboTclHelper_sGetConstCharPtr  $lPrpName]
						if {$lPropNameChar == "Part Reference" } {
							set lRefDes [DboTclHelper_sGetConstCharPtr  $lPrpValue]				
						}
						set lStatus [$lPropsIter NextEffectiveProp $lPrpName $lPrpValue $lPrpType $lEditable] 
					} 
					delete_DboEffectivePropsIter $lPropsIter
					
					#puts "REFDES = $lRefDes"
	 
	 				set lIter [$lInst NewPinsIter $lStatus]
	 				set lPin [$lIter NextPin $lStatus]
	 				while {$lPin !=$lNullObj } {
						$lPin GetName $lPinName 
						set lPinNameChar [DboTclHelper_sGetConstCharPtr $lPinName]	
						#puts "PIN = $lPinNameChar"
	 					 					
						set lPropsIter [$lPin NewEffectivePropsIter $lStatus]
						set lStatus [$lPropsIter NextEffectiveProp $lPrpName $lPrpValue $lPrpType $lEditable] 
						while {[$lStatus OK] == 1} { 
							set lPropNameChar [DboTclHelper_sGetConstCharPtr  $lPrpName]
							if {$lPropNameChar == "Name" } {
								set lMyPinName [DboTclHelper_sGetConstCharPtr  $lPrpValue]				


								foreach node [array names lArrayProps] {
									if { [string compare -nocase $node ${lRefDes}:${lMyPinName}] == 0} {
										set lValue $lArrayProps($node)
										set lPropValue [DboTclHelper_sMakeCString $lValue]
										$lPin SetEffectivePropStringValue $lPropName $lPropValue 
										#puts "Setting $lValue"
									}
								}
								
							}
							set lStatus [$lPropsIter NextEffectiveProp $lPrpName $lPrpValue $lPrpType $lEditable] 
						} 
						delete_DboEffectivePropsIter $lPropsIter
						##puts "PinNam = $lMyPinName"

	 					
	 					set lPin [$lIter NextPin $lStatus] 
	 				}
	 				delete_DboPartInstPinsIter $lIter
	 			} 
	 			set lInst [$lPartInstsIter NextPartInst $lStatus] 
	 		} 
	 		delete_DboPagePartInstsIter $lPartInstsIter
	 		set lPage [$lPagesIter NextPage $lStatus] 
		} 
		delete_DboSchematicPagesIter $lPagesIter
		set lView [$lSchematicIter NextView $lStatus] 
	}
	delete_DboLibViewsIter $lSchematicIter
}

proc ::sdl::selectRootDesign {} {
	set lDsn [GetActivePMDesign]
	set lName [DboTclHelper_sMakeCString]
	$lDsn GetName $lName
	set lDsnTclName [DboTclHelper_sGetConstCharPtr $lName]
	##D:\CADENCE\SPB_16.6_BETA2\TOOLS\PSPICE\CAPTURE_SAMPLES\ADVANLS\BPF\SelectPMItem "PSpice Resources"

	set lStatus [DboState]
	set lRootSch [$lDsn GetRootSchematic $lStatus]
	set lSchName [DboTclHelper_sMakeCString]
	$lRootSch GetName $lSchName
	set lTclSchName [DboTclHelper_sGetConstCharPtr $lSchName]
	SelectPMItem $lTclSchName
}

proc ::sdl::openHTML {pFile  pTitle} {
	set id [orPrm::CreateWidget $orPrm::WTYPE_VIEW]
	orPrm::SetTitle $id $pTitle
	after idle ::sdl::showHTML $id $pFile
}

proc ::sdl::showHTML {id pFile} {
	set fp [open $pFile]
	orPrm::LoadStream $id [read $fp]
}