#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAAProcessSmokeRun.tcl
#            contains OrCAD PSpiceAA Run Smoke, and customisation routines for 
#		 1) For setting peak, rms and average values of parameters using temp calculation
# 		 2) For calculating the derated values
#		 3) For running user define smoke tests for an instance, and populating smoke output back to the tool 
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl
package require PspAACtrlTcl 16.6.0
package require PspAATcl 16.6.0
package provide PspAACustomRunSmokeUtil 1.0


namespace eval ::PspAACustomRunSmokeUtil {
	variable pAAInterface
	variable pAASmokeInterface
}

proc ::PspAACustomRunSmokeUtil::pspAADesignTrue { args } {
	return 1;
}

proc ::PspAACustomRunSmokeUtil::loadDesign { pDesignAapPath } {
	set ::PspAACustomRunSmokeUtil::pAAInterface [createInterface]
	$::PspAACustomRunSmokeUtil::pAAInterface openAAProfile $pDesignAapPath
	#if 1 return 1
}

proc ::PspAACustomRunSmokeUtil::runSmoke { pDesignSimPath } {
	PSAAReader_openDesign
	PSAAReader_enableAAInst_TclEval "R1"

	set ::PspAACustomRunSmokeUtil::pAASmokeInterface [$::PspAACustomRunSmokeUtil::pAAInterface getSmokeController]

	$::PspAACustomRunSmokeUtil::pAAInterface getAdvGeneralSettings
	#if 1 return 1

	$::PspAACustomRunSmokeUtil::pAAInterface getSmokeSettings
	#if 1 return 1

	$::PspAACustomRunSmokeUtil::pAASmokeInterface runSmoke $pDesignSimPath 
	#if 1 return 1
}

proc ::PspAACustomRunSmokeUtil::processDesignStart { } {
	PSAAReader_openDesign

	PSAAReader_enableAAInst_TclEval "R1"
	PSAAReader_enableAAInstDevSmoke "R1"
}

proc ::PspAACustomRunSmokeUtil::saveDesign { } {
	$::PspAACustomRunSmokeUtil::pAAInterface saveAAProfile ""
}

proc ::PspAACustomRunSmokeUtil::smokeDerateReliability { pInstName pParamName pDerFactor pDerFile } {
}

proc ::PspAACustomRunSmokeUtil::smokeDerateTemp { pInstName pParamName } {
	set lInst [$::PspAACustomRunSmokeUtil::pAASmokeInterface getInst "R1"]
	set lrba [$lInst GetMaxOpValue "RBA"]
	set lParam [$::PspAACustomRunSmokeUtil::pAASmokeInterface getInstSmokeParam "R1" "PDM"]
	$lParam SetPeakDerMax 45
}

proc ::PspAACustomRunSmokeUtil::smokePostPDM&TJ { pInstName } {
	}

proc ::PspAACustomRunSmokeUtil::smokePostPDM&TB { pInstName } {
	set lInst [$::PspAACustomRunSmokeUtil::pAASmokeInterface getInst "R1"]
	set lrba [$lInst GetMaxOpValue "RBA"]
	set lParam [$::PspAACustomRunSmokeUtil::pAASmokeInterface getInstSmokeParam "R1" "PDM"]
	$lParam SetPeak 50
}

proc ::PspAACustomRunSmokeUtil::smokePostPDML { pInstName } {
}

proc ::PspAACustomRunSmokeUtil::runCustomTest { pInstName } {
	set param $::PspAACustomRunSmokeUtil::pAASmokeInterface addInstSmokeParam "R1" "MYSMKTEST"

	####### Get the peak, average, rms values from the dat file #######

	####### Get the max op value from the instance parameters #########

	####### Perform user defined algorithms for derating values #######

	####### Set the smoke output values back to smoke results of the tool ######

	$param SetMaxOpValue 400

	$param SetPeak 200
	$param SetAverage 210
	$param SetRMS 220

	$param SetPeakDerMax 300
	$param SetAverageDerMax 290
	$param SetRMSDerMax 290
}

RegisterAction "_cdnPspAAProcessDesignStart" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::processDesignStart" ""
RegisterAction "_cdnPspAAAnalysisComplete" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::saveDesign" ""
RegisterAction "_cdnPspAASmokeDerateReliability" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::smokeDerateReliability" ""
RegisterAction "_cdnPspAASmokeDerateTemp" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::smokeDerateTemp" ""
RegisterAction "_cdnPspAASmokePostPDM&TJ" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::smokePostPDM&TJ" ""
RegisterAction "_cdnPspAASmokePostPDM&TB" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::smokePostPDM&TB" ""
RegisterAction "_cdnPspAASmokePostPDML" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::smokePostPDML" ""

RegisterAction "_cdnPspAARunCustomSmoke" "::PspAACustomRunSmokeUtil::pspAADesignTrue" "" "::PspAACustomRunSmokeUtil::runCustomTest" ""


# Run smoke
::PspAACustomRunSmokeUtil::loadDesign "D:/work/designs/test/test/aa2-PSpiceFiles/SCHEMATIC1/SCHEMATIC1.aap"
::PspAACustomRunSmokeUtil::runSmoke "D:/work/designs/test/test/aa2-PSpiceFiles/SCHEMATIC1/tr.sim"
::PspAACustomRunSmokeUtil::saveDesign
deleteInterface $::PspAACustomRunSmokeUtil::pAAInterface

