@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem Version: 1.2.0
rem
rem This script creates build directory, generates build system, and builds
rem

setlocal enabledelayedexpansion
set PRESET_LIST=real ^
simulation

set PIP_REQUIREMENTS_FILE=
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

rem Checkout submodules
echo !SCRIPT_NAME!: Checkouts submodules
git submodule sync --recursive
git submodule update --init --recursive
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Failed to update submodules. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

rem Install Python packages
if defined PIP_REQUIREMENTS_FILE (
  echo !SCRIPT_NAME!: Installs Python packages

  python -m pip install --requirement %PIP_REQUIREMENTS_FILE%
  set RESULT_OF_COMMAND=!ERRORLEVEL!
  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Failed to install python package. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
) else (
  echo !SCRIPT_NAME!: Skips to install Python packages
)

for %%p in (%PRESET_LIST%) do (
  echo !SCRIPT_NAME!: Processes "%%p" preset

  rem Run cmake to generate build system
  if exist %BUILD_DIR%\%%p\CMakeCache.txt (
    echo !SCRIPT_NAME!: Skips to generate build system. %BUILD_DIR%\%%p\CMakeCache.txt already exists.
  ) else (
    echo !SCRIPT_NAME!: Generates build system
    cmake --preset=%%p
    set RESULT_OF_COMMAND=!ERRORLEVEL!
    if !RESULT_OF_COMMAND! NEQ 0 (
      echo !SCRIPT_NAME!: Failed to generate build system. Return code is: !RESULT_OF_COMMAND!
      exit /B 1
    )
  )

  rem Build
  echo !SCRIPT_NAME!: Builds
  cmake --build --target all package --preset=%%p
  set RESULT_OF_COMMAND=!ERRORLEVEL!
  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Failed to build. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
