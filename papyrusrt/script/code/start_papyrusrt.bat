@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem Version: 1.1.0
rem
rem This script creates workspace and launches Papyrus-RT
rem

setlocal enabledelayedexpansion
set WORKSPACE_DIR=zzz_workspace

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0
set DRY_RUN=0

echo !SCRIPT_NAME!: Starts

rem Handle arguments
if "%~1"=="--dry_run" (
    set DRY_RUN=1
)

if exist %WORKSPACE_DIR% (
  echo !SCRIPT_NAME!: Skips to create workspace. %WORKSPACE_DIR% directory already exists.
) else (
  echo !SCRIPT_NAME!: Creates workspace %WORKSPACE_DIR%
  mkdir %WORKSPACE_DIR%
)

if "!DRY_RUN!"=="1" (
  echo !SCRIPT_NAME!: Skips to launche Papyrus-RT
) else (
  echo !SCRIPT_NAME!: Launches Papyrus-RT
  start papyrusrt.exe -data %WORKSPACE_DIR%
)
