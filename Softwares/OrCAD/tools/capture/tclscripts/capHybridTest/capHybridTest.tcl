#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capHybridTest.tcl
#            contains HTML Testing Utilities
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\views\ankitj_view\CAPTURE\CCS\data\tclfiles\tclscripts\capHybridTest\capHybridTest.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require orPrmJSON
package require orPrmStreamer
package require orPrmDebug
package provide capHybridTest 1.0


namespace eval ::capHybridTest {
	variable widgetId
}

proc ::capHybridTest::capHybridTestInitialise { wId} {
	set ::capHybridTest::widgetId $wId
}


proc ::capHybridTest::capMakeJSONList { pList } {
	set lDRCList {}

	foreach drc $pList {
		set lDRCRule {}
		foreach {name value} $drc {
			set lDRCRule [list $name [orPrmStreamer::streamString $value]]
		}
		lappend lDRCList [orPrmStreamer::streamObject $lDRCRule]
	}
	
	set lDRCArray [orPrmStreamer::streamArray $lDRCList]
	set lDRCs [orPrmStreamer::streamObject [list drcs $lDRCArray]]
	return [orPrmJSON::encode $lDRCs]
}

proc ::capHybridTest::capReplay { pDir pFile } {
	set a [list dir $pDir]
	set b [list file $pFile]
	set pList [list $a $b]
	set JSONList [capHybridTest::capMakeJSONList $pList]
	Execute $::capHybridTest::widgetId capReplay($JSONList)
}

proc ::capHybridTest::capStartRecording { pDir pFile } {
	set a [list dir $pDir]
	set b [list file $pFile]
	set pList [list $a $b]
	set JSONList [capHybridTest::capMakeJSONList $pList]
	Execute $::capHybridTest::widgetId capStartRecording($JSONList)
}

proc ::capHybridTest::capStopRecording {} {
	Execute $::capHybridTest::widgetId capStopRecording()
}



