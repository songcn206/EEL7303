#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPdfLaunch.tcl
#            Sample Tcl/Tk Export PDF Launch
#/////////////////////////////////////////////////////////////////////////////////


package require Tk 8.4
package require capAppUtils
package require capPdfUtil 1.0
package provide capPdfLaunch 1.0

namespace eval capPdfLaunch {
	variable mForm
	variable mListBoxPSToPdfConverter
	variable mListBoxName
	
	variable mListBoxPaperSizeName
	variable mListBoxPaperSize
}

proc capPdfLaunch::logbutton { } {
	foreach command [info commands .*] { 
	     if {[catch {winfo class $command} class]} continue 
	     if {$class ne "Button"} continue 
	     trace add execution $command enter traceButton 
	} 
}

proc capPdfLaunch::traceButton {commandstring op} { 
     set subcommand [lindex $commandstring 1] 
     if {$subcommand eq "invoke"} { 
         set command [lindex $commandstring 0] 
         puts "button $command was invoked" 
     } 
}

proc capPdfLaunch::ui { pForm } {
    
    set ::capPdfLaunch::mForm $pForm
    
    variable lLabelFrameOptions [labelframe $pForm.lLabelFrameOptions \
	    -text "Options"]
    
    variable lLabelFrameOKCancel [labelframe $pForm.lLabelFrameOKCancel ]
    
    variable lLabelFramePrintingMode [labelframe $pForm.lLabelFramePrintingMode \
	    -padx 2 \
	    -pady 2 \
	    -text "Printing Mode"]
    
    variable lLabelFrameCreateNetAndPartBookMarks [labelframe $pForm.lLabelFrameCreateNetAndPartBookMarks \
	    -text "Create Net and Part Bookmarks"]
    
    variable lLabelFrameOrientation [labelframe $pForm.lLabelFrameOrientation \
	    -text "Orientation"]
    
    variable lLabelFrameCreatePropertiesPdfFile [labelframe $pForm.lLabelFrameCreatePropertiesPdfFile \
	    -text "Create Properties PDF File"]
    
    variable lLabelFramePaperSize [labelframe $pForm.lLabelFramePaperSize ]
    
    variable lLabelOutDir [label $pForm.lLabelOutDir \
	    -text "Output Directory"]
    
    variable lLabelPSDriver [label $pForm.lLabelPSDriver \
	    -text "Postscript Driver"]
    
    variable lLabelPSToPDFConverter [label $pForm.lLabelPSToPDFConverter \
	    -text "PS to PDF Converter"]
    
    variable lLabelOutputPDFFile [label $pForm.lLabelOutputPDFFile \
	    -text "Output PDF File"]
    
    variable lLabelPaperSize  [label $pForm.lLabelPaperSize \
	    -text "Output Paper Size \n\n\n(Make sure that \nthe specified Postscript \nDriver supports the \nselected paper size)"]

    variable lTextOutDir [entry $pForm.lTextOutDir \
	    -textvariable "::capPdfUtil::mOutDir" \
	    -width 20 \
	    ]
    
    variable lTextOutFile [entry $pForm.lTextOutFile \
	    -textvariable "::capPdfUtil::mOutFile" \
	    -width 20 \
	    ]
     
    variable lTextPSDriver [entry $pForm.lTextPSDriver \
	    -textvariable "::capPdfUtil::mPSDriver" \
	    -width 20 \
	    ]
    
    variable lTextPSToPDFConverter [entry $pForm.lTextPSToPDFConverter \
	    -textvariable "::capPdfUtil::mPSToPDFConverterCommand" \
	    -width 20 ]
    
    
    variable lBtnOutDir [button $pForm.lBtnOutDir \
	    -activebackground "#00ffff" \
	    -anchor "ne" \
	    -borderwidth 1 \
	    -command "capPdfLaunch::chooseDir" \
	    -compound "left" \
	    -cursor "arrow" \
	    -default "active" \
	    -justify "left" \
	    -padx 0 \
	    -pady 0 \
	    -text "..."]
    
    variable lBtnCancel [button $lLabelFrameOKCancel.lBtnCancel \
	    -command "capPdfLaunch::doCancel" \
	    -default "active" \
	    -text "Cancel"]
    
    variable lBtnOK [button $lLabelFrameOKCancel.lBtnOK \
	    -command "capPdfLaunch::doOK" \
	    -default "active" \
	    -text "OK"]
    
    variable lBtnHelp [button $lLabelFrameOKCancel.lBtnHelp \
	    -command "capPdfLaunch::doHelp" \
	    -default "active" \
	    -text "Help"]
    
    variable lRadioBtnOccurrence [radiobutton $pForm.lRadioBtnOccurrence \
	    -anchor "nw" \
	    -borderwidth 0 \
	    -justify "left" \
	    -padx 2 \
	    -pady 0 \
	    -text "Occurrence" \
	    -value "0" \
	    -variable ::capPdfUtil::mIsInstMode]
    
    variable lRadioBtnInstance [radiobutton $pForm.lRadioBtnInstance \
	    -anchor "nw" \
	    -borderwidth 0 \
	    -justify "left" \
	    -padx 2 \
	    -pady 0 \
	    -takefocus 1 \
	    -text "Instance" \
	    -value "1" \
	    -variable ::capPdfUtil::mIsInstMode]
    
    variable lRadioBtnPortrait [radiobutton $pForm.lRadioBtnPortrait \
	    -text "Portrait" \
	    -value "0" \
	    -variable ::capPdfUtil::mIsLandscapeOrientation]
    
    variable lRadioBtnLandscape [radiobutton $pForm.lRadioBtnLandscape \
	    -text "Landscape" \
	    -value "1" \
	    -variable ::capPdfUtil::mIsLandscapeOrientation]
    
    variable lCheckBtnCreateNetAndPartBookMarks [checkbutton $pForm.lCheckBtnCreateNetAndPartBookMarks \
		-variable ::capPdfUtil::mIsCreateNetAndPartBookMarks]
    
    variable lCheckBtnCreatePropertiesPdfFile [checkbutton $pForm.lCheckBtnCreatePropertiesPdfFile \
		-variable ::capPdfUtil::mIsCreatePropertiesPdfFile]
    
    set ::capPdfLaunch::mListBoxName $pForm.lListBoxPSToPdfConverter
    
    variable lScrollPSToPdfConverter [scrollbar $pForm.lScrollPSToPdfConverter \
	    -command "$::capPdfLaunch::mListBoxName yview"]
    
    variable lListBoxPSToPdfConverter [listbox $::capPdfLaunch::mListBoxName \
	    -height 3 \
	    -selectmode "single" \
	    -yscroll "$lScrollPSToPdfConverter set" \
	    -width 0]
    set ::capPdfLaunch::mListBoxPSToPdfConverter $lListBoxPSToPdfConverter
    
    bind $lListBoxPSToPdfConverter <<ListboxSelect>> [list capPdfLaunch::listBoxPSToPdfConverterChanges]    
     
    set ::capPdfLaunch::mListBoxPaperSizeName $pForm.lListBoxPaperSize
    
    variable lScrollPaperSize [scrollbar $pForm.lScrollPaperSize \
	    -command "$::capPdfLaunch::mListBoxPaperSizeName yview"]
    
    variable lListBoxPaperSize [listbox $::capPdfLaunch::mListBoxPaperSizeName \
	    -height 10 \
	    -selectmode "single" \
	    -yscroll "$lScrollPaperSize set" \
	    -width 0]
    set ::capPdfLaunch::mListBoxPaperSize $lListBoxPaperSize
    
    bind $lListBoxPaperSize <<ListboxSelect>> [list capPdfLaunch::listBoxPaperSizeChanges]    
    
    variable lTextPaperSizeName [entry $pForm.lTextPaperSizeName \
	    -textvariable "::capPdfUtil::mPaperSizeName" \
	    -width 20 \
	    -state readonly]
    
     
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
    grid $pForm.lLabelOutputPDFFile -in $pForm -row 3 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextOutFile -in $pForm -row 3 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelPSDriver -in $pForm -row 5 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lTextPSDriver -in $pForm -row 5 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelPSToPDFConverter -in $pForm -row 7 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lListBoxPSToPdfConverter -in $pForm -row 7 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "nsew"
    grid $pForm.lScrollPSToPdfConverter -in $pForm -row 7 -column 3 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ns"
    grid $pForm.lTextPSToPDFConverter -in $pForm -row 8 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameOptions -in $pForm -row 9 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lLabelFramePrintingMode -in $pForm.lLabelFrameOptions -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lRadioBtnOccurrence -in $pForm.lLabelFramePrintingMode -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lRadioBtnInstance -in $pForm.lLabelFramePrintingMode -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLabelFrameOrientation -in $pForm.lLabelFrameOptions -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lRadioBtnLandscape -in $pForm.lLabelFrameOrientation -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lRadioBtnPortrait -in $pForm.lLabelFrameOrientation -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lLabelFrameCreatePropertiesPdfFile -in $pForm.lLabelFrameOptions -row 2 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lCheckBtnCreatePropertiesPdfFile -in $pForm.lLabelFrameCreatePropertiesPdfFile -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelFrameCreateNetAndPartBookMarks -in $pForm.lLabelFrameOptions -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lCheckBtnCreateNetAndPartBookMarks -in $pForm.lLabelFrameCreateNetAndPartBookMarks -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky ""
    grid $pForm.lLabelFramePaperSize -in $pForm -row 11 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lLabelPaperSize -in $pForm.lLabelFramePaperSize -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lListBoxPaperSize -in $pForm.lLabelFramePaperSize -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "nsew"
    grid $pForm.lScrollPaperSize -in $pForm.lLabelFramePaperSize -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ns"
    grid $pForm.lTextPaperSizeName -in $pForm.lLabelFramePaperSize -row 2 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameOKCancel -in $pForm -row 12 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $lBtnOK -in $pForm.lLabelFrameOKCancel -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $lBtnCancel -in $pForm.lLabelFrameOKCancel -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "e"
    grid $lBtnHelp -in $pForm.lLabelFrameOKCancel -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "e"
    
    # Resize Behavior
    grid rowconfigure $pForm 1 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 3 -weight 0 -minsize 11 -pad 0
    grid rowconfigure $pForm 5 -weight 0 -minsize 9 -pad 0
    grid rowconfigure $pForm 7 -weight 1 -minsize 55 -pad 0
    grid rowconfigure $pForm 8 -weight 0 -minsize 40 -pad 0
    grid rowconfigure $pForm 9 -weight 0 -minsize 6 -pad 0
    grid rowconfigure $pForm 11 -weight 0 -minsize 2 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 40 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 228 -pad 0
    grid columnconfigure $pForm 3 -weight 0 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameOptions 1 -weight 0 -minsize 19 -pad 0
    grid rowconfigure $pForm.lLabelFrameOptions 2 -weight 0 -minsize 40 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 1 -weight 0 -minsize 2 -pad 0
    grid columnconfigure $pForm.lLabelFrameOptions 2 -weight 0 -minsize 2 -pad 0
    grid rowconfigure $pForm.lLabelFramePrintingMode 1 -weight 0 -minsize 2 -pad 0
    grid rowconfigure $pForm.lLabelFramePrintingMode 2 -weight 0 -minsize 2 -pad 0
    grid columnconfigure $pForm.lLabelFramePrintingMode 1 -weight 0 -minsize 40 -pad 0
    grid rowconfigure $pForm.lLabelFrameOrientation 1 -weight 0 -minsize 2 -pad 0
    grid rowconfigure $pForm.lLabelFrameOrientation 2 -weight 0 -minsize 2 -pad 0
    grid columnconfigure $pForm.lLabelFrameOrientation 1 -weight 0 -minsize 40 -pad 0
    grid rowconfigure $pForm.lLabelFrameCreatePropertiesPdfFile 1 -weight 0 -minsize 8 -pad 0
    grid columnconfigure $pForm.lLabelFrameCreatePropertiesPdfFile 1 -weight 0 -minsize 40 -pad 0
    grid rowconfigure $pForm.lLabelFrameCreateNetAndPartBookMarks 1 -weight 0 -minsize 4 -pad 0
    grid columnconfigure $pForm.lLabelFrameCreateNetAndPartBookMarks 1 -weight 0 -minsize 40 -pad 0
    grid rowconfigure $pForm.lLabelFramePaperSize 1 -weight 0 -minsize 12 -pad 0
    grid rowconfigure $pForm.lLabelFramePaperSize 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFramePaperSize 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFramePaperSize 2 -weight 0 -minsize 56 -pad 0
    grid columnconfigure $pForm.lLabelFramePaperSize 3 -weight 0 -minsize 12 -pad 0
    grid rowconfigure $pForm.lLabelFrameOKCancel 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 2 -weight 0 -minsize 56 -pad 0
    grid columnconfigure $pForm.lLabelFrameOKCancel 3 -weight 0 -minsize 56 -pad 0
    
    set lIdx 0
    set lCountPSToPDFConverterOptions [llength $::capPdfUtil::mPSToPDFConverterList]
    for {set i 0} {$i<$lCountPSToPDFConverterOptions} {incr i} {
	   set lCommandName [::capPdfUtil::getPSToPDFConverterCommandName $i]
	   $::capPdfLaunch::mListBoxPSToPdfConverter insert $lIdx $lCommandName
	   incr lIdx
	}
	
    $::capPdfLaunch::mListBoxPSToPdfConverter select set $::capPdfUtil::mPSToPDFConverterOptionIndex
    
    set lIdx 0
    set lCountPaperSizeOptions [::capPdfUtil::getPaperSizeListCount]
    for {set i 0} {$i<$lCountPaperSizeOptions} {incr i} {
	   set lPaperSizeName [::capPdfUtil::getPaperSizeName $i]
	   $::capPdfLaunch::mListBoxPaperSize insert $lIdx $lPaperSizeName
	   incr lIdx
	}
	
    $::capPdfLaunch::mListBoxPaperSize select set $::capPdfUtil::mPaperSizeListIndex
    
    #logbutton
}

proc capPdfLaunch::listBoxPSToPdfConverterChanges { } {
    #puts "Inside capPdfLaunch::listBoxPSToPdfConverterChanges $args"
    set lIndex [$::capPdfLaunch::mListBoxName curselection]
    #puts "Inside capPdfLaunch::listBoxPSToPdfConverterChanges $lIndex"
    
    set ::capPdfUtil::mPSToPDFConverterOptionIndex $lIndex
    set ::capPdfUtil::mPSToPDFConverterCommand [::capPdfUtil::getPSToPDFConverterCommand $::capPdfUtil::mPSToPDFConverterOptionIndex]
    
    #puts "::capPdfUtil::mPSToPDFConverterOptionIndex is $::capPdfUtil::mPSToPDFConverterOptionIndex"
    #puts "::capPdfUtil::mPSToPDFConverterCommand is $::capPdfUtil::mPSToPDFConverterCommand"
   
}

proc capPdfLaunch::listBoxPaperSizeChanges { } {
    set lIndex [$::capPdfLaunch::mListBoxPaperSizeName curselection]
    
    set ::capPdfUtil::mPaperSizeListIndex $lIndex
    set ::capPdfUtil::mPaperSizeName [::capPdfUtil::getPaperSizeName $::capPdfUtil::mPaperSizeListIndex ] 
}


proc capPdfLaunch::chooseDir {  } {
	set dir [tk_chooseDirectory \
        -initialdir $::capPdfUtil::mOutDir -title "Choose output directory"]
	set ::capPdfUtil::mOutDir $dir
}

proc capPdfLaunch::dumpOptionValues { } {
   puts [concat "capPdfUtil::mIsInstMode is " $::capPdfUtil::mIsInstMode]
   puts [concat "capPdfUtil::mIsLandscapeOrientation is " $::capPdfUtil::mIsLandscapeOrientation]
   puts [concat "capPdfUtil::mIsCreatePropertiesPdfFile is " $::capPdfUtil::mIsCreatePropertiesPdfFile]
   puts [concat "capPdfUtil::mIsCreateNetAndPartBookMarks is " $::capPdfUtil::mIsCreateNetAndPartBookMarks]
}

proc capPdfLaunch::doCancel { } {
        #capPdfLaunch::dumpOptionValues
	
	#destroy [lindex $args 0]
	destroy $::capPdfLaunch::mForm
}

proc capPdfLaunch::doOK {  } {
	
	#set lMessage "capPdfLaunch::doOK is checking environment"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	if { [capPdfLaunch::checkEnviroment] != 1 } {
		return
	}
	
	#set  lMessage "capPdfLaunch::doOK is checking WritableOutDir"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	if { [capPdfLaunch::checkWritableOutDir] != 1 } {
		return
	}
	 
	#set  lMessage  "capPdfLaunch::doOK is checking ToolPath"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	if { [capPdfLaunch::checkToolPath] != 1 } {
		return
	}
	
	# remember the command for future use
	#set  lMessage  "capPdfLaunch::doOK is remembering commands"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	if { [catch {::capPdfUtil::setPSToPDFConverterCommand $::capPdfUtil::mPSToPDFConverterOptionIndex $::capPdfUtil::mPSToPDFConverterCommand}]} {
	   set  lMessage  "ERROR : $::errorInfo"
	   set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	   DboState_WriteToSessionLog $lMessageStr
	}
	
	#set  lMessage  "capPdfLaunch::doOK is printing Pdf"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	  if { [catch {eval ::capPdfUtil::printPdf}] } {
            set  lMessage  "ERROR : $::errorInfo"
	    set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	
        }
	
	#set  lMessage  "capPdfLaunch::doOK is destroying window"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	#destroy [lindex $args 0]
	destroy $::capPdfLaunch::mForm
	
	#set  lMessage  "capPdfLaunch::doOK has destroyed window"
	#set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	#DboState_WriteToSessionLog $lMessageStr
	
	return
}

proc capPdfLaunch::doHelp {  } {
        set lMessage "The Export PDF works in conjunction with two third-party softwares: \n\n\
1. Postscript driver \n\
2. Postscript(PS) to PDF converter \n\n\
An example of Postscript driver is the Adobe Universal Postscript Driver for Windows (Acrobat Distiller driver) \
that can be downloaded and installed from \n\
http://www.adobe.com/support/downloads/product.jsp?platform=win&product=pdrv. \n\
In case of installing this driver, make sure to download PPD Files (Adobe) as well as the driver installer. \n\
Install the Postscript driver on the FILE : Local Port and use the ADIST5.PPD file as the required driver. \n\n\
Examples of Postscript(PS) to PDF converter tools are Distiller from Acrobat Professional (commercial, http://www.adobe.com/products/acrobatpro) \n\
Ghostscript (free, http://sourceforge.net/projects/ghostscript) \n\
There are many other commercial and free tools available \n\
User needs to acquire or purchase any of these tools and install the software at their end \n\n\ 
Users can change the default converter option list by modifying the TCL procedure \n\
::capPdfUtil::populateDefaultPSToPDFConverterList inside tclscripts/capUtils/capPdfUtil.tcl file \n\n\
The installation and usage details are mentioned in the TCL/TK application notes present at \n\
<install_root>/tools/capture/tclscripts/OrCAD_Capture_TclTk_Extensions.pdf \n\n\n\
WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS \"SHAREWARE\" AND IS AVAILABLE AS IS \
AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO \
SUPPORT FOR THIS PROGRAM \
NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN \
BEFORE RUNNING THIS PROGRAM"
	
	tk_messageBox -type ok -message $lMessage -title "Export PDF Message"
}

proc capPdfLaunch::checkEnviroment { } {
     if { [IsSchematicViewActive]  == 1}  {
	tk_messageBox -type ok -message "The Export PDF command runs only when PM View is active and design is selected" -title "Export PDF Message"
	return 0
    }
    
    if {[catch {GetSelectedPMItems} lVal] == 1} {
	tk_messageBox -type ok -message "The Export PDF command runs only when PM View is active and design is selected" -title "Export PDF Message"
	return 0
    }    
    
    set lPMSelectedItems [GetSelectedPMItems]
	if { [llength $lPMSelectedItems]  != 1 } {
		tk_messageBox -type ok -message "Please re-run after selecting the design only in the PM view. \nThe Export PDF command runs only when PM View is active and design is selected" -title "Export PDF Message"
		return 0
	}
	
	if { [regexp \.dsn [lindex $lPMSelectedItems 0]]  != 1  && [regexp \.DSN [lindex $lPMSelectedItems 0]]  != 1} {
		tk_messageBox -type ok -message "Please re-run after selecting the design only in the PM view. \nThe Export PDF command runs only when PM View is active and design is selected" -title "Export PDF Message"
		return 0
	}
	
    
    return 1
 }
    
    
proc capPdfLaunch::checkToolPath { } {
    set lPSToPDFTool [lindex $::capPdfUtil::mPSToPDFConverterCommand 0]
    if { $lPSToPDFTool == ""} {
	tk_messageBox -type ok -message [concat "Please specify the postscript to PDF converter tool path"] -title "Export PDF Message"
	return 0
    }
    
    # check if exec will be able to find this path
    if { [auto_execok $lPSToPDFTool] == ""} {
	tk_messageBox -type ok -message [concat "The postscript to PDF converter tool " $lPSToPDFTool " not found in the path. \nEither supply the fully qualified path in the command or make sure the path has been added in the PATH environment variable"] -title "Export PDF Message"
	auto_reset 
	return 0
    }
    
    return 1
}

proc capPdfLaunch::checkWritableOutDir { } {
    if { [file writable $::capPdfUtil::mOutDir] == 0} {
	tk_messageBox -type ok -message [concat "The output directory is readonly. Please specify the output directory having write permission"] -title "Export PDF Message"
	return 0
    }
    
   return 1
}

proc capPdfLaunch::init {args} {

    if { [capPdfLaunch::checkEnviroment] != 1 } {
	return
    }

    set lResult [::capPdfUtil::setOptionValues]
    if { $lResult == 0} {
	tk_messageBox -type ok -message "There is no active design" -title "Export PDF Message"
	return
    }

    set lForm .capPdf
    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capPdfLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 400 480 400 480
	wm title $lForm "PDF Export"
	capAppUtils::autoAdoptWindow $lForm
    }


    if { 0 == [winfo ismapped $lForm]} {
	wm deiconify $lForm
    }

}

