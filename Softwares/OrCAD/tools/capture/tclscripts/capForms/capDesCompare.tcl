#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDesCompare.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package require Capture 16.5.0
package provide capDesCompare 1.0

namespace eval capDesCompare {
	variable mForm
	variable mDes1Path
	variable mDes2Path
}

proc capDesCompare::ui {pForm} {
    
    set ::capDesCompare::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
    variable lLabelDesign1Path [label $pForm.lLabelDesign1Path \
	    -text "Design 1 Path"]
	    
    set lState "normal"
    
    variable lDes1Path [entry $pForm.lDes1Path \
	    -textvariable "::capDesCompare::mDes1Path" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnDes1Path [button $pForm.lBtnDes1Path \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capDesCompare::doChooseDesign1File" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lLabelDes2Path [label $pForm.lLabelDes2Path \
	    -text "Design 2 Path"]
	    
    set lState "normal"
    
    variable lDes2Path [entry $pForm.lDes2Path \
	    -textvariable "::capDesCompare::mDes2Path" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnDes2Path [button $pForm.lBtnDes2Path \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capDesCompare::doChooseDesign2File" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lBtnCompare [button $pForm.lBtnCompare \
	    -command "capDesCompare::doCompare" \
	    -state $lState \
	    -text "Compare"]
    
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capDesCompare::doCancel" \
	    -text "Cancel"]
    
    # Geometry Management

    grid $pForm.lLabelDesign1Path -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lDes1Path -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnDes1Path -in $pForm -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelDes2Path -in $pForm -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lDes2Path -in $pForm -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnDes2Path -in $pForm -row 2 -column 3 \
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
    grid $pForm.lBtnCompare -in $pForm.lLabelFrameButtons -row 1 -column 1 \
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


proc capDesCompare::doCompare {  } {
	
	if { $::capDesCompare::mDes1Path == "" || $::capDesCompare::mDes2Path == ""} {
		tk_messageBox -type ok -message "Please specify the source and target design paths correctly" -title "Compare Designs Message"
		return
	}
	
	if {[file exists $::capDesCompare::mDes1Path] !=1 } {
		tk_messageBox -type ok -message "Please specify the source and target design paths correctly" -title "Compare Designs Message"
		return
	}
	
	#set lBackupFile [concat $::capDesCompare::mDes2Path[pid][clock clicks]]
	#if {[catch {file copy -force $::capDesCompare::mDes2Path $lBackupFile}] } {
		#tk_messageBox -type ok -message [concat "Unable to save Backup file " $lBackupFile] -title "Compare Designs Message"
		#return
	#} 
	
	
	if { [catch {eval svsDiffDesigns $::capDesCompare::mDes1Path $::capDesCompare::mDes2Path}] } {
            tk_messageBox -type ok -message "Dsign Compare failed" -title "Compare Designs Message"
		return
        }
	
	#set lMessage [concat "(capDesCompare::doCompare) Backup file has been saved as " $lBackupFile]
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
					
	#tk_messageBox -type ok -message [concat "Backup file has been saved as " $lBackupFile] -title "Check And Correct Library Message"
	
	#launch log file if succeeds
	if {[file exists $::capDesCompare::mDes2Path] ==1 } {
		catch {Shell $::capDesCompare::mDes2Path}
	}
	destroy $::capDesCompare::mForm
}

proc capDesCompare::doCancel {  } {
	
	destroy $::capDesCompare::mForm
}

proc capDesCompare::doChooseDesign1File {  } {
	set types {
	    {{Capture Design}      {.dsn}        }
	}

	set filename [tk_getOpenFile -filetypes $types]
	set ::capDesCompare::mDes1Path $filename
}

proc capDesCompare::doChooseDesign2File {  } {
	set types {
	    {{Capture Design}      {.dsn}        }
	}

	#set filename [tk_getSaveFile -filetypes $types]
	set filename [tk_getOpenFile -filetypes $types]
	set ::capDesCompare::mDes2Path $filename
}


proc ::capDesCompare::init { } {
    
    set lForm .capCheckLib
    
    if { "" == [info commands $lForm]} {
	    capAppUtils::capTopLevel $lForm
	    capDesCompare::ui $lForm
	    capAppUtils::setWindowSize $lForm 500 130 500 130
	    wm title $lForm "Compare and merge Capture Designs"
	    capAppUtils::autoAdoptWindow $lForm
    }
    
    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
}

proc ::capDesCompare::launch { args } {
    if { [catch {package require capLibUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capDesCompare::launch) capLibUtil package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capDesCompare::init
	}
}
