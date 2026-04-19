cmake_minimum_required(VERSION 3.23)

if(PROJECT_IS_TOP_LEVEL)
    # Use CMAKE_MSVC_RUNTIME_LIBRARY variable
    # and MSVC_RUNTIME_LIBRARY target property to select the MSVC runtime library
    cmake_policy(SET CMP0091 NEW)
endif()

project(SubProject LANGUAGES C CXX)

if(PROJECT_IS_TOP_LEVEL)
    # CTest
    enable_testing()

    # GoogleTest
    find_package(GTest REQUIRED)

    # lint
    find_program(CPPCHECK cppcheck REQUIRED)
    add_custom_target(lint
        COMMAND ${CPPCHECK}
            --project=${CMAKE_BINARY_DIR}/compile_commands.json
            --std=c++11
            --enable=warning,performance,portability
            --suppress=missingIncludeSystem
            --inconclusive
            --error-exitcode=1
            -i umlrts # Exclude librts
            --suppress=*:*/umlrts/* # Exclude librts
            --suppress=duplInheritedMember # Suppress remarks on application model
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()

##################################################
# platform settings
##################################################
if(PROJECT_IS_TOP_LEVEL)
    if(UNIX)
        # nothing to do

    elseif(WIN32)
        add_definitions("/source-charset:utf-8")

        # Google Test requires the static MSVC runtime library
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
endif()

##################################################
# build librts
##################################################
if(PROJECT_IS_TOP_LEVEL)
    include(librts.cmake)
endif()

##################################################
# target for codegen
##################################################
if(PROJECT_IS_TOP_LEVEL)
    add_custom_target(model_compile
        COMMAND
            python
            -m model_compiler_for_papyrusrt
            --loglevel INFO
            "${CMAKE_SOURCE_DIR}"
            "${CMAKE_SOURCE_DIR}/zzz_codegen"
            "${CMAKE_SOURCE_DIR}/build_configuration/top_build_configuration.xml"
    )
endif()

##################################################
# build application
##################################################
if(PROJECT_IS_TOP_LEVEL)
    add_subdirectory(zzz_codegen)
endif()
