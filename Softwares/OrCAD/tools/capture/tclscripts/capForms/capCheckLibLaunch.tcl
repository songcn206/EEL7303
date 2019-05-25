#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCheckLibLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capCheckLibLaunch 1.0

namespace eval capCheckLibLaunch {
	variable mForm
	variable mLibPath
	variable mLogPath
}

proc capCheckLibLaunch::ui {pForm} {
    
    set ::capCheckLibLaunch::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
    variable lLabelLibraryPath [label $pForm.lLabelLibraryPath \
	    -text "Library Path"]
	    
    set lState "normal"
    
    variable lLibPath [entry $pForm.lLibPath \
	    -textvariable "::capCheckLibLaunch::mLibPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLibPath [button $pForm.lBtnLibPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capCheckLibLaunch::doChooseLibFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lLabelLogPath [label $pForm.lLabelLogPath \
	    -text "Log File"]
	    
    set lState "normal"
    
    variable lLogPath [entry $pForm.lLogPath \
	    -textvariable "::capCheckLibLaunch::mLogPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLogPath [button $pForm.lBtnLogPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capCheckLibLaunch::doChooseLogFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lBtnCheck [button $pForm.lBtnCheck \
	    -command "capCheckLibLaunch::doCheck" \
	    -state $lState \
	    -text "Check"]
    
    variable lBtnCorrect [button $pForm.lBtnCorrect \
	    -command "capCheckLibLaunch::doCorrect" \
	    -state $lState \
	    -text "Correct"]
    
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capCheckLibLaunch::doCancel" \
	    -text "Cancel"]
    
    # Geometry Management

    grid $pForm.lLabelLibraryPath -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLibPath -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnLibPath -in $pForm -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelLogPath -in $pForm -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLogPath -in $pForm -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnLogPath -in $pForm -row 2 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelFrameButtons -in $pForm -row 3 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnCheck -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnCorrect -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnCancel -in $pForm.lLabelFrameButtons -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "e"
    
    # Resize Behavior
    grid rowconfigure $pForm 1 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 40 -pad 0
    grid columnconfigure $pForm 3 -weight 0 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
}

proc capCheckLibLaunch::doCheck { } {
	
	if { $::capCheckLibLaunch::mLibPath == "" || $::capCheckLibLaunch::mLogPath == ""} {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Check And Correct Library Message"
		return
	}
	
	if {[file exists $::capCheckLibLaunch::mLibPath] !=1 } {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Check And Correct Library Message"
		return
	}
	
	if { [catch {eval ::capLibUtil::checkPkgs $::capCheckLibLaunch::mLibPath $::capCheckLibLaunch::mLogPath}] } {
            tk_messageBox -type ok -message "Library check failed" -title "Check And Correct Library Message"
		return
        }
	
	set lMessage [concat "(capCheckLibLaunch::doCheck) Log file has been saved as " $::capCheckLibLaunch::mLogPath]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	
	destroy $::capCheckLibLaunch::mForm
	
	#launch log file if succeeds
	if {[file exists $::capCheckLibLaunch::mLogPath] ==1 } {
		catch {Shell $::capCheckLibLaunch::mLogPath}
	}
}

proc capCheckLibLaunch::doCorrect {  } {
	
	if { $::capCheckLibLaunch::mLibPath == "" || $::capCheckLibLaunch::mLogPath == ""} {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Check And Correct Library Message"
		return
	}
	
	if {[file exists $::capCheckLibLaunch::mLibPath] !=1 } {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Check And Correct Library Message"
		return
	}
	
	set lBackupFile [concat $::capCheckLibLaunch::mLibPath[pid][clock clicks]]
	if {[catch {file copy -force $::capCheckLibLaunch::mLibPath $lBackupFile}] } {
		tk_messageBox -type ok -message [concat "Unable to save Backup file " $lBackupFile] -title "Check And Correct Library Message"
		return
	} 
	
	
	if { [catch {eval ::capLibUtil::correctPkgs $::capCheckLibLaunch::mLibPath $::capCheckLibLaunch::mLogPath}] } {
            tk_messageBox -type ok -message "Library correction failed" -title "Check And Correct Library Message"
		return
        }
	
	set lMessage [concat "(capCheckLibLaunch::doCorrect) Backup file has been saved as " $lBackupFile]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
					
	set lMessage [concat "(capCheckLibLaunch::doCorrect) Log file has been saved as " $::capCheckLibLaunch::mLogPath]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	
	#tk_messageBox -type ok -message [concat "Backup file has been saved as " $lBackupFile] -title "Check And Correct Library Message"
	
	#launch log file if succeeds
	if {[file exists $::capCheckLibLaunch::mLogPath] ==1 } {
		catch {Shell $::capCheckLibLaunch::mLogPath}
	}
	destroy $::capCheckLibLaunch::mForm
}

proc capCheckLibLaunch::doCancel {  } {
	
	destroy $::capCheckLibLaunch::mForm
}

proc capCheckLibLaunch::doChooseLibFile {  } {
	set types {
	    {{Capture Library}       {.olb}        }
	    {{Capture Design}      {.dsn}        }
	}

	set filename [tk_getOpenFile -filetypes $types]
	set ::capCheckLibLaunch::mLibPath $filename
}

proc capCheckLibLaunch::doChooseLogFile {  } {
	set types {
	    {{Log File}       {.log}        }
	}

	set filename [tk_getSaveFile -filetypes $types]
	set ::capCheckLibLaunch::mLogPath $filename
}


proc ::capCheckLibLaunch::init { } {
    
    set lForm .capCheckLib
    
    if { "" == [info commands $lForm]} {
	    capAppUtils::capTopLevel $lForm
	    capCheckLibLaunch::ui $lForm
	    capAppUtils::setWindowSize $lForm 500 130 500 130
	    wm title $lForm "Check and Correct Library"
	    capAppUtils::autoAdoptWindow $lForm
    }
    
    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
}

proc ::capCheckLibLaunch::launch { args } {
    if { [catch {package require capLibUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capCheckLibLaunch::launch) capLibUtil package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capCheckLibLaunch::init
	}
}
