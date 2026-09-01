# @brief Toolchain configuration for AVR8 development.
#
# Ensure that all programs used by find_program are available on PATH.
#
# This file requires the MCU variable.
# Define MCU before evaluating this toolchain file, for example by passing it as a CMake command-line option.
#
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
# Version: 1.2.1
#

find_program(AVR_CC avr-gcc REQUIRED)
find_program(AVR_CXX avr-g++ REQUIRED)
find_program(AVR_OBJCOPY avr-objcopy REQUIRED)
find_program(AVR_SIZE avr-size REQUIRED)
find_program(AVR_OBJDUMP avr-objdump REQUIRED)
find_program(AVR_PROGRAM avrdude REQUIRED)

# Basic configuration
set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_PROCESSOR "AVR8")
set(CMAKE_CROSSCOMPILING true)

# Build tool
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})

# Compiler option
set(CMAKE_CXX_FLAGS "-fno-threadsafe-statics -funsigned-char -funsigned-bitfields -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -Wall -mmcu=${MCU}")

# Linker option
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-lm -Wl,--gc-sections -mmcu=${MCU}")

# Extension
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")

# Specify program device
set(PROGRAM_TOOL "avrisp2")

##
# @brief Configures an existing executable target for embedded development
# @details Registers additional build steps required for embedded development.
#
# Creating the following target:
# - ${executable_target}_program:   Program the device
# - erase:                          Erase the device
#
# Required variable:
# - MCU: Target device such as "atmega328p"
#
# @param[in] executable_target Name of an existing executable target.
#
function(configure_embedded_executable executable_target)
    # Check required variable
    if (NOT DEFINED MCU)
        message(FATAL_ERROR "MCU is not defined")
    endif ()

    # Check specified executable_target is executable target
    if (TARGET executable_target)
        message(FATAL_ERROR "Specified argument executable_target is not target")
    endif ()

    get_target_property(TARGET_TYPE ${executable_target} TYPE)
    if (NOT ${TARGET_TYPE} STREQUAL "EXECUTABLE")
        message(FATAL_ERROR "Specified argument executable_target is not executable")
    endif ()

    # Generate eeprom image
    add_custom_command( TARGET ${executable_target} POST_BUILD
        COMMAND ${AVR_OBJCOPY} -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 -O ihex ${executable_target}.elf ${executable_target}.eep
    )

    # Generate lss file
    add_custom_command( TARGET ${executable_target} POST_BUILD
        COMMAND ${AVR_OBJDUMP} -h -S ${executable_target}.elf >${executable_target}.lss
    )

    # Generate size file
    add_custom_command( TARGET ${executable_target} POST_BUILD
        COMMAND ${AVR_SIZE} ${executable_target}.elf >${executable_target}.size
        COMMAND cmake -E cat ${executable_target}.size
    )

    # Target for program
    add_custom_target(${executable_target}_program
        COMMAND ${AVR_PROGRAM} -c ${PROGRAM_TOOL} -p ${MCU} -e -U flash:w:$<TARGET_FILE:${executable_target}>
        DEPENDS ${executable_target}
        COMMENT "Program ${executable_target}.elf into target device"
    )

    # Target for erase
    if (NOT TARGET erase)
        add_custom_target(erase
            COMMAND ${AVR_PROGRAM} -c ${PROGRAM_TOOL} -p ${MCU} -e
            COMMENT "Erase target device"
        )
    endif()

endfunction(configure_embedded_executable)
