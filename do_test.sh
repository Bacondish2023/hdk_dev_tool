#!/bin/bash
# This script runs tests
# Do NOT copy this script because this is not generic.
#

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0

echo ${SCRIPT_NAME}: Starts

echo ${SCRIPT_NAME}: C++
unittest-parallel --verbose --start-directory cpp/script/test --pattern "*.py"
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Papyrus-RT
unittest-parallel --verbose --start-directory papyrusrt/script/test --pattern "*.py"
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Python
unittest-parallel --verbose --start-directory python/script/test --pattern "test_[0-9]*.py"
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: AVR8
unittest-parallel --verbose --start-directory embedded/avr8/script/test --pattern "*.py"
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Tool
unittest-parallel --verbose --start-directory tool/test --pattern "test_*.py"
RESULT_OF_COMMAND=$?
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
