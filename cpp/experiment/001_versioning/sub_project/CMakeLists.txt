cmake_minimum_required(VERSION 3.0)

cmake_policy(SET CMP0048 NEW) # This requires CMake version 3.0

project(sub_project VERSION 1.0.0) # This requires CMake version 3.0

message("sub_project: PROJECT_VERSION is ${PROJECT_VERSION}")
message("sub_project: sub_project_VERSION is ${sub_project_VERSION}")

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/include/version.hpp.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.hpp
    @ONLY
)

add_library( libsub_project STATIC
    source/arithmetic.cpp
)

target_include_directories( libsub_project
    PUBLIC
        include
    PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}/generated
)

# Remove prefix for avoiding "liblibsub_project.a"
set_target_properties( libsub_project
    PROPERTIES
        PREFIX ""
        IMPORT_PREFIX ""
)
