#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capLibPropLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capLibPropLaunch 1.0

namespace eval capLibPropLaunch {
    variable mForm
    variable mLibPath
    variable mLogPath
    variable mPropName
    variable mPropValue
    variable mDisProp
    variable mRotation
}

proc capLibPropLaunch::ui {pForm} {
    
    set ::capLibPropLaunch::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
    variable lLabelLibraryPath [label $pForm.lLabelLibraryPath \
	    -text "Library Path"]
	    
    set lState "normal"
    
    variable lLibPath [entry $pForm.lLibPath \
	    -textvariable "::capLibPropLaunch::mLibPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLibPath [button $pForm.lBtnLibPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capLibPropLaunch::doChooseLibFile" \
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
	    -textvariable "::capLibPropLaunch::mLogPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLogPath [button $pForm.lBtnLogPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capLibPropLaunch::doChooseLogFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]

    variable lLabelPropName [label $pForm.lLabelPropName \
	    -text "Prop Name"]

    variable lPropName [entry $pForm.lPropName \
	    -textvariable "::capLibPropLaunch::mPropName" \
	    -state $lState \
	    -width 40 \
	    ]

    variable lLabelPropValue [label $pForm.lLabelPropValue \
	    -text "Prop Value"]

    variable lPropValue [entry $pForm.lPropValue \
	    -textvariable "::capLibPropLaunch::mPropValue" \
	    -state $lState \
	    -width 40 \
	    ]


    variable lLabelFrameDisProp [labelframe $pForm.lLabelFrameDisProp ]

    variable lLabelDisProp [label $pForm.lLabelDisProp \
	    -text "Display Type"]

    variable lDisProp [tk_optionMenu $pForm.lDisProp \
	     "::capLibPropLaunch::mDisProp" "Value Only" "Name and Value" "Name Only" "Both If Value exists" \
	     ] 


    variable lLabelRotation [label $pForm.lLabelRotation \
	    -text "Rotation"]

    variable lRotation [tk_optionMenu $pForm.lRotation \
	     "::capLibPropLaunch::mRotation" 0 90 180 270 \
	     ] 
    
    
    variable lBtnAdd [button $pForm.lBtnAdd \
	    -command "capLibPropLaunch::doAdd" \
	    -state $lState \
	    -text "Add Property"]
    
    variable lBtnDelete [button $pForm.lBtnDelete \
	    -command "capLibPropLaunch::doDelete" \
	    -state $lState \
	    -text "Delete Property"]
    
    variable lBtnDisplay [button $pForm.lBtnDisplay \
	    -command "capLibPropLaunch::doDisplay" \
	    -text "Display"]
    
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
    grid $pForm.lLabelPropName -in $pForm -row 3 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPropName -in $pForm -row 3 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelPropValue -in $pForm -row 4 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPropValue -in $pForm -row 4 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameButtons -in $pForm -row 7 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lLabelFrameDisProp -in $pForm -row 5 -column 1 \
	    -columnspan 4 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 2 \
	    -sticky "news"
    #grid $pform.lBut -in . -row 5 -column 1 -columnspan 2
    grid $pForm.lLabelDisProp -in $pForm.lLabelFrameDisProp -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lDisProp -in $pForm.lLabelFrameDisProp -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLabelRotation -in $pForm.lLabelFrameDisProp -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lRotation -in $pForm.lLabelFrameDisProp -row 1 -column 4 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnAdd -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnDelete -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnDisplay -in $pForm.lLabelFrameButtons -row 1 -column 3 \
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

proc capLibPropLaunch::doAdd { } {
	
	if { $::capLibPropLaunch::mLibPath == "" || $::capLibPropLaunch::mLogPath == ""} {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
		return
	}
	
	if {[file exists $::capLibPropLaunch::mLibPath] !=1 } {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
		return
	}
	
	
	
	if { [catch {eval ::capLibPropUtil::add_prop_lib $::capLibPropLaunch::mLibPath $::capLibPropLaunch::mLogPath $::capLibPropLaunch::mPropName $::capLibPropLaunch::mPropValue}] } {
            tk_messageBox -type ok -message "Library Add property failed" -title "Library Add Property Message"
		return
        }
	
	set lMessage [concat "(capLibPropLaunch::add_prop_lib) Log file has been saved as " $::capLibPropLaunch::mLogPath]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	
	destroy $::capLibPropLaunch::mForm
	
	#launch log file if succeeds
	# if {[file exists $::capLibPropLaunch::mLogPath] ==1 } {
	# 	catch {Shell $::capLibPropLaunch::mLogPath}
	# }
}

proc capLibPropLaunch::doDelete {  } {
	
	if { $::capLibPropLaunch::mLibPath == "" || $::capLibPropLaunch::mLogPath == ""} {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
		return
	}
	
	if {[file exists $::capLibPropLaunch::mLibPath] !=1 } {
		tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
		return
	}
	
	set lBackupFile [concat $::capLibPropLaunch::mLibPath[pid][clock clicks]]
	if {[catch {file copy -force $::capLibPropLaunch::mLibPath $lBackupFile}] } {
		tk_messageBox -type ok -message [concat "Unable to save Backup file " $lBackupFile] -title "Add/Del Property to all parts in Library"
		return
	} 
	
	
	if { [catch {eval ::capLibPropUtil::del_prop_lib $::capLibPropLaunch::mLibPath $::capLibPropLaunch::mLogPath $::capLibPropLaunch::mPropName}] } {
            tk_messageBox -type ok -message "Library correction failed" -title "Add/Del Property to all parts in Library"
		return
        }
	
	set lMessage [concat "(capLibPropLaunch::del_prop_name) Backup file has been saved as " $lBackupFile]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
					
	set lMessage [concat "(capLibPropLaunch::del_prop_lib) Log file has been saved as " $::capLibPropLaunch::mLogPath]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	
	destroy $::capLibPropLaunch::mForm
	
	#launch log file if succeeds
	# if {[file exists $::capLibPropLaunch::mLogPath] ==1 } {
	# 	catch {Shell $::capLibPropLaunch::mLogPath}
	# }
	
}

proc capLibPropLaunch::doDisplay {  } {
	
    if { $::capLibPropLaunch::mLibPath == "" || $::capLibPropLaunch::mLogPath == ""} {
	tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
	return
    }
    
    if {[file exists $::capLibPropLaunch::mLibPath] !=1 } {
	tk_messageBox -type ok -message "Please specify the Library file path and Log file path correctly" -title "Add/Del Property to all parts in Library"
	return
    }

    set disType 0
    if {$::capLibPropLaunch::mDisProp=="Do Not Display"} {
	set disType 0
    } elseif {$::capLibPropLaunch::mDisProp=="Value Only"} {
	set disType 1
    } elseif {$::capLibPropLaunch::mDisProp=="Name and Value"} {
	set disType 2
    } elseif {$::capLibPropLaunch::mDisProp=="Name Only"} {
	set disType 3
    } elseif {$::capLibPropLaunch::mDisProp=="Both If Value exists"} {
	set disType 4
    } 

    set rotation 0
    if {$::capLibPropLaunch::mRotation=="90"} {
	set rotation 1
    } elseif {$::capLibPropLaunch::mRotation=="180"} {
	set rotation 2
    } elseif {$::capLibPropLaunch::mRotation=="270"} {
	set rotation 3
    }  
    
    if { [catch {eval ::capLibPropUtil::make_display_prop $::capLibPropLaunch::mLibPath $::capLibPropLaunch::mLogPath $::capLibPropLaunch::mPropName $disType $rotation}] } {
	tk_messageBox -type ok -message "Library Display Property failed" -title "Library Display Property Message"
	return
    }
    
    set lMessage [concat "(capLibPropLaunch::make_display_prop) Log file has been saved as " $::capLibPropLaunch::mLogPath]
    set lMessageStr [DboTclHelper_sMakeCString $lMessage]
    DboState_WriteToSessionLog $lMessageStr
    
    destroy $::capLibPropLaunch::mForm
    
    # #launch log file if succeeds
    # if {[file exists $::capLibPropLaunch::mLogPath] ==1 } {
    # 	catch {Shell $::capLibPropLaunch::mLogPath}
    # }
}

proc capLibPropLaunch::doChooseLibFile {  } {
	set types {
	    {{Capture Library}       {.olb}        }
	    {{Capture Design}      {.dsn}        }
	}

	set filename [tk_getOpenFile -filetypes $types]
	set ::capLibPropLaunch::mLibPath $filename
}

proc capLibPropLaunch::doChooseLogFile {  } {
	set types {
	    {{Log File}       {.log}        }
	}

	set filename [tk_getSaveFile -filetypes $types]
	set ::capLibPropLaunch::mLogPath $filename
}


proc ::capLibPropLaunch::init { } {
    
    set lForm .capLibProp
    capAppUtils::capTopLevel $lForm
    wm title $lForm "Add and Delete property"
    capLibPropLaunch::ui $lForm
    wm resizable $lForm 0 0
    capAppUtils::autoAdoptWindow $lForm
}


proc ::capLibPropLaunch::launch { args } {
    if { [catch {package require capLibPropUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capLibPropLaunch::launch) capLibPropUtil package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capLibPropLaunch::init
    }
}
