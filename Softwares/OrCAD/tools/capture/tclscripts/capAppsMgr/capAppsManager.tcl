#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAppsManager.tcl

#  File location : <installation dir>/tools/capture/tclscripts/capAutoLoad folder
#  Purpose       : The capAppsManager provides a Tcl interface for querying, adding
#                  removing applications from the Tcl Applications Dashboard

#----------------------------
#      DETAILED DESCRIPTION
#----------------------------
# COMMANDS:
#       This package provides the following external commands:
#  
#  1. capAppsManager::createAppEntry <AppId> <AppName> <EntryProc> <Description> <Source path>
#      arguments: 
#          <AppId>          - Application ID, string with no spaces 
#          <AppName>        - Name that will be displayed in the Tcl Applications Dashboard
#          <EntryProc>      - The Tcl procedure that will be called when the user launches the application from the Dashboard
#          <Description>    - A description of what the application does; this will be displayed in the "Description" section of the Dashboard
#          <Source Path>    - Path to the source file relative to the tclscripts folder
#      return value:
#          An AppEntry object that is used as an argument to the capAppsManager::addApp procedure
#  
#  2. capAppsManager::getGroups
#      return value:
#          A Tcl list of the groups currently available in the dashboard
#  
#  3. capAppsManager::getGroupApps <Group Name>
#      arguments:
#          <Group Name>      - The name of a Application group
#  
#      return value:
#          A Tcl list of AppIds currently registered with the group
#  
#  4. capAppsManager::addApp <Group Name> <AppEntry object>
#      arguments:
#          <Group Name>      - The name of the application group to which the application is added
#          <AppEntry Object> - The application entry created using the capAppsManager::createAppEntry procedure
#  
#  5. capAppsManager::removeApp <AppId>
#      arguments:
#          <AppId>           - The AppId of the application to be removed
#  
#  6. capAppsManager::getApp <AppId>
#      arguments:
#          <AppId>           - The AppId of the relevant application
#    
#      return value:
#          The AppEntry object corresponding to the AppId if present, otherwise an empty list
#
#----------------------------------------------------------------------------------------------
#
#  Important Notes:
#  - The AppId should be a unique string without any spaces
#  - An AppEntry object is created by the capAppsManager::createAppEntry procedure
#  - For the changes to be visible in the Application Dashboard once an application is added or removed,
#    the application dashboard needs to be closed by clicking on the "cross" on the top right hand side
#    of the dialog
#
#----------------------------------------------------------------------------------------------
#
#  USAGE EXAMPLE:
#  a. Create a new AppEntry object:
#       set infoApp [capAppsManager::createAppEntry "InfoApp" "Custom Property Queries" "capInfoAppRun" "Search objects based on custom queries and modify their properties" "./capInfoApp/capInfoApp.tcl"]
#
#     where capInfoRun is a wrapper procedure: proc capInfoAppRun {args} {capInfoApp::run} 
#
#  b. Add the newly created AppEntry object to the dashboard, under the "Design Utilities" Group
#       capAppsManager::addApp "Design Utilities" $infoApp
#
#  c. To remove the InfoApp application
#       capAppsManager::removeApp "InfoApp"
#  
#/////////////////////////////////////////////////////////////////////////////////

catch {
    package require capApps
    wm withdraw .
}

package provide capAppsManager 1.0

namespace eval capAppsManager {
    variable n_AppList
}

proc capAppsManager::createAppEntry {pId pName pInitProc pDesc pSource} {
    return [list $pId $pName $pInitProc $pDesc $pSource]
}

proc capAppsManager::getGroups {} {
    set lGroups {}
    foreach lAppGroup [capApps::getApps] {
        lappend lGroups [lindex $lAppGroup 0]
    }

    return $lGroups
}

proc capAppsManager::getGroupApps {pGroup} {
    set lApps {}
    foreach lEl [capApps::getApps] {
        set lGroup [lindex $lEl 0]
        set lGroupApps [lindex $lEl 1]
        if {$pGroup == $lGroup} {
            set lApps $lGroupApps
            break
        }
    }
    return $lApps
}

proc capAppsManager::getApp {pAppId} {
    set lRet {} 
    set lDone 0
    foreach lEl [capApps::getApps] {
        set lGroupApps [lindex $lEl 1]
        foreach lApp $lGroupApps {
            set lAppId [lindex $lApp 0]
            if {$lAppId == $pAppId} {
                set lRet $lApp
                set lDone 1
                break
            }
            if {$lDone == 1} {
                break
            }
        }
        if {$lDone == 1} {
            break
        }
    }
    return $lRet
}

proc capAppsManager::findGroupIndex {pGroup} {
    set lRet -1
    set idx 0

    set lNewApps {}
    foreach lEl [capApps::getApps] {
        set lGroup [lindex $lEl 0]
        if {$pGroup == $lGroup} {
            set lRet $idx
            break
        }
        incr idx
    }

    return $lRet
}

proc capAppsManager::findAppIndex {pAppId pGroupApps} {
    set lRet -1
    set idx 0

    foreach lApp $pGroupApps {
       set lAppId [lindex $lApp 0]
       if {$lAppId == $pAppId} {
           set lRet $idx
           break
       }
       incr idx
    }

    return $lRet
}

proc capAppsManager::addApp {pGroup pApp} {
    set lApps [capAppsManager::getGroupApps $pGroup]
    if {0 != [llength $lApps]} {
        lappend lApps $pApp
    }

    set lApps [list $pGroup $lApps]

    set lGroupIdx [capAppsManager::findGroupIndex $pGroup]
    if {$lGroupIdx == -1} {
        lappend ::capAppsManager::n_AppList [list $pGroup $pApp]
    } else {
        set ::capAppsManager::n_AppList [lreplace $::capAppsManager::n_AppList $lGroupIdx $lGroupIdx $lApps]
    }
}

proc capAppsManager::removeApp {pGroup pAppId} {
    set lApps [capAppsManager::getGroupApps $pGroup]
    if {0 == [llength $lApps]} {
        return
    }

    set lAppIndex [findAppIndex $pAppId $lApps]

    if {$lAppIndex != -1} {
        set lApps [lreplace $lApps $lAppIndex $lAppIndex]
    }

    set lGroupIndex [findGroupIndex $pGroup]

    set ::capAppsManager::n_AppList [lreplace $::capAppsManager::n_AppList $lGroupIndex $lGroupIndex [list $pGroup $lApps]]
}

proc capAppsManager::getApps {} {
    return $::capAppsManager::n_AppList
}

proc capAppsManager::init {} {
    rename ::capApps::getApps ::capApps::getDefaultApps
    set ::capAppsManager::n_AppList [::capApps::getDefaultApps]
    rename ::capAppsManager::getApps ::capApps::getApps
}

capAppsManager::init


