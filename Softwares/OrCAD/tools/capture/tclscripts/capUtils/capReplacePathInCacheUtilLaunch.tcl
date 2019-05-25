#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAnnotateHBlockLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capReplacePathInCacheUtilLaunch 1.0

namespace eval capReplacePathInCacheUtilLaunch {
	variable mForm
	variable mOldPathRootFolder
	variable mNewPathRootFolder
	variable mDesignIgnore
}

proc capReplacePathInCacheUtilLaunch::ui {pForm} {
    
    set ::capReplacePathInCacheUtilLaunch::mForm $pForm
    
	# Frame to hold the 'Ok' and 'Cancel' button
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
	# For Static Text 'Old Path'
    variable lLabelOldPath [label $pForm.lLabelOldPath \
	    -text "Old Path"]
		
	# For Static Text 'New Path'
    variable lLabelNewPath [label $pForm.lLabelNewPath \
	    -text "New Path"]
	    
    set lState "normal"
    
	# For Text Box for 'Old Path'
    variable lOldPath [entry $pForm.lOldPath \
	    -textvariable "::capReplacePathInCacheUtilLaunch::mOldPathRootFolder" \
	    -state $lState \
	    -width 40 \
	    ]
		
	# For Text Box for 'New Path'
    variable lNewPath [entry $pForm.lNewPath \
	    -textvariable "::capReplacePathInCacheUtilLaunch::mNewPathRootFolder" \
	    -state $lState \
	    -width 40 \
	    ]
    
	set lState "normal"
	
	#The check button
	variable lCheckBtnDesignIgnore [checkbutton $pForm.lCheckBtnDesignIgnore \
		-variable ::capReplacePathInCacheUtilLaunch::mDesignIgnore -text "Replace Also .DSN Path" -anchor w]
    
		# For Static Text 'Old Path'
    variable lLabelBackslash [label $pForm.lLabelBackslash \
	    -text "Use double backslashes in path. Paths are also case-sensitive"]
		
	# 'Check' button
    variable lBtnReplaceCachePathCheck [button $pForm.lBtnReplaceCachePathCheck \
	    -command "capReplacePathInCacheUtilLaunch::ReplaceCachePathCheck" \
	    -state $lState \
	    -text "Check"]
		
	# 'Correct' button
	variable lBtnReplaceCachePathCorrect [button $pForm.lBtnReplaceCachePathCorrect \
	    -command "capReplacePathInCacheUtilLaunch::ReplaceCachePathCorrect" \
	    -state $lState \
	    -text "Replace"]
    
	# 'Cancel' Button
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capReplacePathInCacheUtilLaunch::doCancel" \
	    -text "Cancel"]
    
    # Geometry Management

	# The static text label "Old Path"
    grid $pForm.lLabelOldPath -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
	
	# The Text box for "New Path"
    grid $pForm.lOldPath -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
	
	# The static text label "New Path"
    grid $pForm.lLabelNewPath -in $pForm -row 3 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
		
	# The Text box for "New Path"
    grid $pForm.lNewPath -in $pForm -row 3 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
		
	# The check button for design ignore
	grid $pForm.lCheckBtnDesignIgnore -in $pForm -row 5 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky ""
	
	
	grid $pForm.lLabelBackslash -in $pForm -row 5 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky ""
	
	# The label frame to put the buton 'Ok', 'Cancel
    grid $pForm.lLabelFrameButtons -in $pForm -row 7 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
		
	# For 'Check' button inside label frame
    grid $pForm.lBtnReplaceCachePathCheck -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
		
	# For 'Correct' button inside label frame
    grid $pForm.lBtnReplaceCachePathCorrect -in $pForm.lLabelFrameButtons -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
		
	# For 'Cancel' button inside label frame
    grid $pForm.lBtnCancel -in $pForm.lLabelFrameButtons -row 1 -column 4 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "e"
    
    # Resize Behavior
    grid rowconfigure $pForm 1 -weight 0 -minsize 19 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 19 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 40 -pad 0
    grid columnconfigure $pForm 3 -weight 0 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
}

proc capReplacePathInCacheUtilLaunch::ReplaceCachePathCorrect {  } {
	
	if { $::capReplacePathInCacheUtilLaunch::mOldPathRootFolder == "" } {
		tk_messageBox -type ok -message "Please specify the file path folder" -title "Replace Path In Design Cache"
		return
	}
	
	if {[file exists $::capReplacePathInCacheUtilLaunch::mNewPathRootFolder] !=1 } {
		tk_messageBox -type ok -message "Please specify the new file path folder" -title "Replace Path In Design Cache"
		return
	}
	
	if { [catch {eval ::capReplacePathInCacheUtil::replace $::capReplacePathInCacheUtilLaunch::mOldPathRootFolder $::capReplacePathInCacheUtilLaunch::mNewPathRootFolder $::capReplacePathInCacheUtilLaunch::mDesignIgnore 1}]} {
            tk_messageBox -type ok -message "Replace Path For Design Cache Failed" -title "Replace Path In Design Cache"
		return
    }
	
	#launch log file if succeeds
	#destroy $::capReplacePathInCacheUtilLaunch::mForm
}

proc capReplacePathInCacheUtilLaunch::ReplaceCachePathCheck {  } {
	
	if { $::capReplacePathInCacheUtilLaunch::mOldPathRootFolder == "" } {
		tk_messageBox -type ok -message "Please specify the file path folder" -title "Replace Path In Design Cache"
		return
	}
	
	if {[file exists $::capReplacePathInCacheUtilLaunch::mNewPathRootFolder] !=1 } {
		tk_messageBox -type ok -message "Please specify the new file path folder" -title "Replace Path In Design Cache"
		return
	}
	
	if { [catch {eval ::capReplacePathInCacheUtil::replace $::capReplacePathInCacheUtilLaunch::mOldPathRootFolder $::capReplacePathInCacheUtilLaunch::mNewPathRootFolder $::capReplacePathInCacheUtilLaunch::mDesignIgnore 0}]} {
            tk_messageBox -type ok -message "Replace Path For Design Cache Failed" -title "Replace Path In Design Cache"
		return
    }
	
	#launch log file if succeeds
	#destroy $::capReplacePathInCacheUtilLaunch::mForm
}


proc capReplacePathInCacheUtilLaunch::doCancel {  } {
	
	destroy $::capReplacePathInCacheUtilLaunch::mForm
}

proc ::capReplacePathInCacheUtilLaunch::init { } {
    set lForm .capReplacePathInCacheForm
    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capReplacePathInCacheUtilLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 500 130 500 130
	wm title $lForm "Replace Path In Design Cache"
	capAppUtils::autoAdoptWindow $lForm
    }

    if { 0 == [winfo ismapped $lForm]} {
	wm deiconify $lForm
    }
}

proc ::capReplacePathInCacheUtilLaunch::launch { args } {
    if { [catch {package require capReplacePathInCacheUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capReplacePathInCacheUtilLaunch::launch) ccapReplacePathInCacheUtil package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capReplacePathInCacheUtilLaunch::init
	}
}