#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAARunAnalysisUtil.tcl
#            contains OrCAD PSpiceAA Run Smoke, Sens, MC, PPlot, Optimizer sample
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl
package require PspAACtrlTcl 16.6.0
package require orPspEng 16.6.0
package provide PspAARunAnalysisUtil 1.0


namespace eval ::PspAARunAnalysisUtil {
	variable pAAInterface
	variable pAASmokeInterface
	variable pAASensInterface
	variable pAAMonteCarloInterface 
	variable pPlotInterface 
	variable pOptInterface 
}

proc ::PspAARunAnalysisUtil::pspDesignTrue { args } {
	return 1;
}

proc ::PspAARunAnalysisUtil::loadDesign { pDesignAapPath } {
	set ::PspAARunAnalysisUtil::pAAInterface [createInterface]
	$::PspAARunAnalysisUtil::pAAInterface openAAProfile $pDesignAapPath
	#if 1 return 1
}

proc ::PspAARunAnalysisUtil::processDesignStart { } {
	PSAAReader_openDesign

	PSAAReader_enableAAInst_TclEval "R1"
	PSAAReader_enableAAInstDevSmoke "R1"
}

proc ::PspAARunAnalysisUtil::processDesignEnd { } {
	PSAAReader_save
}

proc ::PspAARunAnalysisUtil::runSmokeCustomTest { pInstName } {
	set param $::PspAARunAnalysisUtil::pAASmokeInterface addInstSmokeParam "R1" "MYSMKTEST"

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

proc ::PspAARunAnalysisUtil::runSmoke { pDesignSimPath } {
	set ::PspAARunAnalysisUtil::pAASmokeInterface [$::PspAARunAnalysisUtil::pAAInterface getSmokeController]

	$::PspAARunAnalysisUtil::pAAInterface getAdvGeneralSettings
	#if 1 return 1

	$::PspAARunAnalysisUtil::pAAInterface getSmokeSettings
	#if 1 return 1

	$::PspAARunAnalysisUtil::pAASmokeInterface runSmoke $pDesignSimPath 
	#if 1 return 1
}


proc ::PspAARunAnalysisUtil::saveDesign { } {
	$::PspAARunAnalysisUtil::pAAInterface saveAAProfile ""
}

proc ::PspAARunAnalysisUtil::createSens { } {
	set ::PspAARunAnalysisUtil::pAASensInterface [$::PspAARunAnalysisUtil::pAAInterface getSensitivityController]
	$::PspAARunAnalysisUtil::pAASensInterface addSpecifications NULL "-1"
}

proc ::PspAARunAnalysisUtil::addSensMeasurement { pMeasurementName pProfileName } {
	set pSpec [new_CSensSpecification]
	$pSpec setState 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pAASensInterface addSpecifications $pSpec 
}

proc ::PspAARunAnalysisUtil::setSensMeasurement { } {
	$::PspAARunAnalysisUtil::pAASensInterface addSpecifications NULL "1"
}

proc ::PspAARunAnalysisUtil::runSens { } {
	$::PspAARunAnalysisUtil::pAASensInterface start 1 1
}

proc ::PspAARunAnalysisUtil::createMC { } {
	set ::PspAARunAnalysisUtil::pAAMonteCarloInterface [$::PspAARunAnalysisUtil::pAAInterface getMonteController]
	$::PspAARunAnalysisUtil::pAAMonteCarloInterface addSpecifications NULL "-1"
}

proc ::PspAARunAnalysisUtil::addMCMeasurement { pMeasurementName pProfileName } {
	set pSpec [new_CMonteSpecification]
	$pSpec setState 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pAAMonteCarloInterface addSpecifications $pSpec 
}

proc ::PspAARunAnalysisUtil::setMCMeasurement { } {
	$::PspAARunAnalysisUtil::pAAMonteCarloInterface addSpecifications NULL "1"
}

proc ::PspAARunAnalysisUtil::runMC { } {
	$::PspAARunAnalysisUtil::pAAMonteCarloInterface start 1 1
}

proc ::PspAARunAnalysisUtil::createPPlot { } {
	set ::PspAARunAnalysisUtil::pPlotInterface [$::PspAARunAnalysisUtil::pAAInterface getPplotController]
	$::PspAARunAnalysisUtil::pPlotInterface addSpecifications NULL "-1"
	$::PspAARunAnalysisUtil::pPlotInterface addParameters NULL "-1"
}

proc ::PspAARunAnalysisUtil::addPPlotMeasurement { pMeasurementName pProfileName } {
	set pSpec [new_CPplotSpecification]
	$pSpec setState 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pPlotInterface addSpecifications $pSpec 
}

proc ::PspAARunAnalysisUtil::setPPlotMeasurement { } {
	$::PspAARunAnalysisUtil::pPlotInterface addSpecifications NULL "1"
}

proc ::PspAARunAnalysisUtil::addPPlotParam { pRefdes pParam pSweepVar pSweepType pPoints } {
	set pSpec [new_CPplotParameter]
	$pSpec setState 1
	$pSpec setNotes "Okay"
	$pSpec setRefDes $pRefdes 
	$pSpec setParamName $pParam 
	$pSpec setSweepVariable $pSweepVar 
	$pSpec setSweepType $pSweepType 
	$pSpec setPoints $pPoints 
	$::PspAARunAnalysisUtil::pPlotInterface addParameters $pSpec 
}

proc ::PspAARunAnalysisUtil::setPPlotParam { } {
	$::PspAARunAnalysisUtil::pPlotInterface addParameters NULL "1"
}

proc ::PspAARunAnalysisUtil::setPPlotSweepPath { path } {
	set settings [new_CPplotSettings]
	$settings setSweepFilePath $path 
	$::PspAARunAnalysisUtil::pPlotInterface addSettings $settings
	delete_CPplotSettings $settings
}

proc ::PspAARunAnalysisUtil::startPPlotInfo { } {
	set ::PspAARunAnalysisUtil::pPlotInterface_Info [new_CPplotPlotInfo]
}

proc ::PspAARunAnalysisUtil::endPPlotInfo { } {
	$::PspAARunAnalysisUtil::pPlotInterface addPPlotInfo $::PspAARunAnalysisUtil::pPlotInterface_Info
	delete_CPplotPlotInfo $::PspAARunAnalysisUtil::pPlotInterface_Info 
}

proc ::PspAARunAnalysisUtil::addPPlotInfo { plotname pVar pAxis pIsMeasurement } {
	$::PspAARunAnalysisUtil::pPlotInterface_Info setValue $plotname $pVar $pAxis
	$::PspAARunAnalysisUtil::pPlotInterface_Info setIsMeasurement $plotname $pVar $pIsMeasurement 
	$::PspAARunAnalysisUtil::pPlotInterface_Info setBasePPlotPos $plotname $pVar 0
	$::PspAARunAnalysisUtil::pPlotInterface_Info setBasePPlotConstPos $plotname $pVar -1
}	

proc ::PspAARunAnalysisUtil::runPPlot { path } {
	$::PspAARunAnalysisUtil::pPlotInterface clearSweepValues
	$::PspAARunAnalysisUtil::pPlotInterface writePplotDataFile $path
	$::PspAARunAnalysisUtil::pPlotInterface start 1 1
	$::PspAARunAnalysisUtil::pPlotInterface writePplotDataFile $path
}

proc ::PspAARunAnalysisUtil::createOpt { pEngine pGear } {
	set ::PspAARunAnalysisUtil::pOptInterface [$::PspAARunAnalysisUtil::pAAInterface getOptimizerController]
	$::PspAARunAnalysisUtil::pAAInterface setCurrentEngine $pEngine
	$::PspAARunAnalysisUtil::pAAInterface setCurrentGear $pGear 	
	$::PspAARunAnalysisUtil::pOptInterface addParameters NULL "-1"
}

proc ::PspAARunAnalysisUtil::addOptParam { pLocked pRefDes pParamName pMin pMax pValue } {
	set pSpec [new_COptParameter]
	$pSpec setState 1
	$pSpec setLocked $pLocked 
	$pSpec setRefDes $pRefDes 
	$pSpec setParamName $pParamName 
	$pSpec setMin $pMin 
	$pSpec setMax $pMax
	$pSpec setParamVal $pValue
	$pSpec setCurrent $pValue
	$pSpec setDiscreteTableAlias ""
	$pSpec setDiscreteTable ""
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pOptInterface addParameters $pSpec 
}

proc ::PspAARunAnalysisUtil::setOptParam { } {
	$::PspAARunAnalysisUtil::pOptInterface addParameters NULL "1"
}

proc ::PspAARunAnalysisUtil::clearOptMeasurement { } {
	$::PspAARunAnalysisUtil::pOptInterface addSpecifications NULL 0 "-1"
}

proc ::PspAARunAnalysisUtil::addOptMeasurement { pIsGoal pMeasurementName pProfileName pMin pMax pWeight } {
	set pSpec [new_COptSpecification]
	$pSpec setState 1		
	$pSpec setGraphState 1
	$pSpec setIsCurveFit 0
	$pSpec setIsGoal $pIsGoal 
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setSpecification $pMin
	$pSpec setSpecification2 $pMax
	$pSpec setWeight $pWeight 
	$pSpec setNominal ""
	$pSpec setCurrent ""
	$pSpec setError ""
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pOptInterface addSpecifications $pSpec 0
}

proc ::PspAARunAnalysisUtil::setOptMeasurement { } {
	$::PspAARunAnalysisUtil::pOptInterface addSpecifications NULL 0 "1"
}

proc ::PspAARunAnalysisUtil::addOptCFSpec { pMeasurementName pProfileName pTol pWeight pReferenceFileName pWaveform } {
	set pSpec [new_COptSpecification]
	$pSpec setState 1
	$pSpec setGraphState 1
	$pSpec setDynamic 0
	$pSpec setIsCurveFit 1
	$pSpec setProfileName $pProfileName 
	$pSpec setName $pMeasurementName 
	$pSpec setSpecification2 [expr $pTol/100]
	$pSpec setWeight $pWeight 
	$pSpec setMdpFileName $pReferenceFileName 
	$pSpec setColumnName $pWaveform 
	$pSpec setNotes "Okay"
	$pSpec setSeverity 1
	$::PspAARunAnalysisUtil::pOptInterface addSpecifications $pSpec 1
}

proc ::PspAARunAnalysisUtil::setOptCFSpec { } {
	$::PspAARunAnalysisUtil::pOptInterface addSpecifications NULL 1 "1"
}

proc ::PspAARunAnalysisUtil::runOpt { } {
	$::PspAARunAnalysisUtil::pOptInterface start 1 1
}


RegisterAction "_cdnPspAAAnalysisComplete" "::PspAARunAnalysisUtil::pspDesignTrue" "" "::PspAARunAnalysisUtil::saveDesign" ""
RegisterAction "_cdnPspAAProcessDesignStart" "::PspAARunAnalysisUtil::pspDesignTrue" "" "::PspAARunAnalysisUtil::processDesignStart" ""
RegisterAction "_cdnPspAAProcessDesignEnd" "::PspAARunAnalysisUtil::pspDesignTrue" "" "::PspAARunAnalysisUtil::processDesignEnd" ""
RegisterAction "_cdnPspAARunCustomSmoke" "::PspAARunAnalysisUtil::pspAADesignTrue" "" "::PspAARunAnalysisUtil::runSmokeCustomTest" ""


# Set license to start with 
##pspAASetLicenseBatchMode PSpiceAA
##PSpiceSetLicenseBatchMode PSpiceAD


# Run smoke
##::PspAARunAnalysisUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
##::PspAARunAnalysisUtil::runSmoke "D:/work/data/designs/test/worklib/test/psp_sim_1/profiles/tran.sim"
##::PspAARunAnalysisUtil::saveDesign
##deleteInterface $::PspAARunAnalysisUtil::pAAInterface


# Run sensitivity 
##::PspAARunAnalysisUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
##::PspAARunAnalysisUtil::createSens 
# Need to specify the measurements
##::PspAARunAnalysisUtil::addSensMeasurement "Max(V(R1:ROUT))" "tran.sim" 
##::PspAARunAnalysisUtil::setSensMeasurement 
##::PspAARunAnalysisUtil::runSens
##deleteInterface $::PspAARunAnalysisUtil::pAAInterface

# Run MC
##::PspAARunAnalysisUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
##::PspAARunAnalysisUtil::createMC 
# Need to specify the measurements
##::PspAARunAnalysisUtil::addMCMeasurement "Max(V(R1:ROUT))" "tran.sim" 
##::PspAARunAnalysisUtil::setMCMeasurement 
##::PspAARunAnalysisUtil::runMC 
##deleteInterface $::PspAARunAnalysisUtil::pAAInterface


# Run PPlot
##::PspAARunAnalysisUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
##::PspAARunAnalysisUtil::createPPlot 
##::PspAARunAnalysisUtil::addPPlotMeasurement "Max(I(R7))" "tran.sim" 
##::PspAARunAnalysisUtil::setPPlotMeasurement 
##::PspAARunAnalysisUtil::addPPlotParam "R7" "VALUE" "outer" $::PSP_SWEEP_LINEAR "30,3000,300"
##::PspAARunAnalysisUtil::setPPlotParam 
##::PspAARunAnalysisUtil::setPPlotSweepPath "D:/work/data/designs/test/worklib/test/psp_sim_1/CurrentPlot.tbl"
##::PspAARunAnalysisUtil::startPPlotInfo 
##::PspAARunAnalysisUtil::addPPlotInfo "Plot 1" "r7::VALUE" "X-Axis" 0
##::PspAARunAnalysisUtil::addPPlotInfo "Plot 1" "tran.sim::max(i(r7))" "Y-Axis" 1
##::PspAARunAnalysisUtil::endPPlotInfo 
##::PspAARunAnalysisUtil::runPPlot "D:/work/data/designs/test/worklib/test/psp_sim_1//CurrentPlot.tbl"
##deleteInterface $::PspAARunAnalysisUtil::pAAInterface

# Run Optimizer
##::PspAARunAnalysisUtil::loadDesign "D:/work/data/designs/test/worklib/test/psp_sim_1/test.aap"
##::PspAARunAnalysisUtil::createOpt $::HYBRID $::DEFAULT_GEAR
##::PspAARunAnalysisUtil::addOptParam 0 "R7" "VALUE" "30" "3000" "300" 
##::PspAARunAnalysisUtil::setOptParam
##::PspAARunAnalysisUtil::clearOptMeasurement 
##::PspAARunAnalysisUtil::addOptMeasurement 1 "Max(I(R7))" "tran.sim" "0" "100" "1"
##::PspAARunAnalysisUtil::setOptMeasurement 
##::PspAARunAnalysisUtil::clearOptMeasurement 
####::PspAARunAnalysisUtil::addOptCFSpec "Max(I(R7))" "tr.sim" "5" "1" "" "" 
##::PspAARunAnalysisUtil::setOptCFSpec 
##::PspAARunAnalysisUtil::runOpt 
##deleteInterface $::PspAARunAnalysisUtil::pAAInterface

