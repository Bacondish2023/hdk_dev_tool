#!/bin/bash
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.1.0
#
# This script creates build directory, generates build system, and builds
#

BUILD_TYPE=Debug
BUILD_DIR=zzz_build
unset CMAKE_TOOLCHAIN_FILE
# CMAKE_TOOLCHAIN_FILE=toolchain.cmake
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

# Run cmake to generate build system
if [ -d "${BUILD_DIR}" ]; then
  echo ${SCRIPT_NAME}: Skips to generate build system. ${BUILD_DIR} directory already exists.
else
  mkdir ${BUILD_DIR}
  pushd ${BUILD_DIR}
  if [ -n "${CMAKE_TOOLCHAIN_FILE}" ]; then
    echo ${SCRIPT_NAME}: Generates build system using toolchain ${CMAKE_TOOLCHAIN_FILE}

    cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS="ON" -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} ..
    RESULT_OF_COMMAND=$?
  else
    echo ${SCRIPT_NAME}: Generates build system

    cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS="ON" ..
    RESULT_OF_COMMAND=$?
  fi
  popd

  if [ ${RESULT_OF_COMMAND} != 0 ]; then
    echo ${SCRIPT_NAME}: Failed to generate build system. Return code is: ${RESULT_OF_COMMAND}
    exit 1
  fi
fi

# Build
echo ${SCRIPT_NAME}: Builds
pushd ${BUILD_DIR}
cmake --build .
RESULT_OF_COMMAND=$?
popd
if [ ${RESULT_OF_COMMAND} != 0 ]; then
  echo ${SCRIPT_NAME}: Failed to build. Return code is: ${RESULT_OF_COMMAND}
  exit 1
fi

echo ${SCRIPT_NAME}: Exits successfully
exit 0
