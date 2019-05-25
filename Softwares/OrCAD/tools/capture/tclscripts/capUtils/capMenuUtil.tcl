#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capMenuUtil.tcl
#            contains OrCAD Capture Menu utlities
#
# You can run the script in the Capture TCL command window .
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4

package provide capMenuUtil 1.0

namespace eval ::capMenuUtil {
	
}

proc ::capMenuUtil::addPageAccessoryMenu { } {
	# AddAccessoryMenu  <User menu under Accessories>  <SubMenu under user menu> <Tcl callback handler with 2 parameters pPage and pOcc> 
			AddAccessoryMenu "Text Editors" "Notepad" "::capMenuUtil::OpenPageNotepad"
			AddAccessoryMenu "Text Editors" "Scite" "::capMenuUtil::OpenPageScite"
}

proc ::capMenuUtil::addDesignAccessoryMenu { } {
	# AddAccessoryMenu  <User menu under Accessories>  <SubMenu under user menu> <Tcl callback handler with 1 parameter pLib>
			AddAccessoryMenu "Text Editors" "Design in Notepad" "::capMenuUtil::OpenDesignNotepad"
			AddAccessoryMenu "Text Editors" "Design in Scite" "::capMenuUtil::OpenDesignScite"
			AddAccessoryMenu "Process Viewer" "Process Explorer" "::capMenuUtil::OpenDesignProcessExplorer"
}

proc ::capMenuUtil::OpenPageNotepad { pPage pOcc } {
	exec "C:/WINDOWS/system32/notepad.exe"
	puts [concat ":(:capMenuUtil::OpenPageNotepad) pPage is " $pPage " pOcc is " $pOcc]
}

proc ::capMenuUtil::OpenPageScite { pPage pOcc } {
	exec "d:/apps/wscite/SciTE.exe"
	puts [concat ":(:capMenuUtil::OpenPageScite) pPage is " $pPage " pOcc is " $pOcc]
	
}

proc ::capMenuUtil::OpenDesignNotepad { pLib } {
	exec "C:/WINDOWS/system32/notepad.exe"
	puts [concat ":(:capMenuUtil::OpenDesignNotepad) pLib is " $pLib]
}

proc ::capMenuUtil::OpenDesignScite { pLib } {
	exec "d:/apps/wscite/SciTE.exe"
	puts [concat ":(:capMenuUtil::OpenDesignScite) pLib is " $pLib]
}

proc ::capMenuUtil::OpenDesignProcessExplorer { pLib } {
	exec "d:/apps/ProcessExplorer/procexp.exe"
	puts [concat ":(:capMenuUtil::OpenDesignProcessExplorer) pLib is " $pLib]
}

proc ::capMenuUtil::capTrue { } {
	return 1
}

RegisterAction "_cdnCapTclAddPageCustomMenu" "::capMenuUtil::capTrue" "" "::capMenuUtil::addPageAccessoryMenu" ""
RegisterAction "_cdnCapTclAddDesignCustomMenu" "::capMenuUtil::capTrue" "" "::capMenuUtil::addDesignAccessoryMenu" ""
