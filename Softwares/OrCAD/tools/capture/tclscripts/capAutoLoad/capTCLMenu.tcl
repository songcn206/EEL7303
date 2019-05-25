#/////////////////////////////////////////////////////////////////////////////////
# WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS  AND IS AVAILABLE AS IS
#           AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#TCL file: sample.tcl
#/////////////////////////////////////////////////////////////////////////////////


package provide capTCLMenu 1.0

namespace eval ::capTCLMenu {

	proc registerMenuActions { args } {
        catch {
          RegisterAction "ScopeChangeTag" "::capTCLMenu::shouldProcess" "" "::capTCLMenu::capTCLMenuScope" ""
          #RegisterAction "MenuTag" "::capTCLMenu::shouldProcess" "" "::capTCLMenu::CanAddMenu" ""
        }
    }

    proc shouldProcess { args } {
        return 1
    }

    proc capTCLMenuScope { args } {
		
		set result [::SetCurrentScope $args]
    }

    proc CanAddMenu { args } {

        set menuName [lindex $args 0]
        set scope [lindex $args 1]

        if { [string compare $scope "PROJECT_MANAGER_VIEW"] == 0 } {

            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUndo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRedo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCustomize"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "PART_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileEmpty"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "SCHEMATIC_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileSaveAs"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "PROPERTY_EDITOR_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileSaveAs"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportDesign"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportDesign"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "HTML_VIEW"] == 0 } {

            if { [string compare $menuName "FileClose"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUndo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRedo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCut"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPaste"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowNewWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindows"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindowsExceptCurrent"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "LOG_VIEW"] == 0 } {

            if { [string compare $menuName "FileClose"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUndo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRedo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCut"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPaste"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindows"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindowsExceptCurrent"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "SYMBOL_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSamples"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "VHDL_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "View"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCustomize"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowNewWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindows"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindowsExceptCurrent"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "TEXT_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintPreview"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrint"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintSetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVerilogSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "View"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCustomize"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowNewWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindows"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindowsExceptCurrent"] == 0 } {
                return false
            }

            return true
        }
        if { [string compare $scope "VERILOG_VIEW"] == 0 } {

            if { [string compare $menuName "FileCheckandSave"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileArchiveProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileImportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileExportSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "FilePrintAreaClear"] == 0 } {
                return false
            }
            if { [string compare $menuName "FileChangeProduct"] == 0 } {
                return false
            }
            if { [string compare $menuName "Design"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematic"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSchematicPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVHDLFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewVerilogFile"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewPartfromSpreadsheet"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignNewSymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRename"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignRemoveOccurrenceProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignMakeRoot"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignReplaceCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignUpdateCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "DesignCleanupCache"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRepeat"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelState"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateGoto"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLabelStateDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDelete"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUnLock"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditUngroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowse"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseParts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseFlatNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseHierarchicalPorts"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseTitleBlocks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseBookmarks"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowseDRCMarkers"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditBrowsePowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditSelectAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditProject"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditObjectProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRenamePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditDeletePartProperty"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirror"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorHorizontally"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorVertically"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditMirrorBoth"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditRotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditGlobalReplace"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocation"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinName"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditResetLocationPinNumber"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditInvokeUI"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditCheckVHDLSyntax"] == 0 } {
                return false
            }
            if { [string compare $menuName "EditClearSessionLog"] == 0 } {
                return false
            }
            if { [string compare $menuName "View"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNormal"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewConvert"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPackage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewShowFootprint"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviousPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewAscendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewDescendHierarchy"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeUp"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeDown"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSynchronizeAcross"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGoTo"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoom"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomIn"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomOut"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomScale"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomArea"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomAll"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomSelection"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewZoomRedraw"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewToolbarCustomize"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewStatusBar"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewCommandWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGrid"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewGridReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewSelectionFilter"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewPreviouspage"] == 0 } {
                return false
            }
            if { [string compare $menuName "ViewNextPage"] == 0 } {
                return false
            }
            if { [string compare $menuName "Analysis"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSILibrarySetup"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAutoAssignDiscreteSIModels"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisIdentifyDCNets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssignSIModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExploreSignal"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportTopology"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisImportElectricalConstraintsets"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveECSetassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisAssociateECSet"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateECSetAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisValidateSIModelAssignments"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisSIModelIntegrity"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisExportSImodelsused"] == 0 } {
                return false
            }
            if { [string compare $menuName "AnalysisRemoveSImodelassignements"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBackAnnotate"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsUpdateProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "TestBench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Create Test Bench"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diff and Merge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsDesignRulesCheck"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCompareAndMerge"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateNetlist"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCreateDifferentialPair"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsCrossReference"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsInterSheetReferences"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsBillofMaterials"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsImportProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsGeneratePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsExportFPGA"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSplitPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssignPowerPins"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsAssociatePSpiceModel"] == 0 } {
                return false
            }
            if { [string compare $menuName "ToolsSynchNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Place"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePinArray"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PSpiceComponent"] == 0 } {
                return false
            }
            if { [string compare $menuName "Passive"] == 0 } {
                return false
            }
            if { [string compare $menuName "Resistor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Capacitor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Inductor"] == 0 } {
                return false
            }
            if { [string compare $menuName "Potentiometer"] == 0 } {
                return false
            }
            if { [string compare $menuName "Coupling"] == 0 } {
                return false
            }
            if { [string compare $menuName "Ideal Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Lossy Transmission Lines"] == 0 } {
                return false
            }
            if { [string compare $menuName "Discrete"] == 0 } {
                return false
            }
            if { [string compare $menuName "Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP"] == 0 } {
                return false
            }
            if { [string compare $menuName "NPN Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "PNP Darlington"] == 0 } {
                return false
            }
            if { [string compare $menuName "NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "PMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power NMOS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Power Diode"] == 0 } {
                return false
            }
            if { [string compare $menuName "N-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "P-JFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "IGBT"] == 0 } {
                return false
            }
            if { [string compare $menuName "GAsFET"] == 0 } {
                return false
            }
            if { [string compare $menuName "Operation Amplifier"] == 0 } {
                return false
            }
            if { [string compare $menuName "Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Controlled Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "VCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCVS"] == 0 } {
                return false
            }
            if { [string compare $menuName "CCCS"] == 0 } {
                return false
            }
            if { [string compare $menuName "Current Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Current Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Voltage Sources"] == 0 } {
                return false
            }
            if { [string compare $menuName "AC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "DC Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Pulsed Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Exponential Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "frequency-modulated Sine Voltage Source"] == 0 } {
                return false
            }
            if { [string compare $menuName "Digital"] == 0 } {
                return false
            }
            if { [string compare $menuName "Gates"] == 0 } {
                return false
            }
            if { [string compare $menuName "AND"] == 0 } {
                return false
            }
            if { [string compare $menuName "OR"] == 0 } {
                return false
            }
            if { [string compare $menuName "NAND"] == 0 } {
                return false
            }
            if { [string compare $menuName "NOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "XOR"] == 0 } {
                return false
            }
            if { [string compare $menuName "INV"] == 0 } {
                return false
            }
            if { [string compare $menuName "Flip Flop"] == 0 } {
                return false
            }
            if { [string compare $menuName "D"] == 0 } {
                return false
            }
            if { [string compare $menuName "JK"] == 0 } {
                return false
            }
            if { [string compare $menuName "RS"] == 0 } {
                return false
            }
            if { [string compare $menuName "T"] == 0 } {
                return false
            }
            if { [string compare $menuName "ADC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "DAC"] == 0 } {
                return false
            }
            if { [string compare $menuName "8 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "10 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "12 Bit"] == 0 } {
                return false
            }
            if { [string compare $menuName "Memory"] == 0 } {
                return false
            }
            if { [string compare $menuName "RAM"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "8K x 8"] == 0 } {
                return false
            }
            if { [string compare $menuName "ROM"] == 0 } {
                return false
            }
            if { [string compare $menuName "32K x 1"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceParameterizedPart"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWire"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireTwoPoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireMultiplePoints"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceAutoWireConnecttoBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBus"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceJunction"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBusEntry"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetAlias"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePower"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceGround"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOffPageConnector"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPort"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceHierarchicalPin"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNoConnect"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceIEEESymbol"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceTitleBlock"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBookmark"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceText"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceLine"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceRectangle"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipse"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceEllipticalArc"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceBezierCurve"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePolyline"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlacePicture"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceOleObject"] == 0 } {
                return false
            }
            if { [string compare $menuName "PlaceNetGroup"] == 0 } {
                return false
            }
            if { [string compare $menuName "Macro"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroConfigure"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroPlay"] == 0 } {
                return false
            }
            if { [string compare $menuName "MacroRecord"] == 0 } {
                return false
            }
            if { [string compare $menuName "Accessories"] == 0 } {
                return false
            }
            if { [string compare $menuName "AccessoriesAssociateDLL's"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsDesignProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsSchematicPageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPartProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "OptionsPackageProperties"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowNewWindow"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindows"] == 0 } {
                return false
            }
            if { [string compare $menuName "WindowClosechildWindowsExceptCurrent"] == 0 } {
                return false
            }

            return true
        }
     return true
    }
}

::capTCLMenu::registerMenuActions

#end of file
