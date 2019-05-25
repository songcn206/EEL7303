#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAppLaunch.tcl
#            Sample Tcl/Tk Application Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////

namespace eval capAppLaunch {
    variable nCurrentAppData 0
    variable nCommandGroups
    array set nCommandGroups {}
    variable nDescription "Generic Utilities"
    variable nCodeViewer 0
    variable nCodeText 0
    variable nBtnShowCode 0
    variable nBtnLaunch 0    
    variable nCmdIdx 0
    variable nDescIdx 1
    variable nFileIdx 2
}

package require Tk 8.4

catch {package require Capture}
package require capApps
package require capAppUtils 
package provide capAppLaunch 1.0

proc capAppLaunch::getFont {} {
    return "Tahoma 8"
}

proc capAppLaunch::getDisclaimerText {} {
    set lDisclaimer { 
WARRANTY: NONE. THESE PROGRAMS WERE WRITTEN AS "SHAREWARE" AND
ARE AVAILABLE "AS IS" AND MAY NOT WORK AS ADVERTISED IN
ALL ENVIRONMENTS. THERE IS NO SUPPORT FOR THESE
PROGRAMS.

NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGNS AND/OR
LIBRARIES BEFORE RUNNING THESE PROGRAMS. 
    }
	
    return $lDisclaimer
}

proc capAppLaunch::getHelpFileName {} {
    return OrCAD_Capture_TclTk_Extensions.pdf
}

proc capAppLaunch::getRevisionHistoryFileName {} {
    return RevisionHistory.txt
}

proc capAppLaunch::getHelpFile {} {
    return [file join [capAppUtils::getScriptsDir] [getHelpFileName]]
}

proc capAppLaunch::getRevisionHistoryFile {} {
    return [file join [capAppUtils::getScriptsDir] [getRevisionHistoryFileName]]
}

proc capAppLaunch::appLaunchFormDone {args} {
    wm withdraw [lindex $args 0]
}

proc capAppLaunch::setButtonState {args} {
    set lAppData $::capAppLaunch::nCurrentAppData 

    set lButton 0
    set lState disabled

    switch $args "show" {
        set lButton $::capAppLaunch::nBtnShowCode

        if { 0 != $lAppData } {
            set lFile [string trim [lindex $lAppData $::capAppLaunch::nFileIdx]]

            if { "" != $lFile } {
                set lState active
            }
        }
    } "launch" {
        set lButton $::capAppLaunch::nBtnLaunch

        if { 0 != $lAppData } {
            set lCmd [string trim [lindex $lAppData $::capAppLaunch::nCmdIdx]]

            if { "" != $lCmd } {
                set lState active
            }
        }
    }

    $lButton configure -state $lState
}

proc capAppLaunch::setShowCodeState {args} {
    setButtonState "show"    
}

proc capAppLaunch::setLaunchState {args} {
    setButtonState "launch"    
}

proc capAppLaunch::listBoxSelChanges {args} {
    set lAppData [getAppData [$args curselection]]
    set ::capAppLaunch::nDescription [lindex $lAppData 1]
    set ::capAppLaunch::nCurrentAppData $lAppData

    setShowCodeState
    setLaunchState    
}

proc capAppLaunch::listBoxDblClickHandler {args} {
    if { "active" == [$::capAppLaunch::nBtnLaunch cget -state] } {
        appLaunchFormLaunchApp
    }
}

proc capAppLaunch::getAppData {pIdx} {
    set lVal [array get ::capAppLaunch::nCommandGroups $pIdx]

    set lAppData 0
    if { 0 != [llength $lVal] } { 
        set lAppData [lindex $lVal 1]
    }
    return $lAppData
}

proc capAppLaunch::errBox {pMessage} {
    tk_messageBox \
        -title "OrCAD Tcl/Tk Applications" \
        -message $pMessage \
        -type ok    
}

proc capAppLaunch::appLaunchFormGenericAction {args} {
    set lAppData $::capAppLaunch::nCurrentAppData

    if { 0 != $lAppData } {
        switch $args "launch" {
            set lCommand [lindex $lAppData 0]
            capAppUtils::safeInvoker $lCommand args
        } "show" {
            set lFile [lindex $lAppData 2]
            if { "" != [string trim $lFile] } {
                showCode $lFile
            }
        }
    } else {
        errBox "Select an application from the list."                    
    }
}

proc capAppLaunch::appLaunchFormLaunchApp {args} {
    appLaunchFormGenericAction launch    
}

proc capAppLaunch::appLaunchFormShowCode {args} {
    appLaunchFormGenericAction show
}

proc capAppLaunch::appLaunchFormHelp {args} {
    Shell [getHelpFile]
}

proc capAppLaunch::appLaunchFormRevisionHistory {args} {
     set lFile [getRevisionHistoryFileName]
     if { "" != [string trim $lFile] } {
	showCode $lFile
	}
}

proc capAppLaunch::main {root args} {

    set capAppLaunch::nCurrentAppData 0    
    set lFont [getFont]
    set lAppGroups [capApps::getApps]
    set lNumGroups [llength $lAppGroups]

    set lGroupIdx 1
    set lCurrIdx 0

    set lColSpan 1
    set lRowSpan 1
    set lIPadX 4
    set lIPadY 4
    set lPadX 4
    set lPadY 4
    set lSticky "news"

    set lFont [getFont]

    variable lFrmListBox [labelframe $root.lFrmListBox -text "Applications"]
    grid $lFrmListBox -in $root -row 1 -column 1 \
        -columnspan 1 \
        -ipadx 10 \
        -ipady 10 \
        -padx 10 \
        -pady 10 \
        -rowspan 1 \
        -sticky "ew"

    set lListBoxName $lFrmListBox.lListBox
    set lScrollName $lFrmListBox.lScroll
    variable lScroll [scrollbar $lScrollName -command "$lListBoxName yview"]

    variable lListBox [listbox $lListBoxName -font $lFont \
        -height 1 \
        -selectmode "single" \
        -yscroll "$lScroll set" \
        -setgrid 1 \
        -width 40 \
        -height 10]

    set ::capAppLaunch::nListBox $lListBox

    grid $lListBox -in $lFrmListBox -row 1 -column 1 \
        -columnspan $lColSpan \
        -rowspan $lRowSpan \
        -ipadx 0 \
        -ipady $lIPadY \
        -padx 0 \
        -pady $lPadY \
        -sticky $lSticky

    grid $lScroll -in $lFrmListBox -row 1 -column 2 \
        -columnspan $lColSpan \
        -rowspan $lRowSpan \
        -ipadx 0 \
        -ipady $lIPadY \
        -padx 0 \
        -pady $lPadY \
        -sticky $lSticky

    bind $lListBox <<ListboxSelect>> [list ::capAppLaunch::listBoxSelChanges %W]    
    bind $lListBox <Double-ButtonPress-1> { ::capAppLaunch::listBoxDblClickHandler }

    variable lFrmButtons [frame $root.lFrmButtons]
    grid $lFrmButtons -in $root -row 1 -column 2 \
        -columnspan 1 \
        -ipadx 6 \
        -ipady 6 \
        -padx 6 \
        -pady 6 \
        -rowspan 1 \
        -sticky "news"

    variable btnLaunchApp [button $lFrmButtons.btnLaunchApp \
        -command "capAppUtils::safeInvoker capAppLaunch::appLaunchFormLaunchApp $root $args" \
        -font $lFont \
        -text "Launch"]

    set ::capAppLaunch::nBtnLaunch $btnLaunchApp

    variable btnShowCode [button $lFrmButtons.btnShowCode \
        -command "capAppUtils::safeInvoker capAppLaunch::appLaunchFormShowCode $root $args" \
        -font $lFont \
        -text "Show Code"]

    set ::capAppLaunch::nBtnShowCode $btnShowCode

    variable btnHelp [button $lFrmButtons.btnHelp \
        -command "capAppUtils::safeInvoker capAppLaunch::appLaunchFormHelp $root $args" \
        -font $lFont \
        -text " Help "]

    variable btnRevisionHistory [button $lFrmButtons.btnRevisionHistory \
        -command "capAppUtils::safeInvoker capAppLaunch::appLaunchFormRevisionHistory $root $args" \
        -font $lFont \
        -text "What's New"]

    variable btnDone [button $lFrmButtons.btnDone \
        -command "capAppUtils::safeInvoker capAppLaunch::appLaunchFormDone $root $args" \
        -font $lFont \
        -text "Done"]

    grid $btnLaunchApp -in $lFrmButtons -row 1 -column 1 \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx 0 \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew"

    grid $btnShowCode -in $lFrmButtons -row 2 -column 1 \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx 0 \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew"

    grid $btnHelp -in $lFrmButtons -row 3 -column 1 \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx 0 \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew"

    grid $btnRevisionHistory -in $lFrmButtons -row 4 -column 1 \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx 0 \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew"

    grid $btnDone -in $lFrmButtons -row 5 -column 1 \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx 0 \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew"

    variable lblFrDescription [labelframe $root.lblFrDescription -font $lFont -text "Description"]
    grid $lblFrDescription -in $root -row 3 -column 1 \
        -columnspan 2 \
        -ipadx 10 \
        -ipady 10 \
        -padx 10 \
        -pady 10 \
        -rowspan 1 \
        -sticky "ew"

    variable lblDescription [label $lblFrDescription.lblDescription -font $lFont -textvariable ::capAppLaunch::nDescription -width 0 -height 5 -justify left -wraplength 300]    
    grid $lblDescription -in $lblFrDescription -row 1 -column 1 \
        -columnspan 1 \
        -ipadx 1 \
        -ipady 1 \
        -padx $lPadX \
        -pady $lPadY \
        -rowspan 1 \
        -sticky "ew" 

    # variable lblDisclaimer [label $root.lblDisclaimer -font $lFont -foreground blue -text [getDisclaimerText]]
    # grid $lblDisclaimer -in $root -row 4 -column 1 \
        # -columnspan 2 \
        # -ipadx 10 \
        # -ipady 10 \
        # -padx $lPadX \
        # -pady $lPadY \
        # -rowspan 1 \
        # -sticky "ew"

    grid columnconfigure $root 1 -weight 0 -minsize 0 -pad 0
    grid rowconfigure $root 1 -weight 0 -minsize 0 -pad 0
    grid rowconfigure $root 2 -weight 0 -minsize 0 -pad 0    
    grid rowconfigure $root 3 -weight 0 -minsize 0 -pad 0

    grid rowconfigure $root.lFrmButtons 1 -weight 0 -minsize 4 -pad 0

    grid columnconfigure $root.lFrmButtons 1 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $root.lFrmButtons 2 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $root.lFrmButtons 3 -weight 0 -minsize 0 -pad 0

    # populate the list with application data
    set lGroupIdx 1
    set lCurrAppIdx 0
    foreach lAppGroup $lAppGroups {
        set lCurrAppIdx [createAppGroup $lGroupIdx $root $lAppGroup $lCurrAppIdx $args]
        incr lGroupIdx
    }    

    #    wm title $root "OrCAD Tcl/Tk Applications"

    setLaunchState
    setShowCodeState
}

proc capAppLaunch::createAppGroup {pGroupNum pRoot pAppGroup pCurrIdx args} {
    set lGroupText [lindex $pAppGroup 0]
    set lApps [lindex $pAppGroup 1]
    set lNumApps [llength $lApps]
    set lGroupName lGroup$pGroupNum

    set lIdx $pCurrIdx
    set lLabel " \["
    append lLabel $lGroupText "\]"

    $::capAppLaunch::nListBox insert $lIdx $lLabel
    #    $::capAppLaunch::nListBox itemconfigure $lIdx -foreground white -background black
    incr lIdx

    foreach lApp $lApps {

        set lName [lindex $lApp 0]
        set lAppLabel [lindex $lApp 1]
        set lCommand [lindex $lApp 2]
        set lDesc [lindex $lApp 3]
        set lFile [lindex $lApp 4]

        set lLabel "      "
        append lLabel $lAppLabel        
        $::capAppLaunch::nListBox insert $lIdx $lLabel

        set lAppData [list $lCommand $lDesc $lFile]
        set capAppLaunch::nCommandGroups($lIdx) $lAppData
        incr lIdx       
    }

    return $lIdx
}

proc capAppLaunch::getFileData { pFile } {
    set lFileData 0
    set lErrFlag 1
    if { 1 == [file readable $pFile] } {
        if { 0 == [catch {open $pFile} lFileHandle] } {
            set lFileData [read $lFileHandle]
            close $lFileHandle
            set lErrFlag 0
        }        
    }    

    if { 1 == $lErrFlag } {
        errBox "Unable to open file $pFile"
    }
    return $lFileData
}

proc capAppLaunch::showCode { pFile } {
    set lTitle "OrCAD Tcl/Tk Viewer"

    set lScriptsDir [capAppUtils::getScriptsDir]
    set lFullFilePath [file normalize [file join $lScriptsDir $pFile]]
    set lFileData [getFileData $lFullFilePath]

    if { 0 != $lFileData } {
        append lTitle " - $lFullFilePath"

        if { 0 == [winfo exists $::capAppLaunch::nCodeViewer] } {
            destroy $::capAppLaunch::nCodeViewer
            createCodeViewer
        }

        wm title $::capAppLaunch::nCodeViewer $lTitle
        wm deiconify $::capAppLaunch::nCodeViewer

        # clear previous content
        $::capAppLaunch::nCodeText delete 1.0 end

        # insert new content
        $::capAppLaunch::nCodeText insert end $lFileData
    }
}

proc capAppLaunch::createCodeViewer {} {

    set lForm .capAppCodeViewer    

    if { "" == [info command $lForm] } {
        capAppUtils::capTopLevel $lForm
        set lTextBoxName $lForm.txtCode
        set lScrollName $lForm.lScroll
        variable lScroll [scrollbar $lScrollName -command "$lTextBoxName yview"]

        variable txtCode [text $lTextBoxName -font "Consolas 9" -yscroll "$lScroll set"]
        grid $txtCode -in $lForm -row 1 -column 1 \
            -columnspan 1 \
            -ipadx 2 \
            -ipady 2 \
            -padx 5 \
            -pady 5 \
            -rowspan 1 \
            -sticky "news"

        grid $lScroll -in $lForm -row 1 -column 2 \
            -columnspan 1 \
            -ipadx 2 \
            -ipady 2 \
            -padx 5 \
            -pady 5 \
            -rowspan 1 \
            -sticky "news"

        variable btnOK [button $lForm.btnOK \
            -command "wm withdraw $lForm" \
            -font [getFont] \
            -width 10 \
            -text "OK"]

        grid $btnOK -in $lForm -row 2 -column 1 \
            -columnspan 2 \
            -ipadx 2 \
            -ipady 2 \
            -padx 5 \
            -pady 5 \
            -rowspan 1 \
            -sticky ""   

        grid rowconfigure $lForm 1 -weight 1 -minsize 0 -pad 0
        grid rowconfigure $lForm 2 -weight 0 -minsize 0 -pad 0    
        grid columnconfigure $lForm 1 -weight 1 -minsize 0 -pad 0
        grid columnconfigure $lForm 2 -weight 0 -minsize 0 -pad 0    

        wm withdraw $lForm
        set ::capAppLaunch::nCodeViewer $lForm
        set ::capAppLaunch::nCodeText $txtCode
    }
}

proc capAppLaunch::launchForm {args} {
    set lForm .capAppLauncher
    if { "" == [info commands $lForm]} {
        capAppUtils::capTopLevel $lForm
        capAppLaunch::main $lForm $args
        createCodeViewer
        wm title $lForm "Tcl/Tk Applications Dashboard"
	capAppUtils::autoAdoptWindow $lForm    
    }

    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
}

# end of file

