@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem
rem This script runs tests
rem

setlocal enabledelayedexpansion
set DISCOVER_START_DIRECTORY="."
set PATTERN_TEST_FILES="test_*.py"

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

python -B -m unittest discover --verbose --start-directory %DISCOVER_START_DIRECTORY% --pattern %PATTERN_TEST_FILES%
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
