#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capWebPageActions.tcl
#/////////////////////////////////////////////////////////////////////////////////

namespace eval ::capWebPageActions {

    catch {
        RegisterAction "_cdnOrHtmlOnGotoLink"  ::capWebPageActions::shouldProcess "" capWebPageActions::processNavigation ""
        RegisterAction "_cdnOrHtmlOnNewWindow" ::capWebPageActions::shouldProcess "" capWebPageActions::processNewWindow ""        
    }

    array set nStrToId {
        "Help"          900
        "Documentation" 5518
        "Tutorial"      906
        "OpenProject"   13928
        "NewProject"    13926
        "OpenDesign"    2187
        "NewDesign"     2185
    }    

    proc shouldProcess { args } {
        return 1
    }

    proc getId { pStr } {

        set lRet ""
        catch {
            set lRet $::capWebPageActions::nStrToId($pStr)
        }
        return $lRet
    }

    proc processNativeURL { pURL } {
        catch {
            ShowDialog 1
            switch -regexp $pURL {
                orcad://open_project { MenuCommand [getId "OpenProject"] }
                orcad://new_project { MenuCommand [getId "NewProject"] }
                orcad://open_design { MenuCommand [getId "OpenDesign"] }
                orcad://new_design { MenuCommand [getId "NewDesign"] }
                orcad://set_start_page { 
                    regexp {(orcad://set_start_page/)(.*)} $pURL lAll lPrefix lLabel
                    SetOptionString "Start Page Label" $lLabel
                }
                orcad://refresh_start_page { RefreshStartPage }
                orcad://help { MenuCommand [getId "Help"]}
                orcad://documentation { MenuCommand [getId "Documentation"]}
                orcad://tutorial { MenuCommand [getId "Tutorial"]}
                orcad://OrCADMarketPlace { OpenURL http://OrCADMarketPlace.ema-eda.com MarketPlace }
		orcad://azure_start { processAzureCall "azure_start" }
		orcad://azure_open_project { processAzureCall "azure_open_project" }
		orcad://azure_save_project { processAzureCall "azure_save_project" }
		orcad://azure_configuration { processAzureCall "azure_configuration" }
            }
            ShowDialog 0
        }
    }

    proc processURL { pURL } {
        set lRet 0        
        switch -regexp $pURL {
            ^orcad:.* { 
                processNativeURL $pURL 
                set lRet 0
            } 
            default { 
                set lRet 1
            }
        }
        return $lRet
    }

    proc processNewWindow { args } {
        return [processURL $args]
    }

    proc processNavigation { args } {
        return [processURL $args]
    }
    
    proc processAzureCall { pCommand } {
	 
	 if { [catch {package require capAzureIntegrator}] } {
		set lMessage "Capture Azure package is not installed. This package is available for download from Cadence OrCAD Capture Marketplace"
		set lMessageCstr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageCstr
		tk_messageBox -type ok -message $lMessage -title "Capture Azure"
	} else {
		switch $pCommand {
			azure_start { 
				catch {::capAzureIntegrator::capOnAzureStart}
			}
			azure_open_project { 
				catch {::capAzureIntegrator::capOnAzureOpen}
			}
			azure_save_project { 
				catch {::capAzureIntegrator::capOnAzureSave} 
			}
			azure_configuration { 
				catch {::capAzureIntegrator::capOnAzureConfigure} 
			}
		}
	}
    }
    
    proc getAzureAppVersion {  } {
	 
	 set lResult "-1"
	 if { [catch {package require capAzureIntegrator}] } {
		set lResult "-1"
	} else {
		set lResult [package require capAzureIntegrator]
	}
	
	return $lResult
    }
}

# end of file

