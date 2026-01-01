#!/bin/bash
#
# @brief    Runs lint
# @details  This script is developed in the hdk_dev_tool project.
#

BUILD_DIR=zzz_build

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0

echo ${SCRIPT_NAME}: Starts

if [ -d "${BUILD_DIR}" ]; then
  pushd ${BUILD_DIR}
  cmake --build . --target lint
  RESULT_OF_COMMAND=$?
  popd

  if [ ${RESULT_OF_COMMAND} != 0 ]; then
    echo ${SCRIPT_NAME}: Lint failed. Return code is: ${RESULT_OF_COMMAND}
    exit 1
  fi
else
  echo ${SCRIPT_NAME}: Lint failed. ${BUILD_DIR} directory does not exist.
  exit 1
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
