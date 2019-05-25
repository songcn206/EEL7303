#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPFindWhat FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capExportDesignCache.tcl
#            Create a library corresponding to all parts in the design cache in the specified folder 
#/////////////////////////////////////////////////////////////////////////////////





package require Tcl 8.4
package provide capExportDesignCache 1.0

namespace eval ::capExportDesignCache {
    namespace export export_design_cache
}

proc write_to_logfile {logf msg} {
    set NullObject NULL
    set fp [open $logf {a+}]
    if {$fp!=$NullObject} {
	puts $fp $msg
	close $fp
    } else {
	puts $msg
    }
}

proc ::capExportDesignCache::export_design_cache {foldername logf} {
    set NullObject NULL
    set lSession $::DboSession_s_pDboSession
    DboSession -this $lSession
    set lStatus [DboState]
    set str DboTclHelper_sMakeCString
    set dsn [$lSession GetActiveDesign ]
    if {$dsn==$NullObject} {
	write_to_logfile $logf "No Design active"
	return
    }
    file mkdir $foldername

    set dch [$dsn NewCachesIter $lStatus]

    set p1 [$dch NextCachedObject $lStatus]
    while {$p1!=$NullObject} {
	set objt [$p1 GetObjectType]

	# 31 is for PACKAGE
	if {$objt==31} {
	    set pkgname [$str ""]	    
	    $p1 GetName $pkgname
	    set libname ""
	    
	    append libname $foldername "/" [DboTclHelper_sGetConstCharPtr $pkgname] ".olb" 	    
	    set plib [$lSession CreateLib [$str $libname] $lStatus]
	    set failed [$lStatus Failed]
	    if {$failed==1|$plib==$NullObject} {
		write_to_logfile $logf [concat "can't create library: " $libname]
	    } else {	    
		set p1 [DboBaseObjectToDboLibObject $p1]
		set pkg1 [DboLibObjectToDboPackage $p1]
		$plib CopyPackageAll $pkg1 $pkgname $lStatus

		$lSession MarkAllLibForSave $plib
		$lSession SaveLib $plib
		$lSession RemoveLib $plib
		write_to_logfile $logf [concat "exported package " [DboTclHelper_sGetConstCharPtr $pkgname]]
	    }
	}
	set p1 [$dch NextCachedObject $lStatus]
    }

    DboTclHelper_sReleaseAllCreatedPtrs
}