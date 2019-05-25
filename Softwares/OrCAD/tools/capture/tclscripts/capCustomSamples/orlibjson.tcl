#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: orlibjson.tcl
#
#/////////////////////////////////////////////////////////////////////////////////

load orCommonTcl.dll OrLibJSON


package require Tcl 8.4


## Create a new container node, root should not have name 
set root [orjson_new "\5"]  

set root1 [orjson_new "\5"] 

## Set the name for container node 
orjson_set_name $root1 "Root1" 

orjson_push_back $root $root1 

set root2 [orjson_new "\5"] 

orjson_set_name $root2 "Root2"

orjson_push_back $root $root2

## Create string node 
set n [orjson_new_a "Root12" "i am string"] 

orjson_push_back $root1 $n 

## Create boolean node 
set n [orjson_new_b "Root11" true] 

orjson_push_back $root1 $n 

## Create integer node 
set n [orjson_new_i "Root21" 100] 

orjson_push_back $root2 $n

set text [orjson_write $root] 
##{"Root1":{"Root12":"i am string","Root11":true},"Root2":{"Root21":100}}

orjson_parse $text

