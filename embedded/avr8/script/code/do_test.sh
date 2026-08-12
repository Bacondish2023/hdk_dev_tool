#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.1.1
#
# This script runs tests
#

PRESET_LIST=(
  real
  simulation
)

BUILD_DIR=zzz_build
TIMEOUT_SECONDS=300

RESULT_OF_COMMAND=0
SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}

echo ${SCRIPT_NAME}: Starts

# Check arguments
if [ -n "$1" ]; then
    echo "${SCRIPT_NAME}: Specified preset: \"$1\""
    PRESET_LIST=($1)
fi

for preset in ${PRESET_LIST[@]}
do
  echo ${SCRIPT_NAME}: Processes \"${preset}\" preset

  if [ -d "${BUILD_DIR}" ]; then
    ctest --verbose --timeout ${TIMEOUT_SECONDS} --preset=${preset}
    RESULT_OF_COMMAND=$?
    if [ ${RESULT_OF_COMMAND} != 0 ]; then
      echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
      exit 1
    fi
  else
    echo ${SCRIPT_NAME}: Test failed. ${BUILD_DIR} directory does not exist.
    exit 1
  fi
done

echo ${SCRIPT_NAME}: Exits successfully
exit 0
