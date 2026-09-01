# @brief Toolchain configuration for AVR8 development.
#
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.2.1
#

add_compile_definitions(
    SIMULATION
)

##
# @brief Configures an existing executable target for embedded development
# @details Keep interface same with toolchain_avr8_real.cmake
#
function(configure_embedded_executable executable_target)
    # Nothing to do
endfunction(configure_embedded_executable)
