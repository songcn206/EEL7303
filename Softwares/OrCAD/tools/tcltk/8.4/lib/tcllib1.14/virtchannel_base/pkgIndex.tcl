if {![package vsatisfies [package provide Tcl] 8.5]} {return}

package ifneeded tcl::chan::cat 1.0.1      [list source [file join $dir cat.tcl]]
package ifneeded tcl::chan::facade 1.0.1   [list source [file join $dir facade.tcl]]
package ifneeded tcl::chan::fifo 1         [list source [file join $dir fifo.tcl]]
package ifneeded tcl::chan::fifo2 1        [list source [file join $dir fifo2.tcl]]
package ifneeded tcl::chan::halfpipe 1     [list source [file join $dir halfpipe.tcl]]
package ifneeded tcl::chan::memchan 1.0.2  [list source [file join $dir memchan.tcl]]
package ifneeded tcl::chan::null 1         [list source [file join $dir null.tcl]]
package ifneeded tcl::chan::nullzero 1     [list source [file join $dir nullzero.tcl]]
package ifneeded tcl::chan::random 1       [list source [file join $dir random.tcl]]
package ifneeded tcl::chan::std 1.0.1      [list source [file join $dir std.tcl]]
package ifneeded tcl::chan::string 1.0.1   [list source [file join $dir string.tcl]]
package ifneeded tcl::chan::textwindow 1   [list source [file join $dir textwindow.tcl]]
package ifneeded tcl::chan::variable 1.0.2 [list source [file join $dir variable.tcl]]
package ifneeded tcl::chan::zero 1         [list source [file join $dir zero.tcl]]
package ifneeded tcl::randomseed 1         [list source [file join $dir randseed.tcl]]
