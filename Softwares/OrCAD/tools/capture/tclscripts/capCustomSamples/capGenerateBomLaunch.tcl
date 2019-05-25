
package require capAppUtils
package provide capGenerateBOMLaunch 1.0

namespace eval capGenerateBOMLaunch {
	variable mForm
}

proc capGenerateBOMLaunch::ui {pForm} {
    
    set ::capGenerateBOMLaunch::mForm $pForm
    
    variable lLabelOutDir [label $pForm.lLabelOutDir \
	    -text "Output Directory"]
    
    variable lLabelPCBNumber [label $pForm.lLabelPCBNumber \
	    -text "PCB Number"]
    
    variable lLabelRevision [label $pForm.lLabelRevision \
	    -text "Revision"]
    
    variable lLabelFindNumberInitialIndex [label $pForm.lLabelFindNumberInitialIndex \
	    -text "Find Number Initial Index"]
    
    variable lTextOutDir [entry $pForm.lTextOutDir \
	    -textvariable "::capGenerateBOMUtil::mOutDir" \
	    -width 20 \
	    ]
    
    variable lTextPCBNumber [entry $pForm.lTextPCBNumber \
	    -textvariable "::capGenerateBOMUtil::mPCBNumber" \
	    -width 20 \
	    ]
    
    variable lTextRevision [entry $pForm.lTextRevision \
	    -textvariable "::capGenerateBOMUtil::mRevision" \
	    -width 20 \
	    ]
     
    variable lTextFindNumberInitialIndex [entry $pForm.lTextFindNumberInitialIndex \
	    -textvariable "::capGenerateBOMUtil::mFindNumber" \
	    -width 20 \
	    ]
     
    variable lBtnOutDir [button $pForm.lBtnOutDir \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "::capGenerateBOMLaunch::chooseDir" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lLabelFrameOKCancel [labelframe $pForm.lLabelFrameOKCancel ]
    
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "::capGenerateBOMLaunch::doCancel" \
	    -text "Cancel"]
    
    variable lBtnOK [button $pForm.lBtnOK \
	    -command "::capGenerateBOMLaunch::doOk" \
	    -text "OK"]
    
    # Geometry Management

    grid $pForm.lLabelOutDir -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextOutDir -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnOutDir -in $pForm -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelPCBNumber -in $pForm -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextPCBNumber -in $pForm -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelRevision -in $pForm -row 3 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextRevision -in $pForm -row 3 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFindNumberInitialIndex -in $pForm -row 4 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextFindNumberInitialIndex -in $pForm -row 4 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameOKCancel -in $pForm -row 5 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnOK -in $pForm.lLabelFrameOKCancel -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnCancel -in $pForm.lLabelFrameOKCancel -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "e"
    
    # Resize Behavior
    grid rowconfigure $pForm 1 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 9 -pad 0
    grid rowconfigure $pForm 3 -weight 0 -minsize 11 -pad 0
    grid rowconfigure $pForm 4 -weight 0 -minsize 11 -pad 0
    grid rowconfigure $pForm 5 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 40 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 228 -pad 0
    grid columnconfigure $pForm 3 -weight 0 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameOKCancel 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 2 -weight 0 -minsize 56 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 3 -weight 0 -minsize 56 -pad 0
}

proc capGenerateBOMLaunch::chooseDir { } {
	set dir [tk_chooseDirectory \
        -initialdir $::capGenerateBOMUtil::mOutDir -title "Choose output directory"]
	set ::capGenerateBOMUtil::mOutDir $dir
}

proc capGenerateBOMLaunch::doCancel { } {
        #capGenerateBOMLaunch::dumpOptionValues
	
	destroy $::capGenerateBOMLaunch::mForm
}

proc capGenerateBOMLaunch::doOk {  } {
	if { [::capGenerateBOMLaunch::checkEnviroment] != 1 } {
		return
	}
	
	if { [::capGenerateBOMLaunch::checkWritableOutDir] != 1 } {
		return
	}
	 
	if { [catch {eval ::capGenerateBOMUtil::generateBOM $::capGenerateBOMUtil::mPCBNumber $::capGenerateBOMUtil::mRevision $::capGenerateBOMUtil::mFindNumber }] } {
            puts "ERROR : $::errorInfo"
        }
	 
	destroy $::capGenerateBOMLaunch::mForm
}

proc ::capGenerateBOMLaunch::checkEnviroment { } {
    return 1
 }
    
    
proc ::capGenerateBOMLaunch::checkWritableOutDir { } {
    if { [file writable $::capGenerateBOMUtil::mOutDir] == 0} {
	tk_messageBox -type ok -message [concat "The output directory is readonly. Please specify the output directory having write permission"] -title "Export GenerateBOM Message"
	return 0
    }
    
   return 1
}

proc ::capGenerateBOMLaunch::init { } {
    
    if { [::capGenerateBOMLaunch::checkEnviroment] != 1 } {
	return
    }
    
    set lResult [::capGenerateBOMUtil::setOptionValues]
    if { $lResult == 0} {
	tk_messageBox -type ok -message "There is no active design" -title "GenerateBOM Message"
	return
    }
    
    set lForm .capGenerateBOM
    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capGenerateBOMLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 500 120 500 120
	wm title $lForm "Generate Custom BOM"
	capAppUtils::autoAdoptWindow $lForm
    }


    if { 0 == [winfo ismapped $lForm]} {
	wm deiconify $lForm
    }

    #set lForm .capGenerateBOM
    #capAppUtils::capTopLevel $lForm
    #wm title $lForm "Generate Custom BOM"
    #capGenerateBOMLaunch::ui $lForm
    #wm resizable $lForm 0 0
    #capAppUtils::autoAdoptWindow $lForm
}

proc ::capGenerateBOMLaunch::launch {args} {
    if { [catch {package require capGenerateBOMUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "capGenerateBOMUtil not found. Custom BOM will not be generated"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capGenerateBOMLaunch::init
	}
}

proc ::capGenerateBOMLaunch::addMenu { args } {
	catch {ui::AddAccessoryMenu "Custom BOM " "Generate" "::capGenerateBOMLaunch::launch"}
	catch {AddAccessoryMenu "Custom BOM " "Generate" "::capGenerateBOMLaunch::launch"}
}

proc ::capGenerateBOMLaunch::capMenuTrue { args } {
	return 1
}

proc ::capGenerateBOMLaunch::register {args} {
    if { [catch {package require Tk 8.4}] } {
       puts "Tk not found. Menu item for Generate Custom BOM will not be created"
    } else {
        wm withdraw .
        #RegisterAction "_cdnCapTclAddDesignCustomMenu" "::capGenerateBOMLaunch::capMenuTrue" "" "::capGenerateBOMLaunch::addMenu" ""
		RegisterAction "Generate Custom BOM" "::capGenerateBOMLaunch::capMenuTrue" "" "::capGenerateBOMLaunch::launch" "PM"
    }        
}

::capGenerateBOMLaunch::register