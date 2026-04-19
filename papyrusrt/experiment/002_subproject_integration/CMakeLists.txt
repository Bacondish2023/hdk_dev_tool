cmake_minimum_required(VERSION 3.23)

# Use CMAKE_MSVC_RUNTIME_LIBRARY variable
# and MSVC_RUNTIME_LIBRARY target property to select the MSVC runtime library
cmake_policy(SET CMP0091 NEW)

project(Experiment LANGUAGES C CXX)

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

##################################################
# platform settings
##################################################
if(UNIX)
    # nothing to do

elseif(WIN32)
    add_definitions("/source-charset:utf-8")

    # Google Test requires the static MSVC runtime library
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

##################################################
# build librts
##################################################
include(librts.cmake)

##################################################
# build sub-projects
##################################################
add_subdirectory(model/SubProject)

##################################################
# target for codegen
##################################################
add_custom_target(model_compile
    COMMAND
        python
        -m model_compiler_for_papyrusrt
        --loglevel INFO
        "${CMAKE_SOURCE_DIR}/model/SubProject"
        "${CMAKE_SOURCE_DIR}/zzz_codegen"
        "${CMAKE_SOURCE_DIR}/model/SubProject/build_configuration/top_build_configuration.xml"
    COMMAND
        python
        -m model_compiler_for_papyrusrt
        --loglevel INFO
        "${CMAKE_SOURCE_DIR}"
        "${CMAKE_SOURCE_DIR}/zzz_codegen"
        "${CMAKE_SOURCE_DIR}/build_configuration/top_build_configuration.xml"
)

##################################################
# build application
##################################################
add_subdirectory(zzz_codegen)

##################################################
# build test
##################################################
add_subdirectory(test)
