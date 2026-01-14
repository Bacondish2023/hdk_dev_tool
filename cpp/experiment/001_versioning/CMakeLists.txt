cmake_minimum_required(VERSION 3.0)

cmake_policy(SET CMP0048 NEW) # This requires CMake version 3.0

project(example_project VERSION 0.0.2) # This requires CMake version 3.0

message("example_project: PROJECT_VERSION is ${PROJECT_VERSION}")
message("example_project: example_project_VERSION is ${example_project_VERSION}")

add_subdirectory(sub_project)

message("example_project: PROJECT_VERSION is ${PROJECT_VERSION}")
message("example_project: example_project_VERSION is ${example_project_VERSION}")

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/include/version.hpp.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.hpp
    @ONLY
)

add_executable( application
    source/main.cpp
)

target_include_directories( application
    PRIVATE
        include
        ${CMAKE_CURRENT_BINARY_DIR}/generated
)

target_link_libraries( application
    PRIVATE
        libsub_project
)
