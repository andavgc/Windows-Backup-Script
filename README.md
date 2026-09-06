# Windows-Backup-Script

A custom batch script system designed to perform automated, group-based backups on Windows.

## Overview
This system allows you to organize your backups into distinct **Groups**. Each group has its own destination folder, retention policy, and list of directories to include.

## How it works
1.  **Configuration:** You define your backup structure in a `.bat` file named `backup-settings-for-%computername%.bat`.
2.  **Groups:** You can define multiple groups (e.g., "Music", "Games") within this file, each with:
    *   `BACKUP_HOME_X`: Destination path.
    *   `DAYS_B4_DELETE_X`: Days to keep backups before deletion.
    *   `DIRx`/`LBLx`: Directories and labels for the backup files.
3.  **Execution:** The `Backup.bat` script processes these groups, creating `.7z` archives with timestamps, while applying common ignore patterns (like `.git`, `node_modules`, etc.).
4.  **Scheduling:** The script can be scheduled via Windows Task Scheduler to run at specific intervals.

## Setup Instructions

### 1. Create your personal configuration file
The script looks for a settings file named `backup-settings-for-%computername%.bat`, where `%computername%` is your PC's name. Find it by running `echo %computername%` in a Command Prompt.

Create a copy of this file and name it after your machine. Edit the values for **your** environment:

```bat
:: ===== GRUPO 1 =====
SET BACKUP_HOME_1=C:\Path\To\Destination1
SET DAYS_B4_DELETE_1=10
SET MAX_1=1
SET DIR1="C:\Path\To\Source1"
SET LBL1=Label1

:: ===== GRUPO 2 =====
SET BACKUP_HOME_2=C:\Path\To\Destination2
SET DAYS_B4_DELETE_2=10
SET MAX_2=1
SET DIR_B1="C:\Path\To\Source2"
SET LBL_B1=Label2

:: ===== AGENDAMENTO =====
SET DAYS=7
SET SCHED_TASK_LABEL=Backup my PC every week
```

*   `BACKUP_HOME_X` — destination folders where archives are saved.
*   `DAYS_B4_DELETE_X` — how long (in days) to keep each archive.
*   `DIRx` / `LBLx` — source folders and their (space-free) archive labels.
*   `MAX_X` — how many `DIR`/`LBL` pairs you defined for each group.
*   `DAYS` — how often to run, used when scheduling.
*   `SCHED_TASK_LABEL` — name for the Windows scheduled task.

> **Privacy:** Your settings file is machine-specific and holds your personal paths and PC name. It matches `backup-settings-for-*` in `.gitignore`, so it is **never committed** to the repository. You must create your own copy locally — do not commit your personal file.

### 2. Running
*   **Manual:** Double-click `Backup.bat` to run all configured backups immediately.
*   **Schedule:** Open a Command Prompt as Administrator in the script folder and run:
    ```bat
    Backup.bat sched
    ```

## Limitations
*   **Windows Only:** Designed specifically for Windows batch environments.
*   **Manual Setup:** Configuration requires editing `.bat` files directly.
*   **Admin Privileges:** Scheduling and certain advanced file operations require administrative rights.
*   **No UI:** A purely command-line tool.
*   **Dependency:** Requires `7-Zip` installed on the system.

