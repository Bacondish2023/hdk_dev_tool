#!/bin/bash
#
# @brief    Creates build directory, generates build system, and builds
# @details  This script is developed in the hdk_dev_tool project.
#

unset PIP_REQUIREMENTS_FILE
# PIP_REQUIREMENTS_FILE=requirements.txt

SCRIPT_FILE=`basename $0`
SCRIPT_NAME=${SCRIPT_FILE%.*}
RESULT_OF_COMMAND=0

echo ${SCRIPT_NAME}: Starts

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

# Nothing to do aboud build

echo ${SCRIPT_NAME}: Exits successfully
exit 0
