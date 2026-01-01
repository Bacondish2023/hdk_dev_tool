cmake_minimum_required(VERSION 3.23)

# Use CMAKE_MSVC_RUNTIME_LIBRARY variable
# and MSVC_RUNTIME_LIBRARY target property to select the MSVC runtime library
cmake_policy(SET CMP0091 NEW)

project(example LANGUAGES C CXX)

# CTest
enable_testing()

# GoogleTest
find_package(GTest REQUIRED)

# boost
set(BOOST_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost COMPONENTS system thread REQUIRED)

# lint
find_program(CPPCHECK cppcheck REQUIRED)
add_custom_target(lint
    COMMAND ${CPPCHECK}
        --project=${CMAKE_BINARY_DIR}/compile_commands.json
        --std=c++11
        --enable=warning,performance,portability
        --suppress=missingIncludeSystem
        --suppress=preprocessorErrorDirective # To avoid error in boost header
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

    if( Boost_FOUND )
        # disable autolinking
        add_definitions("-DBOOST_ALL_NO_LIB")

        # Tell windows version to WindowsSDK for avoiding compile warnings
        add_definitions("-D_WIN32_WINNT=0x0A00") # Windows 10
    endif()

else()
    # nothing to do

endif()

##################################################
# build application
##################################################
add_subdirectory(asio)
add_subdirectory(circular_buffer)
