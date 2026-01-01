@echo off
rem
rem @brief    Removes deliverables and temporaries
rem @details  This script is developed in the hdk_dev_tool project.
rem

setlocal enabledelayedexpansion
set BUILD_DIR=zzz_build

set SCRIPT_NAME=%~n0

echo !SCRIPT_NAME!: Starts
if exist %BUILD_DIR% (
  rmdir /s /q %BUILD_DIR%
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
