#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capExtPrefs.tcl
#            Extended preferences user interface
#/////////////////////////////////////////////////////////////////////////////////

namespace eval capExtPrefs {
    variable nPadX 1
    variable nPadY 1
    variable nPolyFrameWidth 300
    variable nPolyFrameHeight 350

    variable nSections
    variable nCommandShellFrPlacer {}
    variable nFPViewerFrPlacer {}
    variable nDesignFrPlacer {}
    variable nSchFrPlacer {}
    variable nAnnotationFrPlacer {}
    variable nUpdateCacheFrPlacer {}
    variable nTopWidget labelframe
    variable nListbox 0
    variable nCISSettingFrPlacer {}
	variable nDRCSettingPlacer {}
    

    # specify the order in which the sections
    # will appear in the section-list
    # list index starts at 0
    variable nSectionNames {
        "Designs and Libraries"
        "Command Shell"
        "Footprint Viewer"
        "Schematic"
        "Design Annotation"
        "Design Cache"
        "CIS"
		"DRC"
    }

    # specify the index for the handlers
    # according to the list nSectionNames
    variable nSections
    array set nSections {
        0 {capExtPrefs::designLibPrefs     capExtPrefs::applyDesignValues}
        1 {capExtPrefs::commandShellPrefs  capExtPrefs::applyCmdShellValues}
        2 {capExtPrefs::fpViewerPrefs      capExtPrefs::applyFPViewerValues}
        3 {capExtPrefs::schPrefs           capExtPrefs::applySchValues}
        4 {capExtPrefs::Annotation         capExtPrefs::applyAnnotation}
        5 {capExtPrefs::UpdateCache        capExtPrefs::applyUpdateCache}
        6 {capExtPrefs::QueryAllTable      capExtPrefs::applyQueryAllTable}
		7 {capExtPrefs::DRCSettingTable	   capExtPrefs::applyDRCValues}
    }

    variable nModeName2ModeId
    array set nModeName2ModeId {
        "Always append hierarchy"        1
        "Append hierarchy on collision"  2
        "Always append ID"               3
        "Append ID on collision"         4
    }

    variable nModeId2ModeName
    array set nModeId2ModeName {
        1 "Always append hierarchy"
        2 "Append hierarchy on collision"
        3 "Always append ID"
        4 "Append ID on collision"
    }

    variable nId2DisplayUnit
    array set nId2DisplayUnit {
        0 "Microns"       
        1 "Millimeters"
        2 "Mils"
        3 "Centimeters"
        4 "Inches"
    }

    variable nDisplayUnitChoices
    array set nDisplayUnitChoices {
        "Microns"       0
        "Millimeters"   1
        "Mils"          2
        "Centimeters"   3
        "Inches"        4
    }

    variable nRootFrame ""
    variable nColorFormUp 0

    # variables for computation
    # Design Frame Specific
    variable nNetNameMode ""
    variable nRotateInstPropInContext 0
    variable nDrawPinArrows 0
    variable nEnableLegacyITC 0
    variable nCheckReadOnlyOnViewActivate 0
    variable nBackAnnotatePinNumbersOnly  0
    variable nSaveAsUpperCaseDsnName  0
    variable nEnableStartPage  0
    variable nEnableGlobalNetITC  1
    variable nPathLookupTimeout 5
    variable nSaveImageAsBitmap 0
    variable nCheckConnection 1

    # Command Shell Specific
    variable nJournaling 0
    variable nFlushImmediate 0
    variable nDisplayCommands 0    
    variable nShellTextColor #000000
    variable nShellBackgroundColor #ffffff

    # Footprint Viewer
    variable nTransparencyOnHilite 1
    variable nViewerShowPinInfo 1
    variable nFPBackgroundColor #ffffff
    variable nFPHighlightColor #ff0000
    variable nDisplayUnit ""

    #Schematic
    variable nPageDescend DEFAULT
    variable nJunctionMode OnWireBreak

    #Annotation
    variable nHetroAnnotationOption DEFAULT

    #Update cache
    variable nUpdateCache    NONE
    
    #CIS QueryTable
    variable nCISQueryAllTable 0

    #CIS QueryStringMatch
    variable nCISQueryStringMatch 0

    #CIS RegionalSettingMatch
    variable nCISDisableRegionalSetting 0
	
	#DRC Specific
	variable nDisplayWaivedDRC	0
}

package require Tk 8.4
package require capAppUtils
package provide capExtPrefs 1.0

proc capExtPrefs::getFont {} {
    return "Tahoma 8"
}

proc capExtPrefs::addToGrid {pChild pParent pRow pCol pSticky} {

    grid $pChild -in $pParent -row $pRow -column $pCol \
        -columnspan 1 \
        -ipadx 0 \
        -ipady 0 \
        -padx $::capExtPrefs::nPadX \
        -pady $::capExtPrefs::nPadY \
        -rowspan 1 \
        -sticky $pSticky
}

proc capExtPrefs::listBoxSelChanges {args} {
    set lWidget $args

    if { "" != $lWidget } {
        removeWidgets $args
        set lSelectedIdx [$lWidget curselection]
        set lCommand [lindex $::capExtPrefs::nSections($lSelectedIdx) 0]
        eval $lCommand $::capExtPrefs::nRootFrame
    }
}

proc capExtPrefs::removeWidgets {args} {
    if { 1 == [winfo exists  $::capExtPrefs::nRootFrame] } {
        foreach lSlave [grid slaves $::capExtPrefs::nRootFrame] {
            grid remove $lSlave
        }
    }
}

proc capExtPrefs::commandShellPrefs {args} {
    placeWidgets $::capExtPrefs::nCommandShellFrPlacer
}

proc capExtPrefs::fpViewerPrefs {args} {
    placeWidgets $::capExtPrefs::nFPViewerFrPlacer
}

proc capExtPrefs::designLibPrefs {args} {
    placeWidgets $::capExtPrefs::nDesignFrPlacer
}

proc capExtPrefs::schPrefs {args} {
    placeWidgets $::capExtPrefs::nSchFrPlacer
}

proc capExtPrefs::Annotation {args} {
    placeWidgets $::capExtPrefs::nAnnotationFrPlacer
}

proc capExtPrefs::UpdateCache {args} {
    placeWidgets $::capExtPrefs::nUpdateCacheFrPlacer
}

proc capExtPrefs::QueryAllTable {args} {
    placeWidgets $::capExtPrefs::nCISSettingFrPlacer
}

proc capExtPrefs::DRCSettingTable {args} {
	placeWidgets $::capExtPrefs::nDRCSettingPlacer
}

proc capExtPrefs::placeWidgets {pPlacerCommands} {
    foreach lCmd $pPlacerCommands {
        eval $lCmd
    }
}

proc capExtPrefs::addWidget {pCommandList pWidget pParent pRow pCol pSticky} {
    upvar $pCommandList lCommands
    lappend lCommands [format "addToGrid %s %s %d %d \"%s\"" $pWidget $pParent $pRow $pCol $pSticky]
}

proc capExtPrefs::setVar {args} {
    set lSwitcher [lindex $args 0]
    switch $lSwitcher ShellEnableJournaling {
        set lFlushWidget [lindex $args 1]
        set lCmdDisplayWidget [lindex $args 2]
        if { 1 == $::capExtPrefs::nJournaling } {
            $lFlushWidget configure -state normal
            $lCmdDisplayWidget configure -state normal
        } else {
            $lFlushWidget configure -state disabled
            $lCmdDisplayWidget configure -state disabled
        }
    }
}

proc capExtPrefs::chooseColor {pVar pTitle pWidget pOptionName} {
    if { 0 == $::capExtPrefs::nColorFormUp } {
        set ::capExtPrefs::nColorFormUp 1
        upvar $pVar lCurrVar
        set lUserSetColor [tk_chooseColor -initialcolor $lCurrVar -title $pTitle]

        if { "" != $lUserSetColor } {
            $pWidget configure $pOptionName $lUserSetColor
            set lCurrVar $lUserSetColor
        }
        set ::capExtPrefs::nColorFormUp 0
    }
}

proc capExtPrefs::convertColor {pColor} {
    set lColor $pColor
    regsub -all "#" $lColor "" lColor
    return 0x$lColor
}

proc capExtPrefs::initValues {} {
    catch {
        set ::capExtPrefs::nRotateInstPropInContext [GetOptionBool RotateInstPropInContext]
        set ::capExtPrefs::nDrawPinArrows [GetOptionBool DrawPinArrows]
        set ::capExtPrefs::nEnableLegacyITC [GetOptionBool EnableLegacyITC]
        set ::capExtPrefs::nCheckReadOnlyOnViewActivate [GetOptionBool CheckReadOnlyOnViewActivate]
        set ::capExtPrefs::nBackAnnotatePinNumbersOnly [GetOptionBool BackAnnotatePinNumbersOnly]
        set ::capExtPrefs::nSaveAsUpperCaseDsnName [GetOptionBool SaveAsUpperCaseDsnName]
        set ::capExtPrefs::nEnableStartPage [GetOptionBool EnableStartPage]
        
        set tempVal [GetOptionString EnableGlobalNetITC]
        if {$tempVal != "" && [string toupper $tempVal] == [string toupper "0"]} {
            set ::capExtPrefs::nEnableGlobalNetITC 0
        } 
        
        set ::capExtPrefs::nPathLookupTimeout [GetOptionUInt PathLookupTimeout]
        set ::capExtPrefs::nNetNameMode $::capExtPrefs::nModeId2ModeName([GetOptionUInt NetNameMode])
        set ::capExtPrefs::nJournaling [GetOptionBool Journaling]
        set ::capExtPrefs::nFlushImmediate [GetOptionBool FlushImmediate]
        set ::capExtPrefs::nDisplayCommands [GetOptionBool DisplayCommands]
        set ::capExtPrefs::nViewerShowPinInfo [GetOptionBool ViewerShowPinInfo]
        set ::capExtPrefs::nCheckConnection [GetOptionBool CheckConnection]
        set ::capExtPrefs::nDisplayUnit $::capExtPrefs::nId2DisplayUnit([GetOptionUInt FPViewerDisplayUnits])

        set ::capExtPrefs::nPageDescend [GetOptionString DescendSchPage]
        set ::capExtPrefs::nSaveImageAsBitmap [GetOptionBool SaveImageAsBitmap]

        if {$::capExtPrefs::nPageDescend == ""} {
            set ::capExtPrefs::nPageDescend DEFAULT
        }
        
        set ::capExtPrefs::nJunctionMode [GetOptionString JunctionMode]
        if {$::capExtPrefs::nJunctionMode == ""} {
            set ::capExtPrefs::nJunctionMode OnWireBreak
        }
        
        set ::capExtPrefs::nHetroAnnotationOption [GetOptionString HeteroPackaging]
        if {$::capExtPrefs::nHetroAnnotationOption == ""} {
            set ::capExtPrefs::nHetroAnnotationOption DEFAULT
        }

        set ::capExtPrefs::nUpdateCache [GetOptionString ForceUpdateCache]
        if {$::capExtPrefs::nUpdateCache == ""} {
            set ::capExtPrefs::nUpdateCache NONE
        }
        
        set tempVal [GetOptionString QueryAllTables]
        if {$tempVal != "" && [string toupper $tempVal] == [string toupper "True"]} {
            set ::capExtPrefs::nCISQueryAllTable 1
        }

        set tempVal [GetOptionString CISRegionalSetting]
        if {$tempVal != "" && [string toupper $tempVal] == [string toupper "False"]} {
            set ::capExtPrefs::nCISDisableRegionalSetting 1
        }

        set tempVal [GetOptionString QueryStringMatch]
        if {$tempVal != "" && [string toupper $tempVal] == [string toupper "True"]} {
            set ::capExtPrefs::nCISQueryStringMatch 1
        }
		
		set tempVal [GetOptionBool DisplayWaivedDRC]
        if {$tempVal != "" && [string toupper $tempVal] == [string toupper "0"]} {
            set ::capExtPrefs::DisplayWaivedDRC 0
        } 
		
    }
}

proc capExtPrefs::applyDesignValues {} {
    catch {
        SetOptionBool RotateInstPropInContext $::capExtPrefs::nRotateInstPropInContext
        SetOptionBool DrawPinArrows $::capExtPrefs::nDrawPinArrows
        SetOptionBool EnableLegacyITC $::capExtPrefs::nEnableLegacyITC
        SetOptionBool CheckReadOnlyOnViewActivate $::capExtPrefs::nCheckReadOnlyOnViewActivate
        SetOptionBool BackAnnotatePinNumbersOnly $::capExtPrefs::nBackAnnotatePinNumbersOnly
        SetOptionBool SaveAsUpperCaseDsnName $::capExtPrefs::nSaveAsUpperCaseDsnName
        SetOptionBool EnableStartPage $::capExtPrefs::nEnableStartPage
        
        if { $::capExtPrefs::nEnableGlobalNetITC == 1 } {
            SetOptionString EnableGlobalNetITC "1"
        } else {
            SetOptionString EnableGlobalNetITC "0"
        }
       
        SetOptionUInt PathLookupTimeout $::capExtPrefs::nPathLookupTimeout
        SetOptionUInt NetNameMode $::capExtPrefs::nModeName2ModeId($::capExtPrefs::nNetNameMode)
        SetOptionBool SaveImageAsBitmap $::capExtPrefs::nSaveImageAsBitmap 
        SetOptionBool CheckConnection $::capExtPrefs::nCheckConnection

        if { 1 == [IsSchematicViewActive] } {
            Menu "View::Zoom::Redraw"
        }
    }
}

proc capExtPrefs::applyCmdShellValues {} {
    catch {
        SetOptionBool Journaling $::capExtPrefs::nJournaling
        SetOptionBool FlushImmediate $::capExtPrefs::nFlushImmediate
        SetOptionBool DisplayCommands $::capExtPrefs::nDisplayCommands
    }
}

proc capExtPrefs::applyFPViewerValues {} {
    catch {
        SetFPViewerOption TransparencyOnHilite $::capExtPrefs::nTransparencyOnHilite
        SetFPViewerOption BackgroundColor [convertColor $::capExtPrefs::nFPBackgroundColor]
        SetFPViewerOption HighlightColor [convertColor $::capExtPrefs::nFPHighlightColor]
        SetOptionBool ViewerShowPinInfo $::capExtPrefs::nViewerShowPinInfo
        SetOptionUInt FPViewerDisplayUnits $::capExtPrefs::nDisplayUnitChoices($::capExtPrefs::nDisplayUnit)
    }
}
proc capExtPrefs::applySchValues {} {
    catch {
        SetOptionString DescendSchPage $::capExtPrefs::nPageDescend
    SetOptionString JunctionMode $::capExtPrefs::nJunctionMode
    }
}

proc capExtPrefs::applyAnnotation {} {
    catch {
        SetOptionString HeteroPackaging $::capExtPrefs::nHetroAnnotationOption
    }
}
proc capExtPrefs::applyUpdateCache {} {
    catch {
        SetOptionString ForceUpdateCache $::capExtPrefs::nUpdateCache
    }
}
proc capExtPrefs::applyQueryAllTable {} {
    catch {
        # set ::capExtPrefs::nCISQueryAllTable [expr !$::capExtPrefs::nCISQueryAllTable]
        if { $::capExtPrefs::nCISQueryAllTable == 1 } {
            SetOptionString QueryAllTables "TRUE"
        } else {
            SetOptionString QueryAllTables "FALSE"
        }

    if { $::capExtPrefs::nCISQueryStringMatch == 1 } {
        SetOptionString QueryStringMatch "TRUE"
    } else {
        SetOptionString QueryStringMatch "FALSE"
    }

    if { $::capExtPrefs::nCISDisableRegionalSetting == 1 } {
        SetOptionString CISRegionalSetting "FALSE"
    } else {
        SetOptionString CISRegionalSetting "TRUE"
    }

}
}

proc capExtPrefs::applyDRCValues {} {
	catch {
		if { $::capExtPrefs::nDisplayWaivedDRC == 1 } {
			SetOptionBool DisplayWaivedDRC 1
		} else {
			SetOptionBool DisplayWaivedDRC 0
		}
	}
}

proc capExtPrefs::applyValues {} {
    catch {
        applyDesignValues
        applyCmdShellValues
        applyFPViewerValues
        applySchValues
        applyAnnotation
        applyUpdateCache
        applyQueryAllTable
		applyDRCValues
    }
}

proc ::capExtPrefs::capCBOK {args} {
    applyValues
    wm withdraw $args
}

proc ::capExtPrefs::capCBCancel {args} {
    wm withdraw $args
}

proc ::capExtPrefs::capCBHelp {args} {
    set lMessage {
This dialog allows users to modify additional application
settings available in OrCAD Capture.  The settings are
categorized into groups. To change a setting select the
appropriate group from the "Groups" list box and modify
the setting in the "Settings" frame.

WARRANTY: NONE. THESE PROGRAMS WERE WRITTEN
AS "SHAREWARE" AND IS AVAILABLE AS IS AND MAY NOT
WORK AS ADVERTISED IN ALL ENVIRONMENTS.  THERE IS
NO SUPPORT FOR THESE PROGRAMS.

NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR
DESIGNS AND/OR LIBRARIES BEFORE RUNNING THESE
PROGRAMS.
    }
    tk_messageBox -type ok -message $lMessage -title "Extended Preferences Setup"
}

proc ::capExtPrefs::capCBApply {args} {
    set lSelectedIdx [$::capExtPrefs::nListbox curselection]
    if { -1 != $lSelectedIdx } {
        set lCommand [lindex $::capExtPrefs::nSections($lSelectedIdx) 1]
        eval $lCommand
    }
}

proc capExtPrefs::createGenericStructure {pParent args} {
    set lFont [getFont]

    # avi: change following to frame
    variable wfrWidgets [labelframe $pParent.wfrWidgets]

    variable wfrPolyFrame [labelframe $pParent.wfrPolyFrame -text "Settings" -font $lFont]

    variable wfrListBox [labelframe $pParent.wfrListBox -font $lFont -text "Groups"]

    set ::capExtPrefs::nRootFrame $wfrPolyFrame

    set lListBoxName $pParent.wlsSelector

    variable wsbSelector [scrollbar $pParent.wsbSelector -command "$lListBoxName yview"]
    variable wlsSelector [listbox $lListBoxName -yscroll "$wsbSelector set" -font $lFont]

    set ::capExtPrefs::nListbox $wlsSelector

    set lIdx 0

    foreach lSection $::capExtPrefs::nSectionNames {
        set lSectionName $lSection
        $wlsSelector insert $lIdx $lSectionName
        incr lIdx
    }

    variable wfrButtons [labelframe $pParent.wfrButtons -font $lFont]

    variable wbtnApply [button $pParent.wbtnApply \
        -command "::capExtPrefs::capCBApply $pParent" \
        -padx 0 \
        -pady 0 \
        -text "Apply" -font $lFont]

    variable wbtnOK [button $pParent.wbtnOK \
        -command "::capExtPrefs::capCBOK $pParent" \
        -padx 0 \
        -pady 0 \
        -text "OK" -font $lFont]

    variable wbtnCancel [button $pParent.wbtnCancel \
        -command "::capExtPrefs::capCBCancel $pParent" \
        -padx 0 \
        -pady 0 \
        -text "Cancel" -font $lFont]

    variable wbtnHelp [button $pParent.wbtnHelp \
        -command "::capExtPrefs::capCBHelp $pParent" \
        -padx 0 \
        -pady 0 \
        -text "Help" -font $lFont]

    addToGrid $wfrWidgets $pParent 1 1 "news"

    addToGrid $wfrListBox $wfrWidgets 1 1 "news"
    addToGrid $wlsSelector $wfrListBox 1 1 "news"
    addToGrid $wsbSelector $wfrListBox 1 2 "news"

    # The poly frame where frames will be added and
    # removed as needed
    addToGrid $wfrPolyFrame $wfrWidgets 1 2 "news"

    addToGrid $wfrButtons $pParent 2 1 "news"
    addToGrid $wbtnApply $wfrButtons 1 1 "news"
    addToGrid $wbtnOK $wfrButtons 1 2 "news"
    addToGrid $wbtnCancel $wfrButtons 1 3 "news"
    addToGrid $wbtnHelp $wfrButtons 1 4 "news"

    grid rowconfigure $pParent 1 -weight 0 -minsize 350 -pad 0
    grid rowconfigure $pParent 2 -weight 0 -minsize 70 -pad 0
    grid columnconfigure $pParent 1 -weight 0 -minsize 550 -pad 0

    grid rowconfigure $wfrWidgets 1 -weight 0 -minsize 40 -pad 0
    grid columnconfigure $wfrWidgets 1 -weight 0 -minsize 230 -pad 0
    grid columnconfigure $wfrWidgets 2 -weight 0 -minsize 320 -pad 0

    grid rowconfigure $wfrListBox 1 -weight 1 -minsize 350 -pad 0
    grid columnconfigure $wfrListBox 1 -weight 0 -minsize 205 -pad 0
    grid columnconfigure $wfrListBox 2 -weight 0 -minsize 25 -pad 0

    grid rowconfigure $wfrButtons 1 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $wfrButtons 1 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $wfrButtons 2 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $wfrButtons 3 -weight 0 -minsize 0 -pad 0
    grid columnconfigure $wfrButtons 4 -weight 0 -minsize 0 -pad 0

    bind $wlsSelector <<ListboxSelect>> [list ::capExtPrefs::listBoxSelChanges %W]

    createCommandShellFrame $::capExtPrefs::nRootFrame
    createDesignDataFrame $::capExtPrefs::nRootFrame
    createFPViewerFrame $::capExtPrefs::nRootFrame
    createSchFrame $::capExtPrefs::nRootFrame
    createAnnotationFrame $::capExtPrefs::nRootFrame
    createDesignCacheFrame $::capExtPrefs::nRootFrame
    createCISettingFrame $::capExtPrefs::nRootFrame
	createDRCFrame $::capExtPrefs::nRootFrame
    
}

proc capExtPrefs::initSelection {} {
    removeWidgets
    $::capExtPrefs::nListbox selection set 0
    placeWidgets $::capExtPrefs::nDesignFrPlacer
}

proc capExtPrefs::createDesignDataFrame { pParent } {
    set lFont [getFont]

    variable wfrDesignData [$::capExtPrefs::nTopWidget $pParent.wfrDesignData \
        -width $::capExtPrefs::nPolyFrameWidth  \
        -height $::capExtPrefs::nPolyFrameHeight]
    variable wfrDesignOptions [labelframe $pParent.wfrDesignOptions]
    variable wcbContextBasedProps [checkbutton $pParent.wcbContextBasedProps \
        -variable ::capExtPrefs::nRotateInstPropInContext  \
        -command "capExtPrefs::setVar RotateInstPropInContext"  \
        -text "Context based instance properties"  \
        -font $lFont]
    variable wcbDrawPinArrows [checkbutton $pParent.wcbDrawPinArrows \
        -variable ::capExtPrefs::nDrawPinArrows  \
        -command "capExtPrefs::setVar DrawPinArrows"  \
        -text "Draw arrows on part input pins"  \
        -font $lFont]
    variable wcbEnableCommLegacy [checkbutton $pParent.wcbEnableCommLegacy \
        -variable ::capExtPrefs::nEnableLegacyITC  \
        -command "capExtPrefs::setVar EnableLegacyITC"  \
        -text "Enable communication with legacy tools"  \
        -font $lFont]
    variable wcbCheckReadOnlyOnViewActivate [checkbutton $pParent.wcbCheckReadOnlyOnViewActivate \
        -variable ::capExtPrefs::nCheckReadOnlyOnViewActivate  \
        -command "capExtPrefs::setVar CheckReadOnlyOnViewActivate"  \
        -text "Perform read-only check on tab switch"  \
        -font $lFont]
    variable wcbBackAnnotatePinNumbersOnly [checkbutton $pParent.wcbBackAnnotatePinNumbersOnly \
        -variable ::capExtPrefs::nBackAnnotatePinNumbersOnly   \
        -command "capExtPrefs::setVar BackAnnotatePinNumbersOnly"  \
        -text "Back annotate pin numbers only"  \
        -font $lFont]
    variable wcbSaveAsUpperCaseDsnName [checkbutton $pParent.wcbSaveAsUpperCaseDsnName \
        -variable ::capExtPrefs::nSaveAsUpperCaseDsnName   \
        -command "capExtPrefs::setVar SaveAsUpperCaseDsnName"  \
        -text "Save design name as UPPERCASE"  \
        -font $lFont]
    variable wcbEnableStartPage [checkbutton $pParent.wcbEnableStartPage \
        -variable ::capExtPrefs::nEnableStartPage   \
        -command "capExtPrefs::setVar EnableStartPage"  \
        -text "Load web page on startup"  \
        -font $lFont]
    variable wcbEnableGlobalNetITC [checkbutton $pParent.wcbEnableGlobalNetITC \
        -variable ::capExtPrefs::nEnableGlobalNetITC   \
        -command "capExtPrefs::setVar EnableGlobalNetITC"  \
        -text "Enable Global Net ITC"  \
        -font $lFont]
    variable wcbSaveImageAsBitmap [checkbutton $pParent.wcbSaveImageAsBitmap \
        -variable ::capExtPrefs::nSaveImageAsBitmap  \
        -command "capExtPrefs::setVar SaveImageAsBitmap"  \
        -text "Convert images to BMP format"  \
        -font $lFont]
    variable wcbCheckConnection [checkbutton $pParent.wcbCheckConnection \
        -variable ::capExtPrefs::nCheckConnection   \
        -command "capExtPrefs::setVar CheckConnection"  \
        -text "Check Internet connection"  \
        -font $lFont]

    variable wfrPathLookupSection [frame $pParent.wfrPathLookupSection]
    variable wlblPathLookupTimeout [label $pParent.wlblPathLookupTimeout \
        -text "Path lookup timeout (in seconds)"  \
        -font $lFont]
    variable wePathLookupTimeout [entry $pParent.wePathLookupTimeout \
        -validate key \
        -vcmd {expr {[string is int %P] && [string length %P]<3}} \
        -textvar ::capExtPrefs::nPathLookupTimeout \
        -width 5 \
        -font $lFont]

    variable wlblFrNetNameOptions [labelframe $pParent.wlblFrNetNameOptions \
        -text "Net Naming Options"  \
        -font $lFont]

    set lModes {}
    foreach lMode [array names ::capExtPrefs::nModeName2ModeId] {
        lappend lModes $lMode
    }

    variable wspNetNameOptions [spinbox $pParent.wspNetNameOptions \
        -command "capExtPrefs::setVar NetNameMode" \
        -width 30 \
        -state readonly \
        -values $lModes \
        -textvariable ::capExtPrefs::nNetNameMode \
        -font $lFont]

    variable wlblNetNameOptionsMsg [label $pParent.wlblNetNameOptionsMsg \
        -text "Requires application restart"  \
        -font $lFont]

    set lPlacer {}
    addWidget lPlacer $wfrDesignData $pParent 3 1 news

    addWidget lPlacer $wfrDesignOptions $wfrDesignData 1 1 news
    addWidget lPlacer $wcbContextBasedProps $wfrDesignOptions 1 1 w
    addWidget lPlacer $wcbDrawPinArrows $wfrDesignOptions 2 1 w
    addWidget lPlacer $wcbEnableCommLegacy $wfrDesignOptions 3 1 w
    addWidget lPlacer $wcbCheckReadOnlyOnViewActivate $wfrDesignOptions 4 1 w
    addWidget lPlacer $wcbBackAnnotatePinNumbersOnly  $wfrDesignOptions 5 1 w
    addWidget lPlacer $wcbSaveAsUpperCaseDsnName  $wfrDesignOptions 6 1 w
    addWidget lPlacer $wcbEnableStartPage  $wfrDesignOptions 7 1 w
    addWidget lPlacer $wcbEnableGlobalNetITC  $wfrDesignOptions 8 1 w
    addWidget lPlacer $wcbCheckConnection  $wfrDesignOptions 9 1 w
    addWidget lPlacer $wcbSaveImageAsBitmap  $wfrDesignOptions 10 1 w

    addWidget lPlacer $wfrPathLookupSection $wfrDesignData 2 1 news
    addWidget lPlacer $wlblPathLookupTimeout $wfrPathLookupSection 1 1 w
    addWidget lPlacer $wePathLookupTimeout $wfrPathLookupSection 1 2 w

    addWidget lPlacer $wlblFrNetNameOptions $wfrDesignData 3 1 news
    addWidget lPlacer $wlblNetNameOptionsMsg $wlblFrNetNameOptions 1 1 w
    addWidget lPlacer $wspNetNameOptions $wlblFrNetNameOptions 2 1 w

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrDesignData]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wfrDesignData]
    lappend lPlacer [format "grid rowconfigure %s 3 -weight 0 -minsize 0 -pad 0" $wfrDesignData]

    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrDesignData]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 3 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 4 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 5 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 6 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 7 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 8 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 9 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 10 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]

    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrDesignOptions]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrPathLookupSection]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrPathLookupSection]
    lappend lPlacer [format "grid columnconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wfrPathLookupSection]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrNetNameOptions]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrNetNameOptions]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrNetNameOptions]

    set ::capExtPrefs::nDesignFrPlacer $lPlacer
}

proc capExtPrefs::createCommandShellFrame {pParent} {

    set lFont [getFont]

    variable wfrCommandShell [$::capExtPrefs::nTopWidget $pParent.wfrCommandShell]

    variable wlblFrJournaling [labelframe $pParent.wlblFrJournaling -text "Journaling" -font $lFont]

    variable wcbEnableJournaling [checkbutton $pParent.wcbEnableJournaling \
        -variable ::capExtPrefs::nJournaling \
        -command "capExtPrefs::setVar ShellEnableJournaling $pParent.wcbFlushCommands $pParent.wcbDisplayCommands" \
        -text "Enable" \
        -font $lFont]

    set lFlushCBState normal
    set lCmdDisplayCBState normal

    if { 0 == $::capExtPrefs::nJournaling } {
        set lFlushCBState disabled
        set lCmdDisplayCBState disabled
    }

    variable wcbFlushCommands [checkbutton $pParent.wcbFlushCommands \
        -variable ::capExtPrefs::nFlushImmediate \
        -state $lFlushCBState \
        -command "capExtPrefs::setVar ShellFlushCommands" \
        -text "Flush Commands" \
        -font $lFont]

    variable wcbDisplayCommands [checkbutton $pParent.wcbDisplayCommands \
        -variable ::capExtPrefs::nDisplayCommands \
        -state $lCmdDisplayCBState \
        -command "capExtPrefs::setVar ShellDisplayCommands" \
        -text "Display Commands" \
        -font $lFont]    

    set lPlacer {}

    addWidget lPlacer $wfrCommandShell $pParent 1 2 news
    addWidget lPlacer $wlblFrJournaling $wfrCommandShell 1 1 news
    addWidget lPlacer $wcbEnableJournaling $wlblFrJournaling 1 1 w
    addWidget lPlacer $wcbFlushCommands $wlblFrJournaling 2 1 w
    addWidget lPlacer $wcbDisplayCommands $wlblFrJournaling 3 1 w

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrCommandShell]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrCommandShell]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]
    lappend lPlacer [format "grid rowconfigure %s 3 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]
    #    lappend lPlacer [format "grid columnconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]
    #    lappend lPlacer [format "grid columnconfigure %s 3 -weight 0 -minsize 0 -pad 0" $wlblFrJournaling]

    set ::capExtPrefs::nCommandShellFrPlacer $lPlacer
}

proc capExtPrefs::createFPViewerFrame { pParent } {

    set lFont [getFont]

    variable wfrFootprintViewer [$::capExtPrefs::nTopWidget $pParent.wfrFootprintViewer]
    variable wfrFPDisplayOptions [labelframe $pParent.wfrFPDisplayOptions \
        -text "Display Options"  \
        -font $lFont]
    variable wlblFrFPAppearance [labelframe $pParent.wlblFrFPAppearance \
        -text "Appearance"  \
        -font $lFont]
    variable wcbShowPinInfoInViewer [checkbutton $pParent.wcbShowPinInfoInViewer \
        -variable ::capExtPrefs::nViewerShowPinInfo  \
        -command "capExtPrefs::setVar ShowPinInfoInViewer"  \
        -text "Show pin information in viewer"  \
        -font $lFont]
    variable wcbMakeTransparent [checkbutton $pParent.wcbMakeTransparent \
        -variable ::capExtPrefs::nTransparencyOnHilite  \
        -command "capExtPrefs::setVar MakeTransparent"  \
        -text "Make objects transparent on highlight"  \
        -font $lFont]

    variable wlblBackgroundColorSampler [label $pParent.wlblBackgroundColorSampler -bg $::capExtPrefs::nFPBackgroundColor -width 15]

    variable wbtnFPBackgroundColor [button $pParent.wbtnFPBackgroundColor \
        -command "capExtPrefs::chooseColor ::capExtPrefs::nFPBackgroundColor {Select Footprint Viewer Background Color} $wlblBackgroundColorSampler -bg" \
        -text "Background Color"  \
        -font $lFont]

    variable wlblHighlightColorSampler [label $pParent.wlblHighlightColorSampler -bg $::capExtPrefs::nFPHighlightColor -width 15]

    variable wbtnHighlightColor [button $pParent.wbtnHighlightColor \
        -command "capExtPrefs::chooseColor ::capExtPrefs::nFPHighlightColor {Select Footprint Viewer Highlight Color} $wlblHighlightColorSampler -bg" \
        -text "Highlight Color"  \
        -font $lFont]

    ### FP Viewer Display Units

    variable wlblFrDisplayUnitsOptions [labelframe $pParent.wlblFrDisplayUnitsOptions \
        -text "Measurement Units"  \
        -font $lFont]

    set lModes {}
    foreach lMode [array names ::capExtPrefs::nDisplayUnitChoices] {
        lappend lModes $lMode
    }

    variable wspDisplayUnitsOptions [spinbox $pParent.wspDisplayUnitsOptions \
        -command "capExtPrefs::setVar DisplayUnits" \
        -width 30 \
        -state readonly \
        -values $lModes \
        -textvariable ::capExtPrefs::nDisplayUnit \
        -font $lFont]

    set lPlacer {}
    addWidget lPlacer $wfrFootprintViewer $pParent 4 1 news
    addWidget lPlacer $wfrFPDisplayOptions $wfrFootprintViewer 1 1 ns
    addWidget lPlacer $wlblFrFPAppearance $wfrFootprintViewer 2 1 ns
    addWidget lPlacer $wcbShowPinInfoInViewer $wfrFPDisplayOptions 1 1 w
    addWidget lPlacer $wcbMakeTransparent $wfrFPDisplayOptions 2 1 w

    addWidget lPlacer $wlblBackgroundColorSampler $wlblFrFPAppearance 1 1 we
    addWidget lPlacer $wbtnFPBackgroundColor $wlblFrFPAppearance 1 2 we

    addWidget lPlacer $wlblHighlightColorSampler $wlblFrFPAppearance 2 1 we
    addWidget lPlacer $wbtnHighlightColor $wlblFrFPAppearance 2 2 we

    addWidget lPlacer $wlblFrDisplayUnitsOptions $wlblFrFPAppearance 2 1 we
    addWidget lPlacer $wspDisplayUnitsOptions $wlblFrFPAppearance 2 2 we

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrFootprintViewer]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wfrFootprintViewer]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrFootprintViewer]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrFPDisplayOptions]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wfrFPDisplayOptions]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrFPDisplayOptions]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]
    lappend lPlacer [format "grid columnconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]
    lappend lPlacer [format "grid columnconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrFPAppearance]

    set ::capExtPrefs::nFPViewerFrPlacer $lPlacer
}

proc capExtPrefs::createSchFrame {pParent} {

    set lFont [getFont]

    variable wfrSch [$::capExtPrefs::nTopWidget $pParent.wfrSch]

    variable wlblFrSchDescend [labelframe $pParent.wlblFrSchDescend -text "Schematic Descend" -font $lFont]
    set ::capExtPrefs::nPageDescend ASK
    variable wrbPageDescendDefault [radiobutton $pParent.wrbPageDescendDefault \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Default" \
        -value "DEFAULT" \
        -variable ::capExtPrefs::nPageDescend]

    variable wrbPageDescendFirst [radiobutton $pParent.wrbPageDescendFirst \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "First Page" \
        -value "FIRST_PAGE" \
        -variable ::capExtPrefs::nPageDescend]

    variable wrbPageDescendAsk [radiobutton $pParent.wrbPageDescendAsk \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Ask" \
        -value "ASK" \
        -variable ::capExtPrefs::nPageDescend]

    variable wlblFrJunctionMode [labelframe $pParent.wlblFrJunctionMode -text "Junction Mode" -font $lFont]
    set ::capExtPrefs::nJunctionMode OnWireBreak
    variable wrbJunctionModeOnWireBreak [radiobutton $pParent.wrbJunctionModeOnWireBreak \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Junction on wire break only (default)" \
        -value "OnWireBreak" \
        -variable ::capExtPrefs::nJunctionMode]

    variable wrbJunctionModeOnMultipleConnectionsAtWireEnd [radiobutton $pParent.wrbOnMultipleConnectionsAtWireEnd \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Junction on multiple connections at wire end" \
        -value "OnMultipleConnectionsAtWireEnd" \
        -variable ::capExtPrefs::nJunctionMode]

    set lPlacer {}

    addWidget lPlacer $wfrSch $pParent 1 2 news
    addWidget lPlacer $wlblFrSchDescend $wfrSch 1 1 news
    addWidget lPlacer $wlblFrJunctionMode $wfrSch 2 1 news
    addWidget lPlacer $wrbPageDescendDefault $wlblFrSchDescend 1 1 news
    addWidget lPlacer $wrbPageDescendFirst $wlblFrSchDescend 1 2 news
    addWidget lPlacer $wrbPageDescendAsk $wlblFrSchDescend 1 3 news
    addWidget lPlacer $wrbJunctionModeOnWireBreak $wlblFrJunctionMode 1 1 news
    addWidget lPlacer $wrbJunctionModeOnMultipleConnectionsAtWireEnd $wlblFrJunctionMode 2 1 news
    

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrSch]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 1 -minsize 0 -pad 0" $wfrSch]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrSch]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrSchDescend]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrSchDescend]
    lappend lPlacer [format "grid columnconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrSchDescend]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrJunctionMode]
    lappend lPlacer [format "grid rowconfigure %s 2 -weight 0 -minsize 0 -pad 0" $wlblFrJunctionMode]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrJunctionMode]
    

    set ::capExtPrefs::nSchFrPlacer $lPlacer
}

proc capExtPrefs::createAnnotationFrame {pParent} {

    set lFont [getFont]

    variable wfrAnn [$::capExtPrefs::nTopWidget $pParent.wfrAnn]

    variable wlblFrAnnotationHetroParts [labelframe $pParent.wlblFrAnnotationHetroParts -text "Heterogeneous Parts Annotation" -font $lFont]
    # set ::capExtPrefs::nHetroAnnotationOption FIRST_MATCH
    variable wrbAnnotationHetroDefault [radiobutton $pParent.wrbAnnotationHetroDefault \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Default" \
        -value "DEFAULT" \
        -variable ::capExtPrefs::nHetroAnnotationOption]

    variable wrbAnnotationHetroFirstMatch [radiobutton $pParent.wrbAnnotationHetroFirstMatch \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "First Match" \
        -value "FirstMatch" \
        -variable ::capExtPrefs::nHetroAnnotationOption]

    set lPlacer {}

    addWidget lPlacer $wfrAnn $pParent 1 2 news
    addWidget lPlacer $wlblFrAnnotationHetroParts $wfrAnn 1 1 news
    addWidget lPlacer $wrbAnnotationHetroDefault $wlblFrAnnotationHetroParts 1 1 news
    addWidget lPlacer $wrbAnnotationHetroFirstMatch $wlblFrAnnotationHetroParts 1 2 news

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrAnn]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrAnn]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrAnnotationHetroParts]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrAnnotationHetroParts]

    set ::capExtPrefs::nAnnotationFrPlacer $lPlacer
}

proc capExtPrefs::createDesignCacheFrame {pParent} {

    set lFont [getFont]

    variable wfrUpdateCache [$::capExtPrefs::nTopWidget $pParent.wfrUpdateCache]

    variable wlblFrDesignCache [labelframe $pParent.wlblFrDesignCache -text "Update Cache" -font $lFont]
    # set ::capExtPrefs::nHetroAnnotationOption FIRST_MATCH
    variable wrbUpdateCacheNone [radiobutton $pParent.wrbUpdateCacheNone \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Default" \
        -value "NONE" \
        -variable ::capExtPrefs::nUpdateCache]

    variable wrbUpdaeCacheForced [radiobutton $pParent.wrbUpdaeCacheForced \
        -anchor "nw" \
        -borderwidth 0 \
        -justify "left" \
        -padx 2 \
        -pady 0 \
        -text "Forced" \
        -value "TRUE" \
        -variable ::capExtPrefs::nUpdateCache]

    set lPlacer {}

    addWidget lPlacer $wfrUpdateCache $pParent 1 2 news
    addWidget lPlacer $wlblFrDesignCache $wfrUpdateCache 1 1 news
    addWidget lPlacer $wrbUpdateCacheNone $wlblFrDesignCache 1 1 news
    addWidget lPlacer $wrbUpdaeCacheForced $wlblFrDesignCache 1 2 news

    lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrUpdateCache]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrUpdateCache]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrDesignCache]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblFrDesignCache]

    set ::capExtPrefs::nUpdateCacheFrPlacer $lPlacer
}

proc capExtPrefs::createCISettingFrame {pParent} {
    
    set lFont [getFont]
    
    variable wfrCisOption [$::capExtPrefs::nTopWidget $pParent.wfrCisOption]
    
    variable wlblCisOptions [labelframe $pParent.wlblCisOptions]
    
    set ::capExtPrefs::nCISQueryAllTable 0
    set tempVal [GetOptionString QueryAllTables]
    if {$tempVal != "" && [string toupper $tempVal] == [string toupper "True"]} {
        
        set ::capExtPrefs::nCISQueryAllTable 1
    } 

    set ::capExtPrefs::nCISQueryStringMatch 0
    set tempVal [GetOptionString QueryStringMatch]
    if {$tempVal != "" && [string toupper $tempVal] == [string toupper "True"]} {
        set ::capExtPrefs::nCISQueryStringMatch 1
    }    

    set ::capExtPrefs::nCISDisableRegionalSetting 0
    set tempVal [GetOptionString CISRegionalSetting]
    if {$tempVal != "" && [string toupper $tempVal] == [string toupper "False"]} {
        set ::capExtPrefs::nCISDisableRegionalSetting 1
    } 
    
    variable varQueryAllTables [checkbutton $pParent.varQueryAllTables \
        -variable ::capExtPrefs::nCISQueryAllTable  \
        -text "Query All Configured Tables"  \
        -font $lFont]
        
    variable varQueryStringMatch [checkbutton $pParent.varQueryStringMatch \
        -variable ::capExtPrefs::nCISQueryStringMatch  \
        -text "Query String Match"  \
        -font $lFont]

    variable varRegionalSettingMatch [checkbutton $pParent.varRegionalSettingMatch \
        -variable ::capExtPrefs::nCISDisableRegionalSetting  \
        -text "Disable Regional Setting"  \
        -font $lFont]

    set lPlacer {}
    
    addWidget lPlacer $wfrCisOption $pParent 1 2 news
    addWidget lPlacer $wlblCisOptions $wfrCisOption 1 1 news
    addWidget lPlacer $varQueryAllTables $wlblCisOptions 1 1 news
    addWidget lPlacer $varQueryStringMatch $wlblCisOptions 2 1 w
    addWidget lPlacer $varRegionalSettingMatch $wlblCisOptions 2 1 w

    
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrCisOption]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrCisOption]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblCisOptions]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblCisOptions]
    
    set ::capExtPrefs::nCISSettingFrPlacer $lPlacer
}

proc capExtPrefs::createDRCFrame {pParent} {
    
    set lFont [getFont]
    
    variable wfrDRCOption [$::capExtPrefs::nTopWidget $pParent.wfrDRCOption]
    
    variable wlblDRCOptions [labelframe $pParent.wlblDRCOptions]

    
    variable wcbDisplayWaivedDRC [checkbutton $pParent.wcbDisplayWaivedDRC \
        -variable ::capExtPrefs::nDisplayWaivedDRC \
        -text "Display Waived DRC" \
		-command "capExtPrefs::setVar DisplayWaivedDRC"  \
        -font $lFont]


	
	 set lPlacer {}
	 addWidget lPlacer $wfrDRCOption $pParent 1 2 news
	 addWidget lPlacer $wlblDRCOptions $wfrDRCOption 1 1 news
	 addWidget lPlacer $wcbDisplayWaivedDRC $wlblDRCOptions 1 1 news
	
	lappend lPlacer [format "grid rowconfigure %s 1 -weight 1 -minsize 0 -pad 0" $wfrDRCOption]
	lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wfrDRCOption]
    lappend lPlacer [format "grid rowconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblDRCOptions]
    lappend lPlacer [format "grid columnconfigure %s 1 -weight 0 -minsize 0 -pad 0" $wlblDRCOptions]
	 
	 set ::capExtPrefs::nDRCSettingPlacer $lPlacer


}


proc capExtPrefs::launchForm {args} {
    set lForm .generic
    if { "" == [info commands $lForm]} {
        createGenericStructure [capAppUtils::capTopLevel $lForm]
        capAppUtils::setWindowSize $lForm 575 450 575 450
        wm title $lForm "Extended Preferences Setup"
        capAppUtils::autoAdoptWindow $lForm
    }

    if { 0 == [winfo ismapped $lForm]} {
        wm deiconify $lForm
    }
    # initialize form data
    initValues
    initSelection
}
# end of file

