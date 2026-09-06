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

## Current Setup (`LOQ-Andres`)
Your configuration supports two groups:

*   **Group 1: Music & Ableton Projects**
    *   **Destination:** `E:\BackUp\Musicas\backup Ableton`
    *   **Retention:** 10 days
    *   **Includes:** Ableton projects, samples, and My songs.
*   **Group 2: RetroBat (Games)**
    *   **Destination:** `E:\BackUp\Games\Retrobat`
    *   **Retention:** 10 days
    *   **Includes:** RetroBat saves and ROMs.

*Scheduling is configured to run weekly (`SET DAYS=7`).*

## Setup Instructions

### 1. Configuration
Create or edit `backup-settings-for-%computername%.bat` in the project root. Use this structure:

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

