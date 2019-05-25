#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
# 	Usage: ::orPrpParser::parsePrp <filename example d:/temp/pwrmos.prp>
# 		 The "process<Entity of prp>" functions will be automatically called
#		 Put application specific code in the "process" functions. 
#		 Example in the following file, all the data returned is being printed
# 
# Steps for running in Standalone TCL Shell
# 1. load <orCommonTcl.dll path> orCommonTcl
# 2. load <orParserTcl.dll path> orParser
# 3. source <script path>, 
# 	e.g. source orPrpParser.tcl
# 4. ::orPrpParser::parsePrp <filename>
# 	e.g. ::orPrpParser::parsePrp d:/temp/bipolar.prp
#
#/////////////////////////////////////////////////////////////////////////////////


package require Tcl 8.4
package require OrCommonTcl 
package require orParser 1.0
package provide orPrpParser 1.0

namespace eval ::orPrpParser {
	namespace export processModel
	namespace export processModelEnd
	
	namespace export processModelParamSectionStart
	namespace export processModelParamSectionEnd
	namespace export processModelParam
	namespace export processModelParamEnd
	namespace export processModelParamValue 
	
	namespace export processModelPinsStart
	namespace export processModelPinsEnd
	namespace export processModelPin
	
	namespace export processSmokeParamsStart
	namespace export processSmokeParamsEnd
	namespace export processSmokeParam
}

proc ::orPrpParser::processModel { pModelName } {
	puts " "
	puts -nonewline "model"
	puts -nonewline " "
	puts $pModelName
}

proc ::orPrpParser::processModelEnd { } {
	puts "ModelEnd"
}

proc ::orPrpParser::processModelParamSectionStart { } {
	puts "ModelParamSectionStart"
}

proc ::orPrpParser::processModelParamSectionEnd { } {
	puts "ModelParamSectionEnd"
}

proc ::orPrpParser::processModelParam { pModelParam } {
	puts -nonewline "ModelParam"
	puts -nonewline " "
	puts $pModelParam
}

proc ::orPrpParser::processModelParamValue { pModelParamVal pModelParamDesc } {
	puts -nonewline "ModelParamValue"
	puts -nonewline " "
	puts -nonewline $pModelParamVal
	puts -nonewline " "
	puts $pModelParam $pModelParamDesc
}

proc ::orPrpParser::processModelEnd { } {
	puts "ModelEnd"
}

proc ::orPrpParser::processModelPinsStart { } {
	puts "ModelPinsStart"
}

proc ::orPrpParser::processModelPinsEnd { } {
	puts "ModelPinsEnd"
}

proc ::orPrpParser::processModelPin { pModelPinName } {
	puts -nonewline "ModelPin"
	puts -nonewline " "
	puts $pModelPinName
}

proc ::orPrpParser::processSmokeParamsStart { } {
	puts "SmokeParamsStart"
}

proc ::orPrpParser::processSmokeParamsEnd { } {
	puts "SmokeParamsEnd"
}

proc ::orPrpParser::processSmokeParam { pSmokeParamName pSmokeParamVal } {
	puts -nonewline "SmokeParam"
	puts -nonewline " "
	puts -nonewline $pSmokeParamName
	puts -nonewline " "
	puts $pSmokeParamVal
}

proc ::orPrpParser::parsePrp { filename } {
	::orParsePrp $filename
}
