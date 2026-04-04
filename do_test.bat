@echo off
rem This script runs tests
rem Do NOT copy this script because this is not generic.
rem

setlocal enabledelayedexpansion
set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

rem Test C++
python -B -m unittest discover --verbose --start-directory cpp/script/test --pattern "*.py"
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

rem Test Papyrus-RT
python -B -m unittest discover --verbose --start-directory papyrusrt/script/test --pattern "*.py"
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

rem Test Python
python -B -m unittest discover --verbose --start-directory python/script/test --pattern "test_[0-9]*.py"
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

rem Test Tool
python -B -m unittest discover --verbose --start-directory tool/test --pattern "test_*.py"
set RESULT_OF_COMMAND=!ERRORLEVEL!
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Test failed. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
