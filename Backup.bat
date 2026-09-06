@ECHO OFF
chcp 65001 >nul
:: BACKUP DIRECTORIES AND DELETE OLD BACKUPS
::
:: Run this script without arguments and it will backup selected directories to
:: a backup directory and delete old backup directories.

:: SCHEDULE BACKUP TASKS
:: Run this script with argument "sched" and it will schedule this script to run
:: every few hours. You will need to enter your Windows password.
:: For example:
::    cd /D %HOMEPATH%\myApps\Windows-Backup-Script
::    Backup.bat sched
::    Scheduling task.

:: =======================================
:: EDIT THIS SECTION.
:: =======================================
:: Where is 7zip installed to?
SET ZIP="C:\Program Files\7-Zip\7z.exe"
:: Where is forfiles installed to?
SET FORFILES="C:\Windows\System32\forfiles.exe"
:: Define where to find settings for backup up files on this machine.
:: By default looks for the settings file in the same folder as this script.
SET BACKUP_SETTINGS_FILE=%~dp0backup-settings-for-%computername%.bat

:: =======================================
:: DON'T CHANGE BELOW THIS POINT unless you know what you are doing!
:: =======================================

if not exist "%BACKUP_SETTINGS_FILE%" goto :SETTINGS_NOT_FOUND
goto :LOAD_SETTINGS

:: Load settings for this machine.
:LOAD_SETTINGS 
echo Loading setup configuration for this machine from:
echo    %BACKUP_SETTINGS_FILE%
call "%BACKUP_SETTINGS_FILE%"
goto :POST_SETTINGS_LOADED

:: Crap: couldn't load settings for this machine.
:SETTINGS_NOT_FOUND
echo DID NOT FIND A FILE CONFIGURING BACKUP SETTINGS FOR THIS MACHINE.
echo.
echo EXPECTED FILE: %BACKUP_SETTINGS_FILE%
echo.
echo.
echo SAMPLE CONTENTS BELOW:
echo.
echo    :: ===== GRUPO 1 =====
echo    SET BACKUP_HOME_1=%%HOMEPATH%%\bak\grupo1
echo    SET DAYS_B4_DELETE_1=10
echo    SET MAX_1=2
echo    SET DIR1="C:\path\to\dir-1"
echo    SET LBL1=LABEL-1
echo    SET DIR2="C:\path\to\dir-2"
echo    SET LBL2=LABEL-2
echo.
echo    :: ===== GRUPO 2 =====
echo    SET BACKUP_HOME_2=%%HOMEPATH%%\bak\grupo2
echo    SET DAYS_B4_DELETE_2=10
echo    SET MAX_2=2
echo    SET DIR_B1="C:\path\to\dir-b1"
echo    SET LBL_B1=LABEL-B1
echo    SET DIR_B2="C:\path\to\dir-b2"
echo    SET LBL_B2=LABEL-B2
echo.
echo    :: ===== AGENDAMENTO =====
echo    SET HOURS=4
echo    SET SCHED_TASK_LABEL=Backup my PC every 4 hours
echo.
echo Create a file with contents like those above and try again.

goto :END

:: Logic that should occur once machine based settings are loaded.
:POST_SETTINGS_LOADED

:: Are we scheduling or backing up?
IF "%1" == "sched" GOTO :SCHEDULE
GOTO :BACKUP

:: Schedule this script to run regularly - user will have to enter password.
:SCHEDULE
echo Scheduling task: %0.
echo Scheduling task: "wscript.exe %~dp0invisible.vbs %~dp0%~n0"
schtasks /create /SC DAILY /MO 7 /tn "%SCHED_TASK_LABEL%" /tr "wscript.exe \"%~dp0invisible.vbs\" \"%~dp0Backup.bat\""
GOTO :END

:: Run backup tasks.
:BACKUP
echo.
echo Backing up files.
echo.

:: Create timestamp.
SET hh=%time:~0,2%
if "%time:~0,1%"==" " SET hh=0%hh:~1,1%
if "%computername%" == "ITS32675" (
   SET YYYYMMDD_HHMMSS=%date:~6,4%%date:~3,2%%date:~0,2%_%hh%%time:~3,2%%time:~6,2%
) else (
   SET YYYYMMDD_HHMMSS=%date:~10,4%%date:~7,2%%date:~4,2%_%hh%%time:~3,2%%time:~6,2%
)

:: =======================================
:: GRUPO 1
:: =======================================
echo.
echo ========================================
echo GRUPO 1: %BACKUP_HOME_1%
echo ========================================
echo.

IF "%BACKUP_HOME_1%" == "" (
   echo Warning: BACKUP_HOME_1 nao foi definido. Pulando Grupo 1.
   GOTO :DELETE_GROUP1_SKIP
)
IF NOT EXIST "%BACKUP_HOME_1%" (
   echo Warning: BACKUP_HOME_1 [%BACKUP_HOME_1%] nao existe. Pulando Grupo 1.
   GOTO :DELETE_GROUP1_SKIP
)

SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_1%) Do (
  IF EXIST "!DIR%%i!" (
    echo.
    echo Backing up !DIR%%i!
    echo.
    cd /d "!DIR%%i!"
    %ZIP% a "%BACKUP_HOME_1%\!LBL%%i!_%YYYYMMDD_HHMMSS%" ^
       -ssw                  ^
       -x^^!".git"           ^
       -x^^!"noupload"       ^
       -x^^!"out"            ^
       -x^^!"target"         ^
       -xr^^!".history"      ^
       -xr^^!".databaseDumps" ^
       -x^^!"build"          ^
       -x^^!"bin"            ^
       -x^^!"node_modules"   ^
       -xr^^!"*.bak"         ^
       -xr^^!"*.log"         ^
       -xr^^!"*.gz"          ^
       -xr^^!"*.7z"          ^
       -xr^^!"*.zip"
  ) ELSE (
    echo.
    echo Diretorio nao encontrado, pulando: !DIR%%i!
    echo.
  )
)
EndLocal

:: Delete old backups - Group 1
echo.
echo Deletando backups antigos do Grupo 1...
echo.
IF "%DAYS_B4_DELETE_1%" == "" (
   echo WARNING! DAYS_B4_DELETE_1 nao definido. Nao deletando backups antigos do Grupo 1.
   GOTO :DELETE_GROUP1_SKIP
)
SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_1%) Do (
   echo Verificando arquivos antigos com label: !LBL%%i!
   %FORFILES% /P "%BACKUP_HOME_1%" /M !LBL%%i!_*.7z /D -%DAYS_B4_DELETE_1% ^
      /C "CMD /C del /F /Q @FILE & echo Deleted @FILE"
   echo.
)
EndLocal

:DELETE_GROUP1_SKIP

:: =======================================
:: GRUPO 2
:: =======================================
echo.
echo ========================================
echo GRUPO 2: %BACKUP_HOME_2%
echo ========================================
echo.

IF "%BACKUP_HOME_2%" == "" (
   echo Warning: BACKUP_HOME_2 nao foi definido. Pulando Grupo 2.
   GOTO :DELETE_GROUP2_SKIP
)
IF NOT EXIST "%BACKUP_HOME_2%" (
   echo Warning: BACKUP_HOME_2 [%BACKUP_HOME_2%] nao existe. Pulando Grupo 2.
   GOTO :DELETE_GROUP2_SKIP
)

SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_2%) Do (
  IF EXIST "!DIR_B%%i!" (
    echo.
    echo Backing up !DIR_B%%i!
    echo.
    cd /d "!DIR_B%%i!"
    %ZIP% a "%BACKUP_HOME_2%\!LBL_B%%i!_%YYYYMMDD_HHMMSS%" ^
       -ssw                  ^
       -x^^!".git"           ^
       -x^^!"noupload"       ^
       -x^^!"out"            ^
       -x^^!"target"         ^
       -xr^^!".history"      ^
       -xr^^!".databaseDumps" ^
       -x^^!"build"          ^
       -x^^!"bin"            ^
       -x^^!"node_modules"   ^
       -xr^^!"*.bak"         ^
       -xr^^!"*.log"         ^
       -xr^^!"*.gz"          ^
       -xr^^!"*.7z"          ^
       -xr^^!"*.zip"
  ) ELSE (
    echo.
    echo Diretorio nao encontrado, pulando: !DIR_B%%i!
    echo.
  )
)
EndLocal

:: Delete old backups - Group 2
echo.
echo Deletando backups antigos do Grupo 2...
echo.
IF "%DAYS_B4_DELETE_2%" == "" (
   echo WARNING! DAYS_B4_DELETE_2 nao definido. Nao deletando backups antigos do Grupo 2.
   GOTO :DELETE_GROUP2_SKIP
)
SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_2%) Do (
   echo Verificando arquivos antigos com label: !LBL_B%%i!
   %FORFILES% /P "%BACKUP_HOME_2%" /M !LBL_B%%i!_*.7z /D -%DAYS_B4_DELETE_2% ^
      /C "CMD /C del /F /Q @FILE & echo Deleted @FILE"
   echo.
)
EndLocal

:DELETE_GROUP2_SKIP

:END
:: Uncomment the "pause" line if you want the command window to stick around
:: until you "Press any key to continue . . ."
pause
