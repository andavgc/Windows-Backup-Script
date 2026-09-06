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
   mkdir "%BACKUP_HOME_1%"
)

SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_1%) Do (
  IF EXIST "!DIR%%i!" (
    echo.
    echo Verificando mudanças em !DIR%%i!
    echo.
    
    :: Fast check: skip if no changes
    :: We use a temporary dir that doesn't exist to compare
    robocopy "!DIR%%i!" "!DIR%%i!_tmp_check_folder_does_not_exist" /E /L /NJH /NJS /NDL /NC /NS
    IF !ERRORLEVEL! LEQ 1 (
       echo Nenhuma mudança detectada, pulando.
    ) ELSE (
       echo Backing up !DIR%%i!
       %ZIP% u -uq0 "%BACKUP_HOME_1%\!LBL%%i!.7z" "!DIR%%i!\*"
    )
  ) ELSE (
    echo.
    echo Diretorio nao encontrado, pulando: !DIR%%i!
    echo.
  )
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
   mkdir "%BACKUP_HOME_2%"
)

SetLocal EnableDelayedExpansion
For /L %%i in (1,1,%MAX_2%) Do (
  IF EXIST "!DIR_B%%i!" (
    echo.
    echo Verificando mudanças em !DIR_B%%i!
    echo.
    
    :: Fast check: skip if no changes
    robocopy "!DIR_B%%i!" "!DIR_B%%i!_tmp_check_folder_does_not_exist" /E /L /NJH /NJS /NDL /NC /NS
    IF !ERRORLEVEL! LEQ 1 (
       echo Nenhuma mudança detectada, pulando.
    ) ELSE (
       echo Backing up !DIR_B%%i!
       %ZIP% u -uq0 "%BACKUP_HOME_2%\!LBL_B%%i!.7z" "!DIR_B%%i!\*"
    )
  ) ELSE (
    echo.
    echo Diretorio nao encontrado, pulando: !DIR_B%%i!
    echo.
  )
)
EndLocal

:DELETE_GROUP2_SKIP


:END
:: Uncomment the "pause" line if you want the command window to stick around
:: until you "Press any key to continue . . ."
pause
