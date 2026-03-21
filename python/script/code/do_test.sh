#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
#
# This script runs tests
#

DISCOVER_START_DIRECTORY="."
PATTERN_TEST_FILES="test_*.py"

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0

echo ${SCRIPT_NAME}: Starts

python -B -m unittest discover --verbose --start-directory ${DISCOVER_START_DIRECTORY} --pattern ${PATTERN_TEST_FILES}
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
