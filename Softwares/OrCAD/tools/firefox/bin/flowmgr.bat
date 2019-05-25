@ECHO OFF

SET FM_URL=-chrome chrome://flowmgr/content
SET MPSSESSION=
set PROFILENAME=ADWPROFILE_1


:ARGLOOP
REM if user passes in chrome address, use it, else use projmgr
IF '%1' == '-chrome' (
    SET FM_URL=
	SHIFT
	SHIFT
	GOTO ARGLOOP
)
REM is user passes in mpssession, use it on cmd line
IF '%1' == '-mpssession' (
    SHIFT
	REM set MPSSESSION= -mpssession %1
	SHIFT
	GOTO ARGLOOP
)

IF '%1' == '' GOTO ARGDONE
SHIFT
GOTO ARGLOOP
:ARGDONE




REM path to flowmgr can be controlled by env var
set ADW_FM_DIR=%WB_ROOT%\..\fet\projmgr\bin
if defined ADW_FM_LOCAL_PATH set ADW_FM_DIR=%ADW_FM_LOCAL_PATH%\tools\fet\projmgr\bin



:startup

set MOZ_NO_REMOTE=1

REM set FLOWMGR_CMD=%ADW_FM_DIR%\firefox.exe -profile %ADW_FIREFOX_PROFILE% 
REM set FLOWMGR_CMD=%ADW_FM_DIR%\firefox.exe -console -venkman
set FLOWMGR_CMD=%ADW_FM_DIR%\firefox.exe -app  %ADW_FM_DIR%\..\flowmgr\application.ini
REM set FLOWMGR_CMD=%ADW_FM_DIR%\firefox.exe -P Designer %FM_URL%
REM set FLOWMGR_CMD=%FLOWMGR_CMD% %MPSSESSION% -P Librarian
REM set FLOWMGR_CMD=%ADW_FM_DIR%\firefox.exe -P %PROFILENAME%
REM set FLOWMGR_CMD=%FLOWMGR_CMD% %FM_URL%

echo Launching %FLOWMGR_CMD% %*
REM PAUSE
@start %FLOWMGR_CMD% %*
set MOZ_NO_REMOTE=0


:end
