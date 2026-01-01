add_executable( example_io_service
    example_io_service.cpp
)

target_include_directories( example_io_service
    PUBLIC
        ${Boost_INCLUDE_DIRS}
)

target_link_libraries( example_io_service
    PRIVATE
        ${Boost_LIBRARIES}
)

# Test succeed if the executable run
add_test(
    NAME example_io_service
    COMMAND example_io_service
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
