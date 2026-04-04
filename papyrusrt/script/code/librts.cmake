# @brief Build script for the Runtime Service (RTS) library
#
# Usage
# - Specify the RTS source directory using the UMLRTS_ROOT environment variable.
# - Copy this file into your project.
# - Include this file from your CMakeLists.txt (using include() in CMake).
# - Link "librts" to your executable (using target_link_libraries() in CMake).
#     - RTS include directories are automatically propagated through linking.
#       Therefore, you do not need to call target_include_directories().
#
# Copyright (c) 2026 Hidekazu TAKAHASHI
# SPDX-License-Identifier: MIT
# Source: https://github.com/Bacondish2023/hdk_dev_tool
#

get_filename_component(SCRIPT_NAME "${CMAKE_CURRENT_LIST_FILE}" NAME)

if (IS_DIRECTORY $ENV{UMLRTS_ROOT})
    message(STATUS "${SCRIPT_NAME}: UMLRTS_ROOT is \"$ENV{UMLRTS_ROOT}\"")

    set(UMLRTS_ROOT_NORMALIZED $ENV{UMLRTS_ROOT})
    string(REPLACE "\\" "/" UMLRTS_ROOT_NORMALIZED ${UMLRTS_ROOT_NORMALIZED})
    string(REPLACE "//" "/" UMLRTS_ROOT_NORMALIZED ${UMLRTS_ROOT_NORMALIZED})

    add_library(librts STATIC
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/src/umlrtgetopt.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtapi.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtbasicthread.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtcapsule.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtcapsuleid.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtcapsuletocontrollermap.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtcommsport.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtcontroller.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtframeprotocol.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtframeservice.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrthashmap.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtinsignal.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtinoutsignal.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtlogprotocol.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmain.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmainloop.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmaintargetshutdown.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmaintargetstartup.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmessage.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmessagepool.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtmessagequeue.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtobjectclass.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtoutsignal.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtpool.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtprioritymessagequeue.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtprotocol.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtqueue.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtrtsinterfaceumlrt.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtsignal.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtsignalelement.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrtsignalelementpool.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrttimerid.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrttimerpool.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrttimerprotocol.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrttimerqueue.cc
        ${UMLRTS_ROOT_NORMALIZED}/umlrt/umlrttimespec.cc
    )

    target_include_directories(
        librts
        PUBLIC
            ${UMLRTS_ROOT_NORMALIZED}/umlrt/src/include
            ${UMLRTS_ROOT_NORMALIZED}/include
            ${UMLRTS_ROOT_NORMALIZED}/util/include
    )

    # Remove prefix for avoiding "liblibrts.a"
    set_target_properties(
        librts
        PROPERTIES
            PREFIX ""
            IMPORT_PREFIX ""
    )

    ##################################################
    # Unix port
    ##################################################
    if (UNIX)
        message(STATUS "${SCRIPT_NAME}: Uses Unix port")

        target_sources(
            librts
            PRIVATE
                ${UMLRTS_ROOT_NORMALIZED}/util/basedebug.cc
                ${UMLRTS_ROOT_NORMALIZED}/util/basefatal.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/osbasicthread.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/osmutex.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/osnotify.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/ossemaphore.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/ostime.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/ostimespec.cc
        )

        target_include_directories(
            librts
            PUBLIC
                ${UMLRTS_ROOT_NORMALIZED}/os/linux/include
        )

        # Include checkers
        include(CheckIncludeFile)
        include(CheckSymbolExists)

        # Check for sys/socket.h
        check_include_file(sys/socket.h HAS_SYS_SOCKET_H)
        if (HAS_SYS_SOCKET_H)
            target_compile_definitions( librts
                PRIVATE
                    HAS_SYS_SOCKET_H
            )
        endif ()

        # Check for pthread_mutex_timedlock
        check_symbol_exists(pthread_mutex_timedlock "pthread.h" HAS_PTHREAD_MUTEX_TIMEDLOCK)
        if (NOT HAS_PTHREAD_MUTEX_TIMEDLOCK)
            target_compile_definitions( librts
                PRIVATE
                    NEED_PTHREAD_MUTEX_TIMEDLOCK
            )
        endif ()

        # Check for sem_timedwait
        check_symbol_exists(sem_timedwait "semaphore.h" HAS_SEM_TIMEDWAIT)
        if (NOT HAS_SEM_TIMEDWAIT)
            target_compile_definitions( librts
                PRIVATE
                    NEED_SEM_TIMEDWAIT
            )
        endif ()

        # Check for sem_init
        check_symbol_exists(sem_init "semaphore.h" HAS_SEM_INIT)
        if (NOT HAS_SEM_INIT)
            target_compile_definitions( librts
                PRIVATE
                    NEED_SEM_INIT
            )
        endif ()

        # Check for clock_gettime
        check_symbol_exists(clock_gettime "time.h" HAS_CLOCK_GETTIME)
        if (NOT HAS_CLOCK_GETTIME)
            target_compile_definitions( librts
                PRIVATE
                    NEED_CLOCK_GETTIME
            )
        endif ()

    ##################################################
    # Windows port
    ##################################################
    elseif (MSVC)
        message(STATUS "${SCRIPT_NAME}: Uses Windows port")

        target_compile_definitions(
            librts
            PRIVATE
                /source-charset:utf-8
                _CRT_SECURE_NO_WARNINGS
        )

        target_sources(
            librts
            PRIVATE
                ${UMLRTS_ROOT_NORMALIZED}/util/basedebug.cc
                ${UMLRTS_ROOT_NORMALIZED}/util/basefatal.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/osbasicthread.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/osmutex.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/osnotify.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/ossemaphore.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/ostime.cc
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/ostimespec.cc
        )

        target_include_directories(
            librts
            PUBLIC
                ${UMLRTS_ROOT_NORMALIZED}/os/windows/include
        )

    else ()
        message(FATAL_ERROR "${SCRIPT_NAME}: Unknown platform \"${CMAKE_SYSTEM_NAME}\"")
    endif ()
else ()
    message(FATAL_ERROR "${SCRIPT_NAME}: \"$ENV{UMLRTS_ROOT}\" is not directory. It is specified by environment variable UMLRTS_ROOT.")
endif ()
