# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded capDesignUtil 1.0 [list source [file join $dir capDesignUtil.tcl]]
package ifneeded capLibUtil 1.0 [list source [file join $dir capLibUtil.tcl]]
package ifneeded capRev 1.0 [list source [file join $dir capRev.tcl]]
package ifneeded capShortNetUtil 1.0 [list source [file join $dir capShortNet.tcl]]
package ifneeded capDboGeom 1.0 [list source [file join $dir capDboGeom.tcl]]
package ifneeded capAnnotateHBlockPageNumber 1.0 [list source [file join $dir capAnnotateHBlockPageNumber.tcl]]
package ifneeded capLibPropUtil 1.0 [list source [file join $dir capLibPropUtil.tcl]]
package ifneeded capExportDesignCache 1.0 [list source [file join $dir capExportDesignCache.tcl]]