#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.1.1
#
# This script creates build directory, generates build system, and builds
#

PRESET_LIST=(
  real
  simulation
)

unset PIP_REQUIREMENTS_FILE
# PIP_REQUIREMENTS_FILE=requirements.txt
BUILD_DIR=zzz_build

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0

echo ${SCRIPT_NAME}: Starts

# Check arguments
if [ -n "$1" ]; then
    echo "${SCRIPT_NAME}: Specified preset: \"$1\""
    PRESET_LIST=($1)
fi

# Checkout submodules
echo ${SCRIPT_NAME}: Checkouts submodules
git submodule sync --recursive
git submodule update --init --recursive
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Failed to update submodules. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

# Install Python packages
if [ -n "${PIP_REQUIREMENTS_FILE}" ]; then
  echo ${SCRIPT_NAME}: Installs Python packages

  python -m pip install --requirement ${PIP_REQUIREMENTS_FILE}
  RESULT_OF_COMMAND=$?
  if [ ${RESULT_OF_COMMAND} != 0 ]; then
    echo ${SCRIPT_NAME}: Failed to install python package. Return code is: ${RESULT_OF_COMMAND}
    exit 1
  fi
else
  echo ${SCRIPT_NAME}: Skips to install Python packages
fi

for preset in ${PRESET_LIST[@]}
do
  echo ${SCRIPT_NAME}: Processes \"${preset}\" preset

  # Run cmake to generate build system
  if [ -f "${BUILD_DIR}/${preset}/CMakeCache.txt" ]; then
    echo ${SCRIPT_NAME}: Skips to generate build system. ${BUILD_DIR}/${preset}/CMakeCache.txt already exists.
  else
    echo ${SCRIPT_NAME}: Generates build system
    cmake --preset=${preset}
    RESULT_OF_COMMAND=$?
    if [ ${RESULT_OF_COMMAND} != 0 ]; then
      echo ${SCRIPT_NAME}: Failed to generate build system. Return code is: ${RESULT_OF_COMMAND}
      exit 1
    fi
  fi

  # Build
  echo ${SCRIPT_NAME}: Builds
  cmake --build --target all package --preset=${preset}
  RESULT_OF_COMMAND=$?
  if [ ${RESULT_OF_COMMAND} != 0 ]; then
    echo ${SCRIPT_NAME}: Failed to build. Return code is: ${RESULT_OF_COMMAND}
    exit 1
  fi
done

echo ${SCRIPT_NAME}: Exits successfully
exit 0
