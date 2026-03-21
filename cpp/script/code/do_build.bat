@echo off
rem Copyright (c) 2026 Hidekazu TAKAHASHI
rem SPDX-License-Identifier: MIT
rem Source: https://github.com/Bacondish2023/hdk_dev_tool
rem
rem This script creates build directory, generates build system, and builds
rem

setlocal enabledelayedexpansion
set BUILD_TYPE=Debug
set BUILD_DIR=zzz_build
set CMAKE_TOOLCHAIN_FILE=
set PIP_REQUIREMENTS_FILE=

set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

echo !SCRIPT_NAME!: Starts

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

rem Run cmake to generate build system
if exist %BUILD_DIR% (
  echo !SCRIPT_NAME!: Skips to generate build system. %BUILD_DIR% directory already exists.
) else (
  mkdir %BUILD_DIR%
  pushd %BUILD_DIR%
  if defined CMAKE_TOOLCHAIN_FILE (
    echo !SCRIPT_NAME!: Generates build system using toolchain %CMAKE_TOOLCHAIN_FILE%

    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS="ON" -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% ..
    set RESULT_OF_COMMAND=!ERRORLEVEL!
  ) else (
    echo !SCRIPT_NAME!: Generates build system

    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS="ON" ..
    set RESULT_OF_COMMAND=!ERRORLEVEL!
  )
  popd

  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Failed to generate build system. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
)

rem Build
echo !SCRIPT_NAME!: Builds
pushd %BUILD_DIR%
cmake --build .
set RESULT_OF_COMMAND=!ERRORLEVEL!
popd
if !RESULT_OF_COMMAND! NEQ 0 (
  echo !SCRIPT_NAME!: Failed to build. Return code is: !RESULT_OF_COMMAND!
  exit /B 1
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
