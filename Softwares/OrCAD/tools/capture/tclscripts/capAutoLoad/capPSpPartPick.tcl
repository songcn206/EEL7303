#/////////////////////////////////////////////////////////////////////////////////
# Copyright Cadence Design Systems, Inc. 2012 All Rights Reserved.
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
# Cadence Design Systems, Inc is not responsible for any deviation between 
# actual device behavior and results obtained from simulation.
#  TCL file: capPSpPartPick.tcl
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {<INSTALLDIR>\tools\capture\tclscripts\capAutoLoad\capPSpPartPick.tcl}
#/////////////////////////////////////////////////////////////////////////////////
namespace eval ::capPSpPartPick {
	namespace export pspQplace
	package provide capPSpPartPick 1.0

}

proc ::capPSpPartPick::capPSpPartPickEnabler { args } {

	if { [IsSchematicViewActive] == 1} {
		return true
		}
    return false
	
}

proc ::capPSpPartPick::pspQplace {Olb Part} {

    if { 1 == [catch {package present orPrmUtils}] } {
        package require orPrmUtils
    }

set lOlbPath [correctUNCPath [file join [file dirname [info nameofexecutable]] library pspice $Olb.olb]]
PlaceNew $lOlbPath $Part 0

}

proc ::capPSpPartPick::DummyTrue {} {
    return true
}


RegisterAction "_capPSpPartPickEnabler" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::capPSpPartPickEnabler" ""

#//////Passives
RegisterAction "_PlaceR" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog R" ""
RegisterAction "_PlaceC" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog C" ""
RegisterAction "_PlaceL" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog L" ""
RegisterAction "_PlacePOT" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace Breakout POT" ""
RegisterAction "_PlaceCoupling" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout kbreak" ""
RegisterAction "_PlaceTlineId" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog T" ""
RegisterAction "_PlaceTlineLo" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog TLOSSY" ""

#//////Discrete
RegisterAction "_PlaceDiode" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout Dbreak" ""
RegisterAction "_PlaceNPN" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout QbreakN" ""
RegisterAction "_PlacePNP" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout QbreakP" ""
RegisterAction "_PlaceNPND" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout QDarBreakN" ""
RegisterAction "_PlacePNPD" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout QDarBreakP" ""
RegisterAction "_PlaceNMOS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout MbreakN3" ""
RegisterAction "_PlacePMOS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout MbreakP3" ""
RegisterAction "_PlacePowerNMOS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout power_Mbreakn" ""
RegisterAction "_PlacePowerDiode" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout power_Dbreak" ""
RegisterAction "_PlaceN-JFET" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout JbreakN" ""
RegisterAction "_PlaceP-JFET" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout JbreakP" ""
RegisterAction "_PlaceIGBT" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout ZbreakN" ""
RegisterAction "_PlaceGAsFET" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout Bbreak" "" 
RegisterAction "_PlaceOpAmp" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog OPAMP" ""



#//////Sources

#controlled
RegisterAction "_PlaceVCVS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog E" ""
RegisterAction "_PlaceVCCS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog G" ""
RegisterAction "_PlaceCCVS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog H" ""
RegisterAction "_PlaceCCCS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace analog F" ""

#current sources
RegisterAction "_PlaceIAC" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source IAC" ""
RegisterAction "_PlaceIDC" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source IDC" ""
RegisterAction "_PlaceIPulse" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source IPULSE" ""
RegisterAction "_PlaceISine" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source ISIN" ""
RegisterAction "_PlaceIExp" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source IEXP" ""
RegisterAction "_PlaceIFMsource" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source ISFFM" ""

#voltage sources
RegisterAction "_PlaceVAC" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VAC" ""
RegisterAction "_PlaceVDC" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VDC" ""
RegisterAction "_PlaceVPulse" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VPULSE" ""
RegisterAction "_PlaceVSine" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VSIN" ""
RegisterAction "_PlaceVExp" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VEXP" ""
RegisterAction "_PlaceVFMsource" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace source VSFFM" ""




#//////digital



#gates
RegisterAction "_PlaceAND" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim AND2" ""
RegisterAction "_PlaceOR" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim OR2" ""
RegisterAction "_PlaceNAND" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim NAN2" ""
RegisterAction "_PlaceNOR" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim NOR2" ""
RegisterAction "_PlaceXOR" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim XOR" ""
RegisterAction "_PlaceINV" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim INV" ""


#flipflops
RegisterAction "_PlaceD" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim DFF" ""
RegisterAction "_PlaceJK" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim JKFF" ""
RegisterAction "_PlaceRS" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim RSFF" ""
RegisterAction "_PlaceT" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace dig_prim TFF" ""

#ADC
RegisterAction "_PlaceADC8" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout ADC8break" ""
RegisterAction "_PlaceADC10" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout ADC10break" ""
RegisterAction "_PlaceADC12" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout ADC12break" ""


#DAC
RegisterAction "_PlaceDAC8" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout DAC8break" ""
RegisterAction "_PlaceDAC10" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout DAC10break" ""
RegisterAction "_PlaceDAC12" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout DAC12break" ""

#memory
#RAM
RegisterAction "_PlaceRAM8Kx1" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout RAM8Kx1break" ""
RegisterAction "_PlaceRAM8Kx8" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout RAM8Kx8break" ""


#ROM
RegisterAction "_PlaceROM32Kx1" "::capPSpPartPick::DummyTrue" "" "::capPSpPartPick::pspQplace breakout ROM32KX8break" ""



