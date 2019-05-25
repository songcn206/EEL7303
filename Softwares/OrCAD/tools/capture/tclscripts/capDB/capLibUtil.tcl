#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capLibUtil.tcl
#            contains OrCAD Capture Library data sanity checking and correction 
#            procedures
#
# You can run the script either in the Capture TCL command window or in standalone TCL shell.
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g. source d:/workdata/capture/dbcheck/Published/capLibUtil.tcl
#2. capLibUtil::correctPkgs <olb path> <log file path>
#    e.g. capLibUtil::correctPkgs D:/temp/capture/library/my.olb d:/temp/capture/log/PkgCorrectionReport.txt
#
#Steps for running the script in Standalone TCL shell
#1. load <orDb_Dll_Tcl.dll path> DboTclWriteBasic
#    e.g. load C:/Cadence/SPB_16.3/tools/Capture/orDb_Dll_Tcl DboTclWriteBasic
#    (In this case, please make sure that C:/Cadence/SPB_16.3/tools/bin is present in the Path environment variable, because the dependent dll orDb_Dll is picked up from that location)
#2. source <script path>
#    e.g. source d:/workdata/capture/dbcheck/Published/capLibUtil.tcl
#3. capLibUtil::correctPkgs <olb path> <log file path>
#    e.g. capLibUtil::correctPkgs D:/temp/capture/library/my.olb d:/temp/capture/log/PkgCorrectionReport.txt

#Note:- For running this TCL script on all the libraries, you may have a wrapper tcl script which calls the capLibUtil::correctPkgs TCL command one-by-one on all libraries

#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capLibUtil 1.0

namespace eval ::capLibUtil {
	namespace export checkPkgs
	namespace export correctPkgs
}

proc ::capLibUtil::checkPkgs { pLibName pReportFilePath } {
	do $pLibName Report $pReportFilePath
	return
}

proc ::capLibUtil::correctPkgs { pLibName pReportFilePath } {
	do $pLibName Correct $pReportFilePath
	return
}

#pMode = Report/Correct
proc ::capLibUtil::do {pLibName pMode pReportFilePath} {
	
	if { $pReportFilePath == "" } {
		puts $lFile "Please specify the report file name"
	}

	set lFile [open $pReportFilePath a]

	puts -nonewline  [concat "Library :" $pLibName]
	puts $lFile [concat "Library :" $pLibName]
	flush $lFile
	
	#puts $lFile ReadLibraryEntry
	set lSession [DboTclHelper_sCreateSession]
	set lLibName [DboTclHelper_sMakeCString $pLibName]
	set lStatus [DboState] 
	set lLib [$lSession GetLib $lLibName $lStatus]
	
	set lNullObj NULL
	
	if { $lLib == $lNullObj} {
		puts $lFile " : Open Failed"
		puts " : Open Failed"
		return
	}
	
	set lAllPkgNames [list]
	set lValidPkgNames [list]
	set lAliasPkgNames [list]
	
	puts $lFile "Reading package names"
	flush $lFile
	
	set pkgNameIter [$lLib NewPackageNamesIter $lStatus]
	set pPkgName [DboTclHelper_sMakeCString]
	set lStatus [$pkgNameIter NextName $pPkgName]
	set lStatusVal [$lStatus Failed]
        while {$lStatusVal != 1} {
		lappend lAllPkgNames [DboTclHelper_sGetConstCharPtr $pPkgName]
		
		# read all aliases also
		set pkgAliasNameIter [$lLib NewPackageAliasesIter $pPkgName $lStatus]
		set pPkgAliasName [DboTclHelper_sMakeCString]
		set lStatus [$pkgAliasNameIter NextAlias $pPkgAliasName]
		set lStatusVal [$lStatus Failed]
		while {$lStatusVal != 1} {
			lappend lAliasPkgNames [DboTclHelper_sGetConstCharPtr $pPkgAliasName]
			set lStatus [$pkgAliasNameIter NextAlias $pPkgAliasName]
			set lStatusVal [$lStatus Failed]
		}
		delete_DboLibPackageAliasesIter $pkgAliasNameIter


		set lStatus [$pkgNameIter NextName $pPkgName]
		set lStatusVal [$lStatus Failed]
	}
	delete_DboLibPackageNamesIter $pkgNameIter
	
	puts $lFile "Completed reading package names"
	flush $lFile
	puts $lFile ""
	flush $lFile
	puts $lFile ""
	flush $lFile
	
	puts $lFile "Reading packages"
	flush $lFile
	set pkgIter [$lLib NewPackagesIter $lStatus]
	set pPkg [$pkgIter NextPackage $lStatus]
	set lNullObj NULL
	while {$pPkg!=$lNullObj} {
		set pActualPkgName [DboTclHelper_sMakeCString]
		$pPkg GetName $pActualPkgName
		lappend lValidPkgNames  [DboTclHelper_sGetConstCharPtr $pActualPkgName]
		set pPkg [$pkgIter NextPackage $lStatus]
	}
	delete_DboLibPackagesIter $pkgIter
	puts $lFile "Completed reading packages"
	flush $lFile
	puts $lFile ""
	flush $lFile
	puts $lFile ""
	flush $lFile
	
	lsort $lAllPkgNames 
	lsort $lValidPkgNames 
	lsort $lAliasPkgNames 
	
	set lNumberTotalPkgNames [llength $lAllPkgNames] 
	set lNumberValidPkgNames [llength $lValidPkgNames] 
	set lNumberAliasPkgNames [llength $lAliasPkgNames] 
	puts -nonewline $lFile "Number of total package names : " 
	puts $lFile $lNumberTotalPkgNames
	puts -nonewline $lFile "Number of valid package names : " 
	puts $lFile $lNumberValidPkgNames
	puts -nonewline $lFile "Number of alias package names : " 
	puts $lFile $lNumberAliasPkgNames
	flush $lFile
	
	set lNonRecoverablePackageErrors 0
	
	puts $lFile ""
	puts $lFile ""
	puts $lFile "Following packages are corrupt (non-recoverable) : "
	puts $lFile "------------------Start-------------------- "
	flush $lFile
	foreach lPkgName $lAllPkgNames {
	        #  if this is an alias pkg name, just skip
		set lSearchIndex [lsearch -exact $lAliasPkgNames $lPkgName]
		if {$lSearchIndex == -1} {
		
			# search this pkg name in lValidPkgNames
			set lSearchIndex [lsearch -exact $lValidPkgNames $lPkgName]
			if {$lSearchIndex == -1} {
				
				if {$pMode == "Report"} {
					puts $lFile $lPkgName
					incr lNonRecoverablePackageErrors
				}
				
				if {$pMode == "Correct"} {
					set lName [DboTclHelper_sMakeCString $lPkgName]
					set lStatus [$lLib ExplicitlyRemovePartDirName $lName]
					set lStatusVal [$lStatus Failed]
					if { $lStatusVal == 1} {
						# see if this is an invalid alias, if yes, remove it from there
						set lStatus [$lLib ExplicitlyRemoveAliasName $lName]
						set lStatusVal [$lStatus Failed]
						if { $lStatusVal == 1} {
							puts $lFile [concat "Failed to remove non-recoverable package name : " $lPkgName]
						} else {
							puts $lFile [concat "Removed non-recoverable alias package name : " $lPkgName]
						}
					} else  {
						puts $lFile [concat "Removed non-recoverable package name : " $lPkgName]
					}
					
					$lLib MarkModified
				}
				
			}

		}
	}
	puts $lFile "------------------End-------------------- "
	puts $lFile ""
	puts $lFile ""
	flush $lFile
	
	if { $lNonRecoverablePackageErrors > 0 }  {
		puts $lFile [concat "Number of Non-recoverable package errors : "  $lNonRecoverablePackageErrors]
	}
	
	flush $lFile
	
	if { $lNonRecoverablePackageErrors == 0 }  {
		puts $lFile "Library has no package errors"
		puts $lFile " : PASSED"
	} else {
		puts $lFile " : FAILED"
	}
	
	puts $lFile "-------------------------------------- "
	puts $lFile "-------------------------------------- "
	flush $lFile
	
	if {$pMode == "Correct"} {
		#$lSession MarkAllLibForSave $lLib
		$lSession SaveLib $lLib
	}
	
	$lSession RemoveLib $lLib
	
	flush $lFile
	close $lFile
	
	DboTclHelper_sDeleteSession $lSession
	return
}

#source d:/workdata/capture/dbcheck/Published/capLibUtil.tcl
# capLibUtil::checkPkgs D:/temp/capture/TT_USER_LIB/TT_USER_LIB.olb PkgCheckReport.txt
# capLibUtil::correctPkgs D:/temp/capture/TT_USER_LIB/TT_USER_LIB.olb PkgCorrectionReport.txt

