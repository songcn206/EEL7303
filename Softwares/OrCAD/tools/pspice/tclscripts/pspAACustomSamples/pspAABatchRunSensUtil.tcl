#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAABatchRunSensUtil.tcl
#            contains OrCAD PSpice Run AA like Smoke, Sens, sample
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl
package require PspAACtrlTcl 16.6.0
package provide PspAARunAnalysisUtil 1.0


set ::gWait 0

namespace eval ::pspAABatchRunSensUtil {
	variable pAAInterface
	variable pAASmokeInterface
	variable pAASensInterface
}

proc ::pspAABatchRunSensUtil::pspDesignTrue { args } {
	return 1;
}

proc ::pspAABatchRunSensUtil::loadDesign { pDesignAapPath } {
	set ::pspAABatchRunSensUtil::pAAInterface [createInterface]
	$::pspAABatchRunSensUtil::pAAInterface openAAProfile $pDesignAapPath
	#if 1 return 1
}

proc ::pspAABatchRunSensUtil::saveDesign { } {
	$::pspAABatchRunSensUtil::pAAInterface saveAAProfile "D:/work/data/designs/test/worklib/test/out/run$::index.aap"
}

proc ::pspAABatchRunSensUtil::createSens { } {
	set ::pspAABatchRunSensUtil::pAASensInterface [$::pspAABatchRunSensUtil::pAAInterface getSensitivityController]
	$::pspAABatchRunSensUtil::pAASensInterface addSpecifications NULL "-1"
}

proc ::pspAABatchRunSensUtil::addSensMeasurement { pMeasurementName pProfileName } {
	set pSpec [new_CSensSpecification]
	$pSpec setState 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::pspAABatchRunSensUtil::pAASensInterface addSpecifications $pSpec 
}

proc ::pspAABatchRunSensUtil::setSensMeasurement { } {
	$::pspAABatchRunSensUtil::pAASensInterface addSpecifications NULL "1"
}

proc ::pspAABatchRunSensUtil::runSens { } {
	$::pspAABatchRunSensUtil::pAASensInterface start 1
}


RegisterAction "_cdnPspAAAnalysisComplete" "::pspAABatchRunSensUtil::pspDesignTrue" "" "::pspAABatchRunSensUtil::saveDesign" ""


###################################

set index 0

##Run in loop, index++
#{
puts "Running Sensitivity Run $::index .."
## Do specific settings for this run

## Run sensitivity 
#::pspAABatchRunSensUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
::pspAABatchRunSensUtil::createSens 
# Need to specify the measurements
#::pspAABatchRunSensUtil::addSensMeasurement "Max(V(R1:ROUT))" "tr.sim" 
#::pspAABatchRunSensUtil::setSensMeasurement 
#::pspAABatchRunSensUtil::runSens
#after 20000 {set ::gWait 1}
#vwait ::gWait
#puts "Analysis Sensitivity done .."
#puts ""
##}
