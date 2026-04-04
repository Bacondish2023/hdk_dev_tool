#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.1.0
#
# This script creates workspace and launches Papyrus-RT
#

WORKSPACE_DIR=zzz_workspace

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0
DRY_RUN=0

echo ${SCRIPT_NAME}: Starts

# Handle arguments
if [ "$1" = "--dry_run" ]; then
  DRY_RUN=1
fi

if [ -d "${WORKSPACE_DIR}" ]; then
  echo ${SCRIPT_NAME}: Skips to create workspace. ${WORKSPACE_DIR} directory already exists.
else
  echo ${SCRIPT_NAME}: Creates workspace ${WORKSPACE_DIR}
  mkdir ${WORKSPACE_DIR}
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo ${SCRIPT_NAME}: Skips to launche Papyrus-RT
else
  echo ${SCRIPT_NAME}: Launches Papyrus-RT
  papyrusrt -data ${WORKSPACE_DIR} &
fi
