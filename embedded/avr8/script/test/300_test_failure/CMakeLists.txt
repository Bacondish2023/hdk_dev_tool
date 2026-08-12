cmake_minimum_required(VERSION 3.25)

# Use CMAKE_MSVC_RUNTIME_LIBRARY variable
# and MSVC_RUNTIME_LIBRARY target property to select the MSVC runtime library
cmake_policy(SET CMP0091 NEW)

project(example
    LANGUAGES C CXX
    VERSION 0.0.0
)

# CTest
enable_testing()

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

add_compile_options(
    -DF_CPU=16000000UL
)

##################################################
# Platform settings
##################################################
if(${TARGET_TYPE} STREQUAL "Real")
    # Nothing to do
elseif(${TARGET_TYPE} STREQUAL "Simulation")
    # GoogleTest
    find_package(GTest REQUIRED)

    if(UNIX)
    # nothing to do

    elseif(WIN32)
        add_definitions("/source-charset:utf-8")

        # Google Test requires the static MSVC runtime library
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
else()
    message(WARNING "Unexpected TARGET_TYPE: \"${TARGET_TYPE}\"")
endif()

##################################################
# Build library
##################################################

# library
add_library( libio_operation STATIC
    source/io_operation.cpp
)

target_include_directories( libio_operation
    PUBLIC
        include
)

# Remove prefix for avoiding "liblibio_operation.a"
set_target_properties( libio_operation
    PROPERTIES
        PREFIX ""
        IMPORT_PREFIX ""
)

if(${TARGET_TYPE} STREQUAL "Real")
    # Nothing to do
elseif(${TARGET_TYPE} STREQUAL "Simulation")
    # test
    add_executable( test_io_operation
        test/test_io_operation.cpp
    )

    target_link_libraries( test_io_operation
        PRIVATE
            libio_operation
            GTest::gtest        # This target requires CMake version 3.20
            GTest::gtest_main   # This target requires CMake version 3.20
            GTest::gmock        # This target requires CMake version 3.23
            GTest::gmock_main   # This target requires CMake version 3.23
    )

    add_test(
        NAME test_io_operation
        COMMAND test_io_operation
    )
endif()

##################################################
# Build application
##################################################
add_executable( application
    source/main.cpp
)

target_link_libraries( application
    PRIVATE
        libio_operation
)

configure_embedded_executable( application )

##################################################
# Package creation
##################################################
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")

install(
    FILES
        $<TARGET_FILE:application>
    DESTINATION .
)

include(CPack)
