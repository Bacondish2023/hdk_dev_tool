cmake_minimum_required(VERSION 3.23)

# Use CMAKE_MSVC_RUNTIME_LIBRARY variable
# and MSVC_RUNTIME_LIBRARY target property to select the MSVC runtime library
cmake_policy(SET CMP0091 NEW)

project(example LANGUAGES C CXX)

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
# build library
##################################################

# library
add_library( libarithmetic STATIC
    source/arithmetic.cpp
)

target_include_directories( libarithmetic
    PUBLIC
        include
)

# Remove prefix for avoiding "liblibarithmetic.a"
set_target_properties( libarithmetic
    PROPERTIES
        PREFIX ""
        IMPORT_PREFIX ""
)

# test
add_executable( test_arithmetic
    test/test_arithmetic.cpp
)

target_link_libraries( test_arithmetic
    PRIVATE
        libarithmetic
        GTest::gtest        # This target requires CMake version 3.20
        GTest::gtest_main   # This target requires CMake version 3.20
        GTest::gmock        # This target requires CMake version 3.23
        GTest::gmock_main   # This target requires CMake version 3.23
)

add_test(
    NAME test_arithmetic
    COMMAND test_arithmetic
)

##################################################
# build application
##################################################
add_executable( application
    source/main.cpp
)

target_link_libraries( application
    PRIVATE
        libarithmetic
)
