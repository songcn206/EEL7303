#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capDRCUtils.tcl
#            Sample DRC Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capShortNetUtil 1.0

namespace eval capDRCUtil {
	variable mForm
}

proc capDRCUtil::ui {pForm args} {
    
    set ::capDRCUtil::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
     variable lLabelPort [label $pForm.lLabelPort \
	    -text "Port"]
	    
    set lState "normal"
    
    variable lBtnCheckDRC [button $pForm.lBtnStartServer \
	    -command "::searchAShortedNetsOnSchematic"\
	    -state $lState \
	    -text "Start"]
    
    set lState "normal"
    
    
    
    # Geometry Management

    grid $pForm.lLabelPort -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPort -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameButtons -in $pForm -row 2 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnStartServer -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnStopServer -in $pForm.lLabelFrameButtons -row 1 -column 2 \
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
    grid rowconfigure $pForm 2 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
}

proc capDRCUtil::cancel { args } {
        destroy [lindex $args 0]
}

proc ::capDRCUtil::init {args} {
    
    set lForm .capCommServer
    capAppUtils::capTopLevel $lForm
    wm title $lForm "DRC Check"
    capDRCUtil::ui $lForm
    wm resizable $lForm 0 0
    capAppUtils::autoAdoptWindow $lForm
}

proc ::capDRCUtil::launch {args} {
    if { [catch {package require capShortNetUtil}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capDRCUtil::launch) DRCChecks not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capDRCUtil::init $args
	}
}
