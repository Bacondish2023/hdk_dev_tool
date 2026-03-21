#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
#
# This script removes deliverables and temporaries
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
