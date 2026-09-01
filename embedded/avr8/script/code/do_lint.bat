@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem Version: 1.2.1
rem
rem This script runs lint
rem

setlocal enabledelayedexpansion
set PRESET_LIST=real ^
simulation

set BUILD_DIR=zzz_build

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

rem Check arguments
if "%~1"=="" (
  rem Nothing to do
) else (
  echo !SCRIPT_NAME!: Specified preset: "%~1"
  set PRESET_LIST=%~1
)

for %%p in (%PRESET_LIST%) do (
  echo !SCRIPT_NAME!: Processes "%%p" preset

  if exist %BUILD_DIR% (
    cmake --build --target lint --preset=%%p
    set RESULT_OF_COMMAND=!ERRORLEVEL!

    if !RESULT_OF_COMMAND! NEQ 0 (
      echo !SCRIPT_NAME!: Lint failed. Return code is: !RESULT_OF_COMMAND!
      exit /B 1
    )
  ) else (
    echo !SCRIPT_NAME!: Lint failed. %BUILD_DIR% directory does not exist.
    exit /B 1
  )
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
