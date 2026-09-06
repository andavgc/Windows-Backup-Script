# Windows-Backup-Script



A custom batch script system designed to perform automated, **cumulative incremental** backups on Windows using `7-Zip` and `robocopy`.

## Overview
This system organizes your backups into **Groups**. Each group has a destination and a set of directories to include. Instead of full snapshots, it maintains one single `.7z` file per label, updated incrementally.

## Key Features
1.  **Incremental Updates:** Only new or modified files are added to the `.7z` archive.
2.  **Cumulative:** If a file is deleted in the source directory, it remains in the archive.
3.  **Smart Skipping:** The script uses `robocopy` to detect if the source folder has changed; if not, the backup for that folder is skipped, saving time and resources.
4.  **No History Bloat:** Each group maintains exactly one stable `.7z` file (e.g., `MyLabel.7z`), overwritten/updated in place.

## Setup Instructions

### 1. Create your personal configuration file
The script looks for a settings file named `backup-settings-for-%computername%.bat`, where `%computername%` is your PC's name. Find it by running `echo %computername%` in a Command Prompt.

1. Copy the provided template to your machine's settings file:
   ```
   copy backup-settings-template.bat backup-settings-for-%computername%.bat
   ```
2. Open `backup-settings-for-%computername%.bat` and edit the values for **your** environment:
   * `BACKUP_HOME_1` / `BACKUP_HOME_2` — the **destination** folders where archives are saved.
   * `DIR1`, `DIR2`, ... / `DIR_B1`, `DIR_B2`, ... — the **source** folders you want to back up.
   * `LBL1`, `LBL2`, ... / `LBL_B1`, ... — short, space-free **labels** used for the archive filenames.
   * `MAX_1` / `MAX_2` — how many `DIR`/`LBL` pairs you defined for each group.
   * `DAYS` — how often (in days) to run, used when scheduling.
   * `SCHED_TASK_LABEL` — name for the Windows scheduled task.
   * Remove Group 2's variables entirely if you only need one group.

> **Privacy:** Your settings file is machine-specific and holds your personal paths and PC name. It matches `backup-settings-for-*` in `.gitignore`, so it is **never committed** to the repository. Only the generic `backup-settings-template.bat` is versioned. You must create your own copy locally — do not commit your personal file.

### 2. Running
*   **Manual:** Double-click `Backup.bat`.
*   **Schedule:** Run `Backup.bat sched` as Administrator (this registers the weekly Windows scheduled task).

### 3. Requirements
*   **7-Zip** installed at `C:\Program Files\7-Zip\7z.exe` (edit `ZIP` in `Backup.bat` if different).
*   Windows `robocopy` and `forfiles` (built in).



## Limitations
*   **Windows Only:** Designed for Windows batch environments.
*   **No Point-in-time History:** Overwriting archives means no access to older versions of files (unless you manually rotate/archive them separately).
*   **Dependency:** Requires `7-Zip` installed.


