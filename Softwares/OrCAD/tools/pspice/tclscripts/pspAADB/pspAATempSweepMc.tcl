#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAATempSweepMc.tcl
#            contains OrCAD PSpiceAA Run Temperature Sweep with MC
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl
package require PspAACtrlTcl 16.6.0
package require PSpiceAA 16.6.0
package provide pspAATempSweepMc 1.0


namespace eval ::pspAATempSweepMc {
	variable pAAInterface
	variable pAASmokeInterface
	variable pAASensInterface
	variable pAAMonteCarloInterface 
	variable pPlotInterface 
	variable pOptInterface 
	variable pCurrentTemp
}

proc ::pspAATempSweepMc::pspDesignTrue { args } {
	return 1;
}

proc ::pspAATempSweepMc::loadDesign { pDesignAapPath } {
	set ::pspAATempSweepMc::pAAInterface [createInterface]
	$::pspAATempSweepMc::pAAInterface openAAProfile $pDesignAapPath
	#if 1 return 1
	set ::pspAATempSweepMc::pCurrentRun 0
puts "Opening the Advanced Analysis file $pDesignAapPath"
}

proc ::pspAATempSweepMc::saveDesign { } {
	$::pspAATempSweepMc::pAAInterface saveAssociatedProfile "Monte Carlo run at Temperature $::pspAATempSweepMc::pCurrentTemp"
}

proc ::pspAATempSweepMc::createMC { } {
	set ::pspAATempSweepMc::pAAMonteCarloInterface [$::pspAATempSweepMc::pAAInterface getMonteController]
}

proc ::pspAATempSweepMc::addMCMeasurement { pMeasurementName pProfileName } {
	set pSpec [new_CMonteSpecification]
	$pSpec setState 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::pspAATempSweepMc::pAAMonteCarloInterface addSpecifications $pSpec 
}

proc ::pspAATempSweepMc::setMCMeasurement { } {
	$::pspAATempSweepMc::pAAMonteCarloInterface addSpecifications NULL "1"
}

proc ::pspAATempSweepMc::runMC { } {
	$::pspAATempSweepMc::pAAMonteCarloInterface start 1 1
}

proc ::pspAATempSweepMc::runMCCustom { tempStart tempEnd tempStep } {

::pspAATempSweepMc::createMC 

puts "Running Monte Carlo analysis with Temperature Sweep"

	set temp $tempStart

	$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_init
	
	set run 0

	while {1} {

		set lInitialRun false
		set lLastRun false

		set diff [expr $tempEnd - $temp]

		if { $diff < 0 } {
puts "End of Monte Carlo analysis"
			break
		}

		if {$run==0} {
			set lInitialRun true
		}
		if {$diff < $tempStep} {
			set lLastRun true
		}

puts "Running at temperature $temp"

		$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_initRun

		while {1} {
			$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_initStep $lInitialRun 

			$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_setTemp $temp
			set ::pspAATempSweepMc::pCurrentTemp $temp

			set t1 [$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_runStep]

			set t2 [$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_evaluateMeasurement]

			if { $t1!=0 || $t2!=0 } {
				break
			}

			if {[$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_generateNextParam $lLastRun] != 0} {
				break
			}
			
			if {[$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_checkIfRunComplete $lLastRun] != 0} {
				break
			}

			$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_endStep
		}

		$::pspAATempSweepMc::pAAMonteCarloInterface runCustom_endRun

		set temp [expr $temp + $tempStep]
		set run [expr $run + 1]
	}

deleteInterface $::pspAATempSweepMc::pAAInterface

}



RegisterAction "_cdnPspAAAnalysisComplete" "::pspAATempSweepMc::pspDesignTrue" "" "::pspAATempSweepMc::saveDesign" ""


##::pspAATempSweepMc::loadDesign "D:/work/lowpass/lowpass-PSpiceFiles/lowpass/lowpass.aap"
##::pspAATempSweepMc::runMCCustom 27 34 3
##::pspAAUI::displayResults "D:/work/lowpass/lowpass-PSpiceFiles/lowpass/lowpass.aap" "Monte Carlo run at Temperature 30"
