#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capFindReplaceTextLaunch.tcl
#            Sample Tcl/Tk Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capFindReplaceTextLaunch 1.0

namespace eval capFindReplaceTextLaunch {
	variable mForm
	variable mTextToSearch
	variable mTextToReplaceWith
	
	set mDoText 1
	set mDoAlias 1
	set mDoOffPage 1
	set mDoGlobal 1
	set mDoPort 1
	
}

proc capFindReplaceTextLaunch::ui {pForm} {
    
    set ::capFindReplaceTextLaunch::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    variable lLabelFrameOptions [labelframe $pForm.lLabelFrameOptions ]
    
    variable lLabelFindWhat [label $pForm.lLabelFindWhat \
	    -text "Find what:"]
	    
    variable lLabelReplaceWith [label $pForm.lLabelReplaceWith \
	    -text "Replace with:"]
	    
    set lState "normal"
    
    variable lTextToSearch [entry $pForm.lFindWhat \
	    -textvariable "::capFindReplaceTextLaunch::mTextToSearch" \
	    -state $lState \
	    -width 10 \
	    ]
    
    variable lTextToReplaceWith [entry $pForm.lReplaceWith \
	    -textvariable "::capFindReplaceTextLaunch::mTextToReplaceWith" \
	    -state $lState \
	    -width 10 \
	    ]
    
    variable lCheckBtnText [checkbutton $pForm.lCheckBtnText \
		-variable ::capFindReplaceTextLaunch::mDoText -text "Comment text" -anchor w]
    
    variable lCheckBtnAlias [checkbutton $pForm.lCheckBtnAlias \
		-variable ::capFindReplaceTextLaunch::mDoAlias -text "Alias" -anchor w]
    
    variable lCheckBtnOffPage [checkbutton $pForm.lCheckBtnOffPage \
		-variable ::capFindReplaceTextLaunch::mDoOffPage -text "Off-page connector" -anchor w]
    
    variable lCheckBtnGlobal [checkbutton $pForm.lCheckBtnGlobal \
		-variable ::capFindReplaceTextLaunch::mDoGlobal -text "Global" -anchor w]
    
    variable lCheckBtnPort [checkbutton $pForm.lCheckBtnPort \
		-variable ::capFindReplaceTextLaunch::mDoPort -text "Port" -anchor w]
    
    
    variable lLabelRegExp [label $pForm.lLabelRegExp \
	    -text "Find and replace using regular expression is supported. See Help for examples\n\
Output is displayed in the session log"]
    
    variable lBtnSearch [button $pForm.lBtnSearch \
	    -command "capFindReplaceTextLaunch::doSearch" \
	    -state $lState \
	    -text "Find All"]
    
    variable lBtnReplace [button $pForm.lBtnReplace \
	    -command "capFindReplaceTextLaunch::doReplace" \
	    -state $lState \
	    -text "Replace All"]
    
    variable lBtnClose [button $pForm.lBtnClose \
	    -command "capFindReplaceTextLaunch::doClose" \
	    -text "Close"]
    
    variable lBtnHelp [button $pForm.lBtnHelp \
	    -command "capFindReplaceTextLaunch::doHelp" \
	    -text "Help"]
    
    # Geometry Management

    grid $pForm.lLabelFindWhat -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lFindWhat -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelReplaceWith -in $pForm -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lReplaceWith -in $pForm -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameOptions -in $pForm -row 3 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lCheckBtnText -in $pForm.lLabelFrameOptions -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lCheckBtnAlias -in $pForm.lLabelFrameOptions -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lCheckBtnOffPage -in $pForm.lLabelFrameOptions -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lCheckBtnGlobal -in $pForm.lLabelFrameOptions -row 1 -column 4 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lCheckBtnPort -in $pForm.lLabelFrameOptions -row 1 -column 5 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLabelRegExp -in $pForm -row 4 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLabelFrameButtons -in $pForm -row 5 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnSearch -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnReplace -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnClose -in $pForm.lLabelFrameButtons -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "e"
    grid $pForm.lBtnHelp -in $pForm.lLabelFrameButtons -row 1 -column 4 \
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
    grid rowconfigure $pForm 3 -weight 0 -minsize 9 -pad 0
    grid rowconfigure $pForm 4 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 5 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 40 -pad 0
    grid rowconfigure $pForm.lLabelFrameOptions 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 3 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 4 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 5 -weight 0 -minsize 12 -pad 0
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 4 -weight 0 -minsize 12 -pad 0
}

proc capFindReplaceTextLaunch::doSearch { } {
	
	if { $::capFindReplaceTextLaunch::mDoText == 1} {
		if { [catch {eval ::capDesignUtil::searchText $::capFindReplaceTextLaunch::mTextToSearch }] } {
		    puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoAlias == 1} {
		if { [catch {eval ::capDesignUtil::searchAlias $::capFindReplaceTextLaunch::mTextToSearch }] } {
		    puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoOffPage == 1} {
		if { [catch {eval ::capDesignUtil::searchOffPageText $::capFindReplaceTextLaunch::mTextToSearch }] } {
		    puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoGlobal == 1} {
		if { [catch {eval ::capDesignUtil::searchGlobalText $::capFindReplaceTextLaunch::mTextToSearch }] } {
		    puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoPort == 1} {
		if { [catch {eval ::capDesignUtil::searchPortText $::capFindReplaceTextLaunch::mTextToSearch }] } {
		    puts "ERROR : $::errorInfo"
		}
	}
}

proc capFindReplaceTextLaunch::doReplace {  } {
	
	if { $::capFindReplaceTextLaunch::mDoText == 1} {
		if { [catch {eval ::capDesignUtil::replaceText $::capFindReplaceTextLaunch::mTextToSearch $::capFindReplaceTextLaunch::mTextToReplaceWith }] } {
			puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoAlias == 1} {
		if { [catch {eval ::capDesignUtil::replaceAlias $::capFindReplaceTextLaunch::mTextToSearch $::capFindReplaceTextLaunch::mTextToReplaceWith }] } {
			puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoOffPage == 1} {
		if { [catch {eval ::capDesignUtil::replaceOffPageText $::capFindReplaceTextLaunch::mTextToSearch $::capFindReplaceTextLaunch::mTextToReplaceWith }] } {
			puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoGlobal == 1} {
		if { [catch {eval ::capDesignUtil::replaceGlobalText $::capFindReplaceTextLaunch::mTextToSearch $::capFindReplaceTextLaunch::mTextToReplaceWith }] } {
			puts "ERROR : $::errorInfo"
		}
	}
	
	if { $::capFindReplaceTextLaunch::mDoPort == 1} {
		if { [catch {eval ::capDesignUtil::replacePortText $::capFindReplaceTextLaunch::mTextToSearch $::capFindReplaceTextLaunch::mTextToReplaceWith }] } {
			puts "ERROR : $::errorInfo"
		}
	}
	
	catch {Menu "View::Zoom::Redraw"}
	 
}

proc capFindReplaceTextLaunch::doClose {  } {
	
	destroy $::capFindReplaceTextLaunch::mForm
}

proc capFindReplaceTextLaunch::doHelp {  } {
	set lMessage " Find and Replace examples -\n\
 \n\
 1. For replacing *J32* to *J35*, e.g. SN_J32_45 to SN_J35_45, give the following inputs\n\n\
     Find what :  J32\n\
     Replace with : J35\n\
    \n\
    or, give the following inputs as regular expressions\n\
     \n\
     Find what :  {(.*)J32(.*)} \n\
     Replace with : {\\1J35\\2}\n\
 \n\
 \n\
 2. For replacing *J32*K1* to *J35*K2*, e.g. SN_J32_45_K1_20 to SN_J35_45_K2_20, give the following inputs\n\
 \n\
    Find what : {(.*)J32(.*)K1(.*)} \n\
    Replace with : {\\1J35\\2K2\\3}\n\
    \n\
    \n\
    For just doing the search, give the same regular expression input in the \"Find what:\" field"
	
	tk_messageBox -type ok -message $lMessage -title "Find and Replace Message"	
	
}


proc ::capFindReplaceTextLaunch::init { } {

    set lForm .capFindReplaceText

    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capFindReplaceTextLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 500 160 500 160
	wm title $lForm "Find And Replace Text"
	capAppUtils::autoAdoptWindow $lForm
    }

    if { 0 == [winfo ismapped $lForm]} {
	wm deiconify $lForm
    }

}

proc ::capFindReplaceTextLaunch::launch { args } {
    if { [catch {package require capDesignUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capFindReplaceTextLaunch::launch) capDesignUtil package not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capFindReplaceTextLaunch::init
	}
}
