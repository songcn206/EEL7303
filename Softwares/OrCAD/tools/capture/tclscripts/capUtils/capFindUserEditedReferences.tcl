package require Tcl 8.4
package require capRecurseParts

package provide capFindUserEdits 1.0

variable lStatus [DboState]

namespace eval ::capFindUserEdits {
    
    namespace export FindAllUserEdits
    namespace export FindOccUserEdits
    namespace export FindInstUserEdits

    variable cstr DboTclHelper_sMakeCString
    variable str DboTclHelper_sGetConstCharPtr
    variable refdeslist

    proc DumpUserEdit {pObj} {
	variable cstr
	variable str
	variable refdeslist

	if {$pObj == "NULL"} {
	    return; 
	}
	
	set refdes [$cstr];
	$pObj GetEffectivePropStringValue [$cstr "Part Reference"] $refdes;
	set ret [$pObj GetUserEditAttributeOnProp [$cstr "Reference"]]
	set refdes [$str $refdes]
	if {$ret!=0} {
	    lappend refdeslist "$refdes"
	}
    }

    proc FindOccUserEdits {} {
	variable refdeslist
	set refdeslist {}
	capRecurseParts::processAllInstOccsInDesign [GetActivePMDesign] "capFindUserEdits::DumpUserEdit"
	set refdeslist [lsort $refdeslist]
	puts "User Edited Occurrences: $refdeslist"
    }

    proc FindInstUserEdits {} {
	variable refdeslist
	set refdeslist {}
	capRecurseParts::processAllPartInstsInDesign [GetActivePMDesign] "capFindUserEdits::DumpUserEdit"
	set refdeslist [lsort $refdeslist]
	puts "User Edited Instances: $refdeslist"
    }

    proc FindAllUserEdits {} {
	FindOccUserEdits
	FindInstUserEdits
    }

    
}
