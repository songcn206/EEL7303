#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCustomizePageLaunch.tcl
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capCustomizePageLaunch 1.0

namespace eval capCustomizePageLaunch {
	variable mForm
	
	variable mEnablePageCustomization
	
	variable mTCLScriptPath
	variable mPagePreCreate
	variable mPagePostCreate
	variable mPageSizeChange
}

proc capCustomizePageLaunch::ui {pForm} {
    
    set ::capCustomizePageLaunch::mForm $pForm
    
    variable lLabelFrameEnablePageCustomization [labelframe $pForm.lLabelFrameEnablePageCustomization]
    variable lLabelFrameTCLScriptPath [labelframe $pForm.lLabelFrameTCLScriptPath]
    variable lLabelFrameTCLProcs [labelframe $pForm.lLabelFrameTCLProcs \
						-padx 2 \
						-pady 2 \
						-text "TCL Callback Procedures"]
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons]
    
    variable lLabelEnablePageCustomization [label $pForm.lLabelEnablePageCustomization \
	    -text "Enable Page Customization"]
	    
    variable lCheckBtnEnablePageCustomization [checkbutton $pForm.lCheckBtnEnablePageCustomization \
		-variable ::capCustomizePageLaunch::mEnablePageCustomization \
		-command ::capCustomizePageLaunch::onCheckBtnEnablePageCustomization]
    
    variable lLabelTCLScriptPath [label $pForm.lLabelTCLScriptPath \
	    -text "TCL Script Path"]
	    
    set lState "normal"
    
    variable lTCLScriptPath [entry $pForm.lTCLScriptPath \
	    -textvariable "::capCustomizePageLaunch::mTCLScriptPath" \
	    -state $lState \
	    -width 40 \
	    ]
    
    variable lBtnTCLScriptPath [button $pForm.lBtnTCLScriptPath \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capCustomizePageLaunch::doChooseTCLScriptFile" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lLabelPagePreCreate  [label $pForm.lLabelPagePreCreate \
	    -text "On Page Pre-create"]
	    
    variable lPagePreCreate [entry $pForm.lPagePreCreate \
	    -textvariable "::capCustomizePageLaunch::mPagePreCreate" \
	    -state "normal" \
	    -width 40 \
	    ]
    
     variable lLabelPagePostCreate  [label $pForm.lLabelPagePostCreate \
	    -text "On Page Post-create"]
	    
     variable lPagePostCreate [entry $pForm.lPagePostCreate \
	    -textvariable "::capCustomizePageLaunch::mPagePostCreate" \
	    -state "normal" \
	    -width 40 \
	    ]
   
     variable lLabelPageSizeChange  [label $pForm.lLabelPageSizeChange \
	    -text "On Page Size Change"]
	    
     variable lPageSizeChange [entry $pForm.lPageSizeChange \
	    -textvariable "::capCustomizePageLaunch::mPageSizeChange" \
	    -state "normal" \
	    -width 40 \
	    ]
   
     variable lBtnOk [button $pForm.lBtnOk \
	    -command "capCustomizePageLaunch::doOk" \
	    -state "normal" \
	    -text "Ok"]
    
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "capCustomizePageLaunch::doCancel" \
	    -text "Cancel"]
    
    variable lBtnHelp [button $pForm.lBtnHelp \
	    -command "capCustomizePageLaunch::doHelp" \
	    -text "Help"]
    
    set lSampleHelpBtnState "disabled"
    set lSamplePath [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/capCustomizePage.tcl"]
	
    if { $lSamplePath == $::capCustomizePageLaunch::mTCLScriptPath } {
	set lSampleHelpBtnState "normal"
    }
	
    variable lBtnSampleHelp [button $pForm.lBtnSampleHelp \
	    -command "capCustomizePageLaunch::doSampleHelp" \
	    -state $lSampleHelpBtnState \
	    -text "Default Values Help"]
    
    # Geometry Management

    grid $pForm.lLabelFrameEnablePageCustomization -in $pForm -row 1 -column 1 \
	    -columnspan 2 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    
    grid $pForm.lLabelEnablePageCustomization -in $pForm.lLabelFrameEnablePageCustomization -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lCheckBtnEnablePageCustomization -in $pForm.lLabelFrameEnablePageCustomization -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    
    grid $pForm.lLabelFrameTCLScriptPath -in $pForm -row 2 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    
    grid $pForm.lLabelTCLScriptPath -in $pForm.lLabelFrameTCLScriptPath -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTCLScriptPath -in $pForm.lLabelFrameTCLScriptPath -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lBtnTCLScriptPath -in $pForm.lLabelFrameTCLScriptPath -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 1 \
	    -pady 1 \
	    -rowspan 1 \
	    -sticky ""
    
    grid $pForm.lLabelFrameTCLProcs -in $pForm -row 3 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lLabelPagePreCreate -in $pForm.lLabelFrameTCLProcs -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPagePreCreate -in $pForm.lLabelFrameTCLProcs -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelPagePostCreate -in $pForm.lLabelFrameTCLProcs -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPagePostCreate -in $pForm.lLabelFrameTCLProcs -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelPageSizeChange -in $pForm.lLabelFrameTCLProcs -row 3 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPageSizeChange -in $pForm.lLabelFrameTCLProcs -row 3 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    
    grid $pForm.lLabelFrameButtons -in $pForm -row 4 -column 1 \
	    -columnspan 2 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnOk -in $pForm.lLabelFrameButtons -row 1 -column 1 \
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
    grid $pForm.lBtnHelp -in $pForm.lLabelFrameButtons -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "e"
    grid $pForm.lBtnSampleHelp -in $pForm.lLabelFrameButtons -row 1 -column 4 \
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
    grid rowconfigure $pForm 3 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 4 -weight 0 -minsize 21 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    
    grid rowconfigure $pForm.lLabelFrameEnablePageCustomization 1 -weight 0 -minsize 21 -pad 0
    grid columnconfigure $pForm.lLabelFrameEnablePageCustomization 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm.lLabelFrameEnablePageCustomization 2 -weight 0 -minsize 40 -pad 0
    
    grid rowconfigure $pForm.lLabelFrameTCLScriptPath 1 -weight 0 -minsize 21 -pad 0
    grid columnconfigure $pForm.lLabelFrameTCLScriptPath 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm.lLabelFrameTCLScriptPath 2 -weight 0 -minsize 40 -pad 0
    grid columnconfigure $pForm.lLabelFrameTCLScriptPath 3 -weight 0 -minsize 10 -pad 0
    
    grid rowconfigure $pForm.lLabelFrameTCLProcs 1 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm.lLabelFrameTCLProcs 2 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm.lLabelFrameTCLProcs 3 -weight 0 -minsize 21 -pad 0
    grid columnconfigure $pForm.lLabelFrameTCLProcs 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm.lLabelFrameTCLProcs 2 -weight 0 -minsize 40 -pad 0
    
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 4 -weight 0 -minsize 12 -pad 0
}

proc capCustomizePageLaunch::updateWidgetsState { } {
	set lState disabled
	if { $::capCustomizePageLaunch::mEnablePageCustomization ==  0 }  {
	} else { 
		set lState normal
	}
	
	$::capCustomizePageLaunch::mForm.lBtnTCLScriptPath configure -state $lState
	$::capCustomizePageLaunch::mForm.lTCLScriptPath configure -state $lState
	$::capCustomizePageLaunch::mForm.lPagePreCreate configure -state $lState
	$::capCustomizePageLaunch::mForm.lPagePostCreate configure -state $lState
	$::capCustomizePageLaunch::mForm.lPageSizeChange configure -state $lState
}

proc capCustomizePageLaunch::onCheckBtnEnablePageCustomization { } {
	capCustomizePageLaunch::updateWidgetsState
}

proc capCustomizePageLaunch::doOk { } {
	
	if { $::capCustomizePageLaunch::mEnablePageCustomization ==  1 }  {
		
		if { $::capCustomizePageLaunch::mTCLScriptPath == ""} {
			tk_messageBox -type ok -message "Please specify the TCL script path" -title "Page Customization Message"
			return
		}
	
		if {[file exists $::capCustomizePageLaunch::mTCLScriptPath] !=1 } {
			tk_messageBox -type ok -message "Please specify the TCL script path correctly" -title "Page Customization Message"
			return
		}
		
		if { $::capCustomizePageLaunch::mPagePreCreate == "" && $::capCustomizePageLaunch::mPagePostCreate == "" && $::capCustomizePageLaunch::mPageSizeChange == ""} {
			tk_messageBox -type ok -message "All TCL callback procedures can't be empty" -title "Page Customization Message"
			return
		}
		
		::capCustomizePageLaunch::registerActions
	
	} else {
		::capCustomizePageLaunch::unregisterActions
	}
	
	capCustomizePageLaunch::writeINI
	
	destroy $::capCustomizePageLaunch::mForm
	
}

proc capCustomizePageLaunch::doCancel {  } {
	
	destroy $::capCustomizePageLaunch::mForm
}

proc ::capCustomizePageLaunch::doHelp {  } {
	set lMessage "This option gives you the ability to customize the process of page creation and page size change. \n\n\
	You can specify different TCL procedures that will be called automatically - \n\
	- before the page is created (On Pre-create) \n\
	- after the page is created (On Post-create) \n\
	- when the page size changes (On Options->Schematic Page Properties) \n\n\
	To do this, specify your TCl script path along with the callback procedures in the Page customization dialog box.\n\n\
	You have the choice to leave any callback procedure empty if you do not wish to specifically handle any of these callbacks.\n\n\
	These options are persistent across Capture sessions. They are saved in the INI file."
	
	tk_messageBox -type ok -message $lMessage -title "Capture Page Customization"
}

proc ::capCustomizePageLaunch::doSampleHelp {  } {
	set lSamplePath [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/capCustomizePage.tcl"]
	catch {source $lSamplePath}
	catch {::capCustomizePage::doHelp}
}

proc capCustomizePageLaunch::writeINI {  } {
	
	SetOptionString "TCLEnablePageCustomization" $::capCustomizePageLaunch::mEnablePageCustomization
		
	SetOptionString "TCLPageCustomizationScript" $::capCustomizePageLaunch::mTCLScriptPath
	SetOptionString "TCLPageCustomizationPreCreateProc" $::capCustomizePageLaunch::mPagePreCreate
	SetOptionString "TCLPageCustomizationPostCreateProc" $::capCustomizePageLaunch::mPagePostCreate
	SetOptionString "TCLPageCustomizationSizeChangeProc" $::capCustomizePageLaunch::mPageSizeChange

}


proc capCustomizePageLaunch::readINI {  } {
	
	set ::capCustomizePageLaunch::mEnablePageCustomization [GetOptionString "TCLEnablePageCustomization"]
	set ::capCustomizePageLaunch::mTCLScriptPath [GetOptionString "TCLPageCustomizationScript"]
	set ::capCustomizePageLaunch::mPagePreCreate [GetOptionString "TCLPageCustomizationPreCreateProc"]
	set ::capCustomizePageLaunch::mPagePostCreate [GetOptionString "TCLPageCustomizationPostCreateProc"]
	set ::capCustomizePageLaunch::mPageSizeChange [GetOptionString "TCLPageCustomizationSizeChangeProc"]
	
}

proc  capCustomizePageLaunch::setDefaultOptions { } {
	
	set ::capCustomizePageLaunch::mEnablePageCustomization 0
	set ::capCustomizePageLaunch::mTCLScriptPath [file join [capGetCdnDefaultScriptsDir] "capCustomSamples/capCustomizePage.tcl"]
	set ::capCustomizePageLaunch::mPagePreCreate "::capCustomizePage::onPagePreCreate"
	set ::capCustomizePageLaunch::mPagePostCreate "::capCustomizePage::onPagePostCreate"
	set ::capCustomizePageLaunch::mPageSizeChange "::capCustomizePage::onPageSizeChange"

}

proc capCustomizePageLaunch::capTrue { pPage } {
	return 1
}

proc capCustomizePageLaunch::registerActions {  } {

	#puts "registering page customization actions"
	catch {source $::capCustomizePageLaunch::mTCLScriptPath}
	
	capCustomizePageLaunch::unregisterActions
	
	if { $::capCustomizePageLaunch::mPagePostCreate != "" } {
		catch {RegisterAction "_cdnOrOnNewSchematicPage" "::capCustomizePageLaunch::capTrue" "" $::capCustomizePageLaunch::mPagePostCreate ""}
	}
		
	if { $::capCustomizePageLaunch::mPagePreCreate != "" } {
		catch {RegisterAction "_cdnOrOnNewSchematicPagePreCreate" "::capCustomizePageLaunch::capTrue" "" $::capCustomizePageLaunch::mPagePreCreate ""}
	}
	
	if { $::capCustomizePageLaunch::mPageSizeChange != "" } {
		catch {RegisterAction "_cdnOrOnSchematicPageAttributeChange" "::capCustomizePageLaunch::capTrue" "" $::capCustomizePageLaunch::mPageSizeChange ""}
	}

}

proc capCustomizePageLaunch::unregisterActions {  } {

	catch {UnregisterAction "_cdnOrOnNewSchematicPage"}
	catch {UnregisterAction "_cdnOrOnNewSchematicPagePreCreate"}
	catch {UnregisterAction "_cdnOrOnSchematicPageAttributeChange"}

}

proc capCustomizePageLaunch::doChooseTCLScriptFile {  } {
	set types {
	    {{TCL Script File}       {.tcl}        }
	}

	set filename [tk_getOpenFile -filetypes $types]
	set ::capCustomizePageLaunch::mTCLScriptPath $filename
}

proc ::capCustomizePageLaunch::init { } {
    
    set lForm .capCustomizePageLaunch
    
    capCustomizePageLaunch::readINI
    
    if { $::capCustomizePageLaunch::mEnablePageCustomization == "" } {
	capCustomizePageLaunch::setDefaultOptions
	catch {source $::capCustomizePageLaunch::mTCLScriptPath}
	
	catch {::capCustomizePageLaunch::doHelp}
	#catch {::capCustomizePage::doHelp}
    }
    
    if { "" == [info commands $lForm]} {
	    capAppUtils::capTopLevel $lForm
	    capCustomizePageLaunch::ui $lForm
	    capAppUtils::setWindowSize $lForm 400 175 400 175
	    wm title $lForm "Page Customization"
	    capAppUtils::autoAdoptWindow $lForm
    }
    
    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
    
    capCustomizePageLaunch::updateWidgetsState
}

proc ::capCustomizePageLaunch::launch { args } {
    ::capCustomizePageLaunch::init
}
