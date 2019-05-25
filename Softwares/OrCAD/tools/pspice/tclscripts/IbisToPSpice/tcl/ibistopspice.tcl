package require Tcl 8.4
package require orPspUtils 1.0
package require orPrmWebComp 1.0

package provide ibistopspice 1.0


namespace eval ::ibistopspice {
	set gScriptDir [file dirname [info script]]
	set gRootDir [file join $::ibistopspice::gScriptDir ..]
	set gWidgetId 0
	set gSaveMode 0
	set gStrFullProjectPath ""
}

proc ::ibistopspice::registerActions {} {
	RegisterAction "_cdnPspIBIS2PSpice" "::ibistopspice::EnableIBIS" "" "::ibistopspice::run" ""
	RegisterAction "_cdnPspIBIS2PSpiceUpdate" "::ibistopspice::EnableIBIS" "" "::ibistopspice::update" ""
}

proc ::ibistopspice::EnableIBIS {} {
	return true
}

proc ::ibistopspice::update {} {
	return true
}

proc ::ibistopspice::run {} {
	set lModalId [orPrm::GetNextId]
	set ::ibistopspice::gWidgetId $lModalId
	set res [correctUNCPath [file join $::ibistopspice::gRootDir hybrid ibisToPSpice.html]]
	set ::actualDialogId [orPrm::CreateModalDialog $lModalId $res "IBIS to PSpice Converter" 550 730 1]
}

proc ::ibistopspice::setStim {parameters} {
	set mylist [split $parameters ","]
	set lRiseTime [lindex $mylist 0]
	set lFallTime [lindex $mylist 1]
	set lPulseWidth [lindex $mylist 2]
	set lPeriod [lindex $mylist 3]
	$::ibistopspice::ibis setStimulusParams $lRiseTime $lFallTime $lPulseWidth $lPeriod
}

proc ::ibistopspice::ok {parameters} {
	##const char* pCellName, int pModelType, double pROSNB, double pVFix, double pRFix, bool pUse2Vt, bool pPinModels
	set mylist [split $parameters ","]
	set lCellName ""
	set lModelType [lindex $mylist 0]
	set lROSNB [lindex $mylist 1]
	set lVFix [lindex $mylist 2]
	set lRFix [lindex $mylist 3]
	set lUse2Vt [lindex $mylist 4]
	set lPinModels [lindex $mylist 5]
	##puts "CellName:\"$lCellName\" $lModelType $lROSNB $lVFix $lRFix $lUse2Vt"
	set returnVal [$::ibistopspice::ibis generateLib $lCellName $lModelType $lROSNB $lVFix $lRFix $lUse2Vt $lPinModels]
	if {$returnVal == 1} {
		puts "License failure - PSpice/PSpiceAD License not found."
		return 1
	} {
	
		ibistopspice::deleteObj
		orPrm::DestroyWidget $::ibistopspice::gWidgetId
		
		set lib [string replace $ibistopspice::ibisFile end-3  end ".lib"]
		##puts $lib
		OpenLib $lib
	}
}

proc ::ibistopspice::cancel {} {
	ibistopspice::deleteObj	
	orPrm::DestroyWidget $::ibistopspice::gWidgetId
}

proc ::ibistopspice::deleteObj {} {
	set initialized [info exists ::ibistopspice::ibis]
	if {$initialized != 0} {
		delete_PIbisDMLParser $::ibistopspice::ibis
		unset ::ibistopspice::ibis
	}
}

proc ::ibistopspice::getComponents {parameters} {
	## ibisPath pRegenerateDml pUnique
	set mylist [split $parameters ","]

	set ibisPath [lindex $mylist 0]
	set pRegenerateDml [lindex $mylist 1]
	set pUnique [lindex $mylist 2]

	set ::ibistopspice::ibisFile $ibisPath
	set initialized [info exists ::ibistopspice::ibis]
	if {$initialized == 0} {
		load {orpspiceibisparser.dll}
	} {
		ibistopspice::deleteObj
	}
		
	set ::ibistopspice::ibis [createIBISParser]
	set out [$::ibistopspice::ibis getModelsForTCL $ibisPath $pRegenerateDml $pUnique]
	#puts $out
	return $out
}

proc ::ibistopspice::getPinForComp { comp } {
	#puts getPinForComp$comp
	set out [$::ibistopspice::ibis getCompPins $comp ]
	#puts out$out
	return $out
}

proc ::ibistopspice::getSignalForComp { comp } {
	#puts getSignalForComp$comp
	set out [$::ibistopspice::ibis getCompSignals $comp ]
	#puts out$out
	return $out
}

proc ::ibistopspice::getPin { model } {
	#puts getPin$model
	set out [$::ibistopspice::ibis getPins $model]
	#puts $out
	return $out
}

proc ::ibistopspice::getSignal { model } {
	set out [$::ibistopspice::ibis getSignals $model]
	#puts $out
	return $out
}

proc ::ibistopspice::getModelForPin { param } {
	set mylist [split $param ","]
	set pin [lindex $mylist 0]
	set component [lindex $mylist 1]
	#puts getModelForPin_$component$pin
	
	set lComponent [$::ibistopspice::ibis getComponentObj $component]

	set lCompExists [info exists lComponent]
	if {$lCompExists} {
		return [$lComponent getModelForPin $pin]
	} {
		return ""
	}
}

proc ::ibistopspice::getModelForSignal { param } {
	set mylist [split $param ","]
	set signal [lindex $mylist 0]
	set component [lindex $mylist 1]
	#puts getModelForSignal_$signal$component
	
	set lComponent [$::ibistopspice::ibis getComponentObj $component]
	set lCompExists [info exists lComponent]
	if {$lCompExists} {
		return [$lComponent getModelForSignal $signal]
	} {
		return ""
	}
}


proc ::ibistopspice::getSignalForPin { param } {
	set mylist [split $param ","]
	set pin [lindex $mylist 0]
	set component [lindex $mylist 1]
	#puts getSignalForPin_$component$pin
	
	set lComponent [$::ibistopspice::ibis getComponentObj $component]
	set lCompExists [info exists lComponent]
	if {$lCompExists} {
		return [$lComponent getSignalForPin $pin]
	} {
		return ""
	}
}

proc ::ibistopspice::getPinForSignal { param } {
	set mylist [split $param ","]
	set signal [lindex $mylist 0]
	set component [lindex $mylist 1]
	
	#puts getPinForSignal_$signal$component
	
	set lComponent [$::ibistopspice::ibis getComponentObj $component]
	set lCompExists [info exists lComponent]
	if {$lCompExists} {
		return [$lComponent getPinForSignal $signal]
	} {
		return ""
	}
}

proc ::ibistopspice::getModels {ibisPath } {
	return ""
}

proc ::ibistopspice::getModels1 {ibisPath } {
	set ::ibistopspice::ibis [createIBISParser]
	set out [$::ibistopspice::ibis getModelsForTCL $ibisPath]
	return $out
}

proc ::ibistopspice::setModel {modelName} {
	$::ibistopspice::ibis setModelForTCL $modelName
}

proc ::ibistopspice::help {} {
	orCommonTclUtil_ShowHelp "pspug" "70112"
}
