@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem Version: 1.1.0
rem
rem This script runs tests
rem

setlocal enabledelayedexpansion
set BUILD_DIR=zzz_build
set TIMEOUT_SECONDS=300

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

if exist %BUILD_DIR% (
  pushd %BUILD_DIR%
  ctest --verbose --timeout %TIMEOUT_SECONDS%
  set RESULT_OF_COMMAND=!ERRORLEVEL!
  popd

  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
) else (
  echo !SCRIPT_NAME!: Test failed. %BUILD_DIR% directory does not exist.
  exit /B 1
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
