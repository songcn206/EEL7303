#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capApps.tcl
#            Sample Tcl/Tk Applications registration table
#/////////////////////////////////////////////////////////////////////////////////

namespace eval capApps {}

catch {package require capExtPrefs}
catch {package require Capture}
catch {package require capPdfLaunch}
catch {package require capCommServerLaunch}
catch {package require capFindReplaceTextLaunch}
catch {package require capSessionUtil}
catch {package require capCheckLibLaunch}
catch {package require capAnnotateHBlockPageNumberLaunch}
catch {package require capReplacePathInCacheUtilLaunch}
catch {package require capCustomizePageLaunch}
catch {package require capDesCompare}

package provide capApps 1.0

# This script provides a framework for automatically adding Tcl/Tk 
# application samples to the application launcher form
#
# Usage: Identify the section which the new application would be 
#        a part of. If no such section is present create one. A
#        section is identified by a top level string. Add an entry
#        to the section. A entry should comprise of five fields as
#        shown below.
#        
# Structure of a section:
#    { 
#        section name
#        "Design Utilities"
#        {
#              app name             app title                  app callback      description         source code file
#            {"PDFExport"          "PDF Export"               "capCBPDFExport"  "Description Text" "implementation file" }
#        }
#    }

#Sample Apps
#{ 
#    "Design Utilities"
#    {
#        {
#         "PDFExport" 
#         "PDF Export"
#         "capCBPDFExport"
#         "Exports the selected design to PDF format with cross-references and properties"
#         "capPDF.tcl"
#        }
#    }
#}
#{
#    "Application Utilities"
#    {
#        {   "ExtPrefs" 
#            "Extended Preferences" 
#            "capCBExtendedPrefs" 
#            "Extended application preferences setting." 
#            "./capForms/capExtPrefs.tcl"
#        }
#    }
#}

proc capApps::getApps {} {
    set lAppList {
        {
            "Application Utilities"
            {
                {   "CommServer" 
                    "Communication Server" 
                    "capCommServerLaunch::launch" 
                    "Capture communication server" 
                    "./capUtils/capCommServerLaunch.tcl"
                }
		
		{   "ExtPrefs" 
                    "Extended Preferences" 
                    "capExtPrefs::launchForm" 
                    "Extended application preferences settings." 
                    "capForms/capExtPrefs.tcl"
                }
		
		{   "EnumerateOpenLibsAndDesigns" 
                    "Show All Open Libraries And Designs" 
                    "::capSessionUtil::enumerateOpenLibsAndDesigns" 
                    "Displays the list of all open libraries and designs in the current session. Output is displayed in the session log." 
                    "./capUtils/capSessionUtil.tcl"
                }
            }
        }
	{ 
	    "Design Utilities"
	    {
		{
		 "Annotate HBlock Page Number" 
		 "Annotate H Block Page Number"
		 "capAnnotateHBlockPageNumberLaunch::launch"
		 "Adds Page Number to the H Block as User Property. The design needs to be closed to run the script. A backup of the design will be created as <name><pid><clock>. Output is displayed in the Command Window. "
		 "./capUtils/capAnnotateHBlockLaunch.tcl"
		}
		{
		 "FindReplaceText" 
		 "Find And Replace Text"
		 "capFindReplaceTextLaunch::launch"
		 "Finds and replaces text in the active design. Output is displayed in the session log."
		 "./capForms/capFindReplaceTextLaunch.tcl"
		}
		
		{
		 "PDFExport" 
		 "PDF Export"
		 "capPdfLaunch::init"
		 "Exports the selected design to PDF format with cross-references and properties"
		 "./capUtils/capPdfLaunch.tcl"
		}
		
		{
		 "Replace Cache Path In Design Cache" 
		 "Replace Path In Design Cache"
		 "capReplacePathInCacheUtilLaunch::launch"
		 "Replace Path In the Design Cache. The Part replaced are displayed in the session log. "
		 "./capUtils/capReplacePathInCacheUtilLaunch.tcl"
		}
            {
		 "CompareDesigns" 
		 "Compare and merge two Capture designs"
		 "capDesCompare::launch"
		 "Compares two capture designs and show the differences in tree view. It also allows selective mergeing of design data "
		 "./capForms/capDesCompare.tcl"
		}

		
	    }
	}
        { 
	    "Library Utilities"
	    {
		{
		 "CheckLibrary" 
		 "Check And Correct Library"
		 "capCheckLibLaunch::launch"
		 "Check and correct library for package errors. On performing the library correction, a backup of the library will be created as <name><pid><clock>"
		 "./capForms/capCheckLibLaunch.tcl"
		}
	    }
	}
        { 
	    "Page Utilities"
	    {
		{
		 "CustomizePage" 
		 "Customize Page (On Creation)"
		 "capCustomizePageLaunch::launch"
		 "Specify TCL callback procedures to be called on Page creation and attribute(size) change"
		 "./capForms/capCustomizePageLaunch.tcl"
		}
	    }
	}
	{
            "Scripting Documentation"
            {
                {"HelpPDF"
                 "Help on Scripting"
                 "capAppLaunch::appLaunchFormHelp"
                 "Launches the application notes PDF document. This contains installation steps, samples and other useful information."
                 ""
                }
            }
        }
    }
    return $lAppList
}

# end of file

