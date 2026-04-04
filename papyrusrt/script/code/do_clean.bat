@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem Version: 1.1.0
rem
rem This script removes deliverables and temporaries
rem

setlocal enabledelayedexpansion
set BUILD_DIR=zzz_build
set CODEGEN_DIR=zzz_codegen

set SCRIPT_NAME=%~n0

echo !SCRIPT_NAME!: Starts
if exist %BUILD_DIR% (
  rmdir /s /q %BUILD_DIR%
)
if exist %CODEGEN_DIR% (
  rmdir /s /q %CODEGEN_DIR%
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
