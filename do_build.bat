@echo off
rem This script creates build directory, generates build system, and builds
rem Do NOT copy this script because this is not generic.
rem

setlocal enabledelayedexpansion
set PIP_REQUIREMENTS_FILE=requirements.txt

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

rem Checkout submodules
echo !SCRIPT_NAME!: Checkouts submodules
git submodule sync --recursive
git submodule update --init --recursive

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

rem Nothing to do aboud build

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
