@echo off
if not "%OS%" == "Windows_NT" goto notNT
echo wint
goto done
:notNT
echo win95
:done
