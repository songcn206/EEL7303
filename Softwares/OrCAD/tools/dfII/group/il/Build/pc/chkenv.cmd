@echo off
rem
rem This file is to check env after NT SKILL kits is unzipped.
rem So far, it ensures the existence of tools\bin\cds_root.  Create it
rem if it is absent. Assumes now is under <inst-dir>, i.e. above "tools".
rem
echo on

setlocal
set CDS_BIN=.\tools\bin
set CDSROOT=.\tools\bin\cds_root
if not exist %CDS_BIN% mkdir %CDS_BIN%
if not exist %CDSROOT% echo Dummy root file > %CDSROOT%
endlocal
