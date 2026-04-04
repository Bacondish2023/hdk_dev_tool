#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.1.0
#
# This script removes deliverables and temporaries
#

BUILD_DIR=zzz_build
CODEGEN_DIR=zzz_codegen

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}

echo ${SCRIPT_NAME}: Starts
if [ -d "${BUILD_DIR}" ]; then
  rm -r -f ${BUILD_DIR}
fi
if [ -d "${CODEGEN_DIR}" ]; then
  rm -r -f ${CODEGEN_DIR}
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
