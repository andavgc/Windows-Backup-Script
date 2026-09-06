# Windows-Backup-Script

A custom batch script system designed to perform automated, **cumulative incremental** backups on Windows using `7-Zip` and `robocopy`.

## Overview
This system organizes your backups into **Groups**. Each group has a destination and a set of directories to include. Instead of full snapshots, it maintains one single `.7z` file per label, updated incrementally.

## Key Features
1.  **Incremental Updates:** Only new or modified files are added to the `.7z` archive.
2.  **Cumulative:** If a file is deleted in the source directory, it remains in the archive.
3.  **Smart Skipping:** The script uses `robocopy` to detect if the source folder has changed; if not, the backup for that folder is skipped, saving time and resources.
4.  **No History Bloat:** Each group maintains exactly one stable `.7z` file (e.g., `Projetos_Ableton.7z`), overwritten/updated in place.

## Current Setup (`LOQ-Andres`)
Your configuration supports two groups:

*   **Group 1: Music & Ableton Projects**
    *   **Destination:** `E:\BackUp\Musicas\backup Ableton`
    *   **Includes:** Ableton projects, samples, and My songs.
*   **Group 2: RetroBat (Games)**
    *   **Destination:** `E:\BackUp\Games\Retrobat`
    *   **Includes:** RetroBat saves and ROMs.

*Scheduling is configured to run weekly (`SET DAYS=7`).*

## Setup Instructions

### 1. Configuration
Create or edit `backup-settings-for-%computername%.bat`.

```bat
:: ===== GRUPO 1 =====
SET BACKUP_HOME_1=C:\Path\To\Destination1
SET MAX_1=1
SET DIR1="C:\Path\To\Source1"
SET LBL1=Label1

:: ===== GRUPO 2 =====
SET BACKUP_HOME_2=C:\Path\To\Destination2
SET MAX_2=1
SET DIR_B1="C:\Path\To\Source2"
SET LBL_B1=Label2

:: ===== AGENDAMENTO =====
SET DAYS=7
SET SCHED_TASK_LABEL=Backup my PC every week
```

### 2. Running
*   **Manual:** Double-click `Backup.bat`.
*   **Schedule:** Run `Backup.bat sched` as Administrator.

## Limitations
*   **Windows Only:** Designed for Windows batch environments.
*   **No Point-in-time History:** Overwriting archives means no access to older versions of files (unless you manually rotate/archive them separately).
*   **Dependency:** Requires `7-Zip` installed.


