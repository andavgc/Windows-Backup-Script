:: ======================================================
::  WINDOWS BACKUP SCRIPT - CONFIGURATION TEMPLATE
:: ======================================================
::  IMPORTANT: This is a template. Copy it and rename it to:
::     backup-settings-for-%computername%.bat
::  (replace %computername% with your PC's name, e.g. backup-settings-for-MYPC.bat)
::
::  It is IGNORED by git (see .gitignore) so your personal
::  paths and PC name are never uploaded to the repository.
::
::  Edit the values below to match your own directories.
::  Only folders whose DIR/LBL variables you define are backed up.
:: ======================================================

:: ===== GRUPO 1 =====
:: Where do you want to put the backup files? (destination)
SET BACKUP_HOME_1=E:\Backup\MyFirstGroup

:: Define path and label (no spaces) for each directory you want to backup.
SET DIR1=C:\Users\YOURNAME\Documents\Project1
SET LBL1=Project1
SET DIR2=C:\Users\YOURNAME\Documents\Project2
SET LBL2=Project2

:: How many dir/lbl combinations did you define for Group 1?
SET MAX_1=2


:: ===== GRUPO 2 (optional - delete this block if not needed) =====
:: Where do you want to put the backup files? (destination)
SET BACKUP_HOME_2=E:\Backup\MySecondGroup

:: Define path and label (no spaces) for each directory you want to backup.
SET DIR_B1=D:\SomeFolder\saves
SET LBL_B1=saves
SET DIR_B2=D:\SomeFolder\roms
SET LBL_B2=roms

:: How many dir/lbl combinations did you define for Group 2?
SET MAX_2=2


:: ===== AGENDAMENTO (scheduling, shared) =====
:: How often (in days) do you want to run this script? (used by 'sched' argument)
SET DAYS=7

:: What name to give the scheduled task.
SET SCHED_TASK_LABEL=Backup my PC every week