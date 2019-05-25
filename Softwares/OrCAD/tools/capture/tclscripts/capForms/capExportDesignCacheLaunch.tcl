#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capExportDesignCacheLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capExportDesignCacheLaunch 1.0

namespace eval capExportDesignCacheLaunch {
	variable mForm
	variable mLibPath
	variable mLogPath
}

proc capExportDesignCacheLaunch::ui {pForm} {
    
    set ::capExportDesignCacheLaunch::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
    variable lLabelLibraryPath [label $pForm.lLabelLibraryPath \
	    -text "Library Folder Path"]
	    
    set lState "normal"
    
    variable lLibPath [entry $pForm.lLibPath \
	    -textvariable "::capExportDesignCacheLaunch::mLibPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLibPath [button $pForm.lBtnLibPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capExportDesignCacheLaunch::doChooseLibFile" \
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
	    -textvariable "::capExportDesignCacheLaunch::mLogPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnLogPath [button $pForm.lBtnLogPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capExportDesignCacheLaunch::doChooseLogFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lBtnExport [button $pForm.lBtnExport \
	    -command "capExportDesignCacheLaunch::doExport" \
	    -state $lState \
	    -text "Export"]
    

    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capExportDesignCacheLaunch::doCancel" \
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
    grid $pForm.lBtnExport -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"

    grid $pForm.lBtnCancel -in $pForm.lLabelFrameButtons -row 1 -column 2 \
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
   
}

proc capExportDesignCacheLaunch::doExport { } {
	
	if { $::capExportDesignCacheLaunch::mLibPath == "" || $::capExportDesignCacheLaunch::mLogPath == ""} {
		tk_messageBox -type ok -message "Please specify the Library folder path and Log file path correctly" -title "Export Design Cache Message"
		return
	}
	
	
	
	if { [catch {eval ::capExportDesignCache::export_design_cache $::capExportDesignCacheLaunch::mLibPath $::capExportDesignCacheLaunch::mLogPath}] } {
            tk_messageBox -type ok -message "Export Design Cache failed" -title "Export Design Cache Message"
		return
        }
	
	set lMessage [concat "(capExportDesignCacheLaunch::export_design_cache) Log file has been saved as " $::capExportDesignCacheLaunch::mLogPath]
	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	DboState_WriteToSessionLog $lMessageStr
	
	destroy $::capExportDesignCacheLaunch::mForm
	
	#launch log file if succeeds
	if {[file exists $::capExportDesignCacheLaunch::mLogPath] ==1 } {
		catch {Shell $::capExportDesignCacheLaunch::mLogPath}
	}
}



proc capExportDesignCacheLaunch::doCancel {  } {
	
	destroy $::capExportDesignCacheLaunch::mForm
}

proc capExportDesignCacheLaunch::doChooseLibFile {  } {
	set types {
	    {{Capture Library}       {.olb}        }
	    {{Capture Design}      {.dsn}        }
	}

	set filename [tk_chooseDirectory]
	set ::capExportDesignCacheLaunch::mLibPath $filename
}

proc capExportDesignCacheLaunch::doChooseLogFile {  } {
	set types {
	    {{Log File}       {.log}        }
	}

	set filename [tk_getSaveFile -filetypes $types]
	set ::capExportDesignCacheLaunch::mLogPath $filename
}


proc ::capExportDesignCacheLaunch::init { } {
    
    set lForm .capExportDesignCache
    capAppUtils::capTopLevel $lForm
    wm title $lForm "Export Design Cache"
    capExportDesignCacheLaunch::ui $lForm
    wm resizable $lForm 0 0
    capAppUtils::autoAdoptWindow $lForm
}

proc ::capExportDesignCacheLaunch::launch { args } {
    if { [catch {package require capExportDesignCache}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capExportDesignCacheLaunch::launch) capExportDesignCache package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capExportDesignCacheLaunch::init
	}
}
