@echo off
rem
rem @brief    Runs lint
rem @details  This script is developed in the hdk_dev_tool project.
rem

setlocal enabledelayedexpansion
set BUILD_DIR=zzz_build

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

if exist %BUILD_DIR% (
  pushd %BUILD_DIR%
  cmake --build . --target lint
  set RESULT_OF_COMMAND=!ERRORLEVEL!
  popd

  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Lint failed. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
) else (
  echo !SCRIPT_NAME!: Lint failed. %BUILD_DIR% directory does not exist.
  exit /B 1
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
