#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2009 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - capinit_internal.tcl
#             DO NOT modify this file

proc capGetLocalTclTkDir {} {
    return [file join [capGetCdnDefaultScriptsDir] capTclTk lib]
}

proc capLoadTclFramework {} {
    set lTclFrameworkDir [file join [file dirname [info nameofexecutable]] .. tcltk 8.4 lib]

    set lSourceList {
        auto.tcl
        package.tcl
    }

    puts " "
    puts "Initializing Tcl/Tk..."
    foreach lSource $lSourceList {
        set lFullPath [file join $lTclFrameworkDir $lSource]
        puts "    Loading $lFullPath..."
        catch { source $lFullPath }
    } 
    puts "Done"
}

proc capTclTkInitializeInternal {} {
    if { [catch {package require Tk 8.4}] } {
        lappend ::auto_path [capGetLocalTclTkDir]
        capLoadTclFramework
    } else {
        catch { wm withdraw . } 
    }
}

proc bgerror { pMessage } {
    puts "Error : $pMessage"
}

set gCapFastLoadRootDir  [file dirname [info script]]
set gCapFastLoadedPackages { }
set gCapFastLoadDllSuffix ".dll"
if { 1 == [regexp {.*_g\.exe$} [info nameofexecutable]] } {
    set gCapFastLoadDllSuffix "_g.dll"
}

proc ::capFastPackageRequire { pPackageName }  {

	variable gCapFastLoadRootDir
	variable gCapFastLoadedPackages
	variable gCapFastLoadDllSuffix
	
	if { [lsearch $::gCapFastLoadedPackages $pPackageName] != -1 } {
		return 1
	}
		
	set lPackageList {
		  capAdvancedSave capAdvancedSaveFramework/tcl/capAdvancedSave.tcl
		  capAppsManager capAppsMgr/capAppsManager.tcl
		  capDesignUtil capDB/capDesignUtil.tcl
		  capLibUtil capDB/capLibUtil.tcl
		  capRev capDB/capRev.tcl
		  capShortNetUtil capDB/capShortNet.tcl
		  capDboGeom capDB/capDboGeom.tcl
		  capAnnotateHBlockPageNumber capDB/capAnnotateHBlockPageNumber.tcl
		  capLibPropUtil capDB/capLibPropUtil.tcl
		  capExportDesignCache capDB/capExportDesignCache.tcl
		  capDifferenceViewer capDifferenceViewerFramework/tcl/capDifferenceViewer.tcl
		  capDynObjects capDParts/capDynObjects.tcl
		  capBundleEvaluators capDParts/capBundleEvaluators.tcl
		  capBundleCreator capDParts/capBundleCreator.tcl
		  capShortedDiscretePart capDRC/capShortedDiscretePart.tcl
		  capOverlapWires capDRC/capOverlapWires.tcl
		  capHangingWires capDRC/capHangingWires.tcl
		  capPortPinMismatch capDRC/capPortPinMismatch.tcl
		  capDevicePinMismatch capDRC/capDevicePinMismatch.tcl
		  capPartReferencePrefixMismatch capDRC/capPartReferencePrefixMismatch.tcl
		  capCustomDRC capDRCFramework/tcl/capCustomDRC.tcl
		  capProcessDRC capDRCFramework/tcl/capProcessDRC.tcl
		  capAppLaunch capForms/capAppLaunch.tcl
		  capApps capForms/capApps.tcl
		  capExtPrefs capForms/capExtPrefs.tcl
		  capAppUtils capForms/capAppUtils.tcl
		  capFindReplaceTextLaunch capForms/capFindReplaceTextLaunch.tcl
		  capCheckLibLaunch capForms/capCheckLibLaunch.tcl
		  capLibPropLaunch capForms/capLibPropLaunch.tcl
		  capExportDesignCacheLaunch capForms/capExportDesignCacheLaunch.tcl
		  capCustomizePageLaunch capForms/capCustomizePageLaunch.tcl
		  capDesCompare capForms/capDesCompare.tcl
		  capGUIUtils capGUIUtils/capRotate.tcl
		  capZOrder capGUIUtils/capZOrder.tcl
		  capHybridTest capHybridTest/capHybridTest.tcl
		  learningResources caplearningresources/tcl/capLearningResBase.tcl
		  capFPViewerUtils capUtils/capFPViewerUtils.tcl
		  capMenuUtil capUtils/capMenuUtil.tcl
		  capSessionUtil capUtils/capSessionUtil.tcl
		  capSyncPropPCBFootprint capUtils/capSyncPropPCBFootprint.tcl
		  capPdfLaunch capUtils/capPdfLaunch.tcl
		  capPdfUtil capUtils/capPdfUtil.tcl
		  capGeom capUtils/capGeom.tcl
		  capTextUtils capUtils/capTextUtils.tcl
		  capCommServerLaunch capUtils/capCommServerLaunch.tcl
		  capCommServer capUtils/capCommServer.tcl
		  capReplacePathInCacheUtil capUtils/capReplacePathInCache.tcl
		  capAnnotateHBlockPageNumberLaunch capUtils/capAnnotateHBlockPageNumberLaunch.tcl
		  capReplacePathInCacheUtilLaunch capUtils/capReplacePathInCacheUtilLaunch.tcl
		  capSearchExecute capUtils/capSearchExecute.tcl
		  capNetNamesCorrection capUtils/capCorrectNetnamesONL.tcl
		  capFindUtil capUtils/capFindUtil.tcl
	          capRecurseParts capUtils/capRecurseParts.tcl
		  capFindUserEdits capUtils/capFindUserEditedReferences.tcl
		  orPrmDebug orPrmUtils/orPrmDebug.tcl
		  orPrmJSON orPrmUtils/orPrmJSON.tcl
		  orPrmUtils orPrmUtils/orPrmUtils.tcl
		  orPrmDboUtils orPrmUtils/orPrmDboUtils.tcl
		  orPrmCGI orPrmUtils/orPrmCGI.tcl
		  orPrmDboInclude orPrmUtils/orPrmDboInclude.tcl
		  orPrmStreamer orPrmUtils/orPrmStreamer.tcl
		  orPrmGeom orPrmUtils/orPrmGeom.tcl
		  orPrmViewer orPrmViewer/tcl/orPrmViewer.tcl
	}

		#packagename      dllname            modulename
	set lDllList {
		orPrmWebComp orPrmWebCompIE orPrmWebComp
		OrCommonTcl orCommonTcl OrCommonTcl
		orParser orParserTcl orParser
		OrPrmUIIntegration OrPrmUIIntegration OrPrmUIIntegration
	}
	
	set lPackageIndex [lsearch $lPackageList $pPackageName]
	set lDllIndex [lsearch $lDllList $pPackageName]
	
	if { $lPackageIndex != -1 } {
		set lFileIndex [expr "$lPackageIndex+1"]
		set lFileName [lindex $lPackageList $lFileIndex]
		set lFilePath [file join $gCapFastLoadRootDir $lFileName]
		if { [catch {source $lFilePath}] } {
		} else {
			#puts "Loading $lFilePath"
			lappend ::gCapFastLoadedPackages $pPackageName
			return 1
		}
	} elseif { $lDllIndex != -1 } {
		set lFileIndex [expr "$lDllIndex+1"]
		set lModuleNameIndex [expr "$lDllIndex+2"]
		
		set lDllName [lindex $lDllList $lFileIndex]
		set lFileName $lDllName$gCapFastLoadDllSuffix
		
		set lModuleName [lindex $lDllList $lModuleNameIndex]
		
		if { [catch {load $lFileName $lModuleName}] } {
		} else {
			#puts "Loading $lFileName $lModuleName"
			lappend ::gCapFastLoadedPackages $pPackageName
			return 1
		}
	} 
	
	return 0
}

proc ::capOverrideCommandPackage { args } {
	
	set lRet 0
	
	set lType [lindex $args 0]
	
	if { $lType == "require" } {
		set lPackageNameIndex 1
		
		if {[lindex $args 1] == "-exact"} {
			set lPackageNameIndex 2
		}
		#puts "Calling override package command : $args"
		set lRet [::capFastPackageRequire [lindex $args $lPackageNameIndex]]
		
		if { $lRet == 0 } {
			#puts "Default loading $args"
		}
	}
	
	if { $lRet == 0 } {
		#puts "Calling default package command : $args"
		eval [concat ::capOrigCommandPackage $args]
	}
}

proc ::capRenamePackageCommand { } {
	set l [array get ::env ORCAD_CAPTCL_DISABLE_FAST_PACKAGE_LOAD]
		
	if { 0 != [llength $l] } {
		if { 1 == [string match -nocase "true" [lindex $l 1]] 
		 ||  1 == [string match -nocase "1" [lindex $l 1]]} {
		    return
		}
	 }
	
	rename ::package ::capOrigCommandPackage
	rename ::capOverrideCommandPackage ::package
}

::capRenamePackageCommand

# perform Tcl/Tk initialization
# commented the following initialization as we always have Tk now in our installation
#capTclTkInitializeInternal

# end of file



