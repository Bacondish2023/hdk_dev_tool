#!/bin/bash
#
# @brief    Removes deliverables and temporaries
# @details  This script is developed in the hdk_dev_tool project.
#

BUILD_DIR=zzz_build

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}

echo ${SCRIPT_NAME}: Starts
if [ -d "${BUILD_DIR}" ]; then
  rm -r -f ${BUILD_DIR}
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
