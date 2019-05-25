if {![package vsatisfies [package provide Tcl] 8.4]} {return}
if {[string compare $::tcl_platform(platform) windows]} {return}

package ifneeded pspAAGuiOpenResults 1.0 [list source [file join $dir pspAAGuiOpenResults.tcl]]

