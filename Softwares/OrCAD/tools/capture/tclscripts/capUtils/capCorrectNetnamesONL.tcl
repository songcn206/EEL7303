#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCorrectNetNamesONL.tcl
#            contains OrCAD Capture Design utlities
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#  
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capNetNamesCorrection 1.0

namespace eval ::capNetNamesCorrection {
	namespace export correctName
}


proc ::capNetNamesCorrection::RegisterPatternMatch { }  {
	RegisterAction "_cdnReplaceNetNames"  "::capNetNamesCorrection::enable" "" "::capNetNamesCorrection::correctName" "" 
}

proc ::capNetNamesCorrection::enable {pTextToCorrect }  {
	return 1
}

proc ::capNetNamesCorrection::correctName {pTextToCorrect pFormatName }  {
	set lNullObj NULL
	
	set result $pTextToCorrect
	
	if { $pTextToCorrect == $lNullObj ||
		$pTextToCorrect == "" }	{
		puts "Incorrect usage"
		return
	}
	if { $pFormatName == "orVstmodel.dll" } {
	set result [string map {"." "_"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orOhdlnet.dll" } {
	set result [string map {"." "_"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orPcadnlt.dll" } {
	set result [string map {"." "_"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orEdif.dll" } {
	set result [string map {"." "_"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orCbds.dll" } {
	set result [string map {"." "-"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orCalay90.dll" } {
	set result [string map {"." "-"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	if { $pFormatName == "orCalay.dll" } {
	set result [string map {"." "-"} $pTextToCorrect]
	
	if { $pTextToCorrect != $result } {
		set lMessage "Warning : $pTextToCorrect changed to $result"
		set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	}
	}
	
	return $result
}

