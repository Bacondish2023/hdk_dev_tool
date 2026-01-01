#!/bin/bash
#
# @brief    Runs tests
# @details  This script is developed in the hdk_dev_tool project.
#

BUILD_DIR=zzz_build
TIMEOUT_SECONDS=300

RESULT_OF_COMMAND=0
SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}

echo ${SCRIPT_NAME}: Starts

if [ -d "${BUILD_DIR}" ]; then
  pushd ${BUILD_DIR}
  ctest --verbose --timeout ${TIMEOUT_SECONDS}
  RESULT_OF_COMMAND=$?
  popd

  if [ ${RESULT_OF_COMMAND} != 0 ]; then
    echo ${SCRIPT_NAME}: Test failed. Return code is: ${RESULT_OF_COMMAND}
    exit 1
  fi
else
  echo ${SCRIPT_NAME}: Test failed. ${BUILD_DIR} directory does not exist.
  exit 1
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
