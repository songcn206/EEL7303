package ifneeded valtype::common                 1 [list source [file join $dir valtype.tcl]]
package ifneeded valtype::creditcard::amex       1 [list source [file join $dir cc_amex.tcl]]
package ifneeded valtype::creditcard::discover   1 [list source [file join $dir cc_discover.tcl]]
package ifneeded valtype::creditcard::mastercard 1 [list source [file join $dir cc_mastercard.tcl]]
package ifneeded valtype::creditcard::visa       1 [list source [file join $dir cc_visa.tcl]]
package ifneeded valtype::gs1::ean13             1 [list source [file join $dir ean13.tcl]]
package ifneeded valtype::imei                   1 [list source [file join $dir imei.tcl]]
package ifneeded valtype::isbn                   1 [list source [file join $dir isbn.tcl]]
package ifneeded valtype::luhn                   1 [list source [file join $dir luhn.tcl]]
package ifneeded valtype::luhn5                  1 [list source [file join $dir luhn5.tcl]]
package ifneeded valtype::usnpi                  1 [list source [file join $dir usnpi.tcl]]
package ifneeded valtype::verhoeff               1 [list source [file join $dir verhoeff.tcl]]
package ifneeded valtype::iban                   1 [list source [file join $dir iban.tcl]]
