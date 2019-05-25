if {![package vsatisfies [package provide Tcl] 8.4]} {return}
if {[string compare $::tcl_platform(platform) windows]} {return}

package ifneeded OrCommonTcl 1.0 [list load orCommonTcl.dll orCommonTcl]
package ifneeded orevalexpr 0.0 [list load orevalexpr.dll orevalexpr]
package ifneeded sdl 1.0 [list source [file join $dir pspGenConstraints.tcl]]
