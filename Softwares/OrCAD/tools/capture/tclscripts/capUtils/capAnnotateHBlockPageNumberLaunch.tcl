#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAnnotateHBlockPageNumberLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capAnnotateHBlockPageNumberLaunch 1.0

namespace eval capAnnotateHBlockPageNumberLaunch {
	variable mForm
	variable mDesignPath
}

proc capAnnotateHBlockPageNumberLaunch::ui {pForm} {
    
    set ::capAnnotateHBlockPageNumberLaunch::mForm $pForm
    
	# Frame to hold the 'Ok' and 'Cancel' button
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
	# For Static Text 'Design Path'
    variable lLabelDesignPath [label $pForm.lLabelDesignPath \
	    -text "Design Path"]
	    
    set lState "normal"
    
	# For Text Box for 'Design Path'
    variable lDesignPath [entry $pForm.lDesignPath \
	    -textvariable "::capAnnotateHBlockPageNumberLaunch::mDesignPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
	# Browse Button for 'Design Path'
    variable lBtnDesignPath [button $pForm.lBtnDesignPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capAnnotateHBlockPageNumberLaunch::doChooseDesignFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    set lState "normal"
    
	# 'Ok' button
    variable lBtnAnnotate [button $pForm.lBtnAnnotate \
	    -command "capAnnotateHBlockPageNumberLaunch::doAnnotate" \
	    -state $lState \
	    -text "Ok"]
    
	# 'Cancel' Button
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capAnnotateHBlockPageNumberLaunch::doCancel" \
	    -text "Close"]
    
    # Geometry Management

	# The static text label "Design Path"
    grid $pForm.lLabelDesignPath -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
	
	# The Text box for "Design Path"
    grid $pForm.lDesignPath -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
	
	# The browse button for Design Path
    grid $pForm.lBtnDesignPath -in $pForm -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
	
	# The label frame to put the buton 'Ok', 'Cancel
    grid $pForm.lLabelFrameButtons -in $pForm -row 3 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
		
	# For 'Ok' button inside label frame
    grid $pForm.lBtnAnnotate -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
		
	# For 'Cancel' button inside label frame
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

proc capAnnotateHBlockPageNumberLaunch::doAnnotate {  } {
	
	if { $::capAnnotateHBlockPageNumberLaunch::mDesignPath == "" } {
		tk_messageBox -type ok -message "Please specify the Design file path" -title "Annotate Page Number H-Block Message"
		return
	}
	
	if {[file exists $::capAnnotateHBlockPageNumberLaunch::mDesignPath] !=1 } {
		tk_messageBox -type ok -message "Please specify the Design file path" -title "Annotate Page Number H-Block Message"
		return
	}
	
	set lBackupFile [concat $::capAnnotateHBlockPageNumberLaunch::mDesignPath[pid][clock clicks]]
	if {[catch {file copy -force $::capAnnotateHBlockPageNumberLaunch::mDesignPath $lBackupFile}] } {
		tk_messageBox -type ok -message [concat "Unable to save Backup file " $lBackupFile] -title "Annotate Page Number H-Block Message"
		return
	} 
	
	
	if { [catch {eval ::capAnnotateHBlockPageNumber::AnnotateHBlockPageNumber $::capAnnotateHBlockPageNumberLaunch::mDesignPath}]} {
            tk_messageBox -type ok -message "Annotation Of Page Number H Block failed" -title "Annotate Page Number H-Block Message"
		return
    }
	
	set lMessage [concat "(capAnnotateHBlockPageNumberLaunch::doAnnotate) Backup file has been saved as " $lBackupFile]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
					
	#launch log file if succeeds
	#destroy $::capAnnotateHBlockPageNumberLaunch::mForm
}


proc capAnnotateHBlockPageNumberLaunch::doCancel {  } {
	
	destroy $::capAnnotateHBlockPageNumberLaunch::mForm
}

proc capAnnotateHBlockPageNumberLaunch::doChooseDesignFile {  } {
	set types {
	    {{Capture Design}      {.dsn}        }
	}

	set filename [tk_getOpenFile -filetypes $types]
	set ::capAnnotateHBlockPageNumberLaunch::mDesignPath $filename
}

proc ::capAnnotateHBlockPageNumberLaunch::init { } {
    set lForm .capAnnotateHBlock
    
    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capAnnotateHBlockPageNumberLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 500 100 500 100
	wm title $lForm "Annotate H-Block Page Number"
	capAppUtils::autoAdoptWindow $lForm
    }
    
    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
}

proc ::capAnnotateHBlockPageNumberLaunch::launch { args } {
    if { [catch {package require capAnnotateHBlockPageNumber}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capAnnotateHBlockPageNumberLaunch::launch) capAnnotateHBlockPageNumber package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capAnnotateHBlockPageNumberLaunch::init
	}
}