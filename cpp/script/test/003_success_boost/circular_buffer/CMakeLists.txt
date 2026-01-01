add_executable( exmaple_circular_buffer
    exmaple_circular_buffer.cpp
)

target_include_directories( exmaple_circular_buffer
    PUBLIC
        ${Boost_INCLUDE_DIRS}
)

target_link_libraries( exmaple_circular_buffer
    PRIVATE
        ${Boost_LIBRARIES}
)

# Test succeed if the executable run
add_test(
    NAME exmaple_circular_buffer
    COMMAND exmaple_circular_buffer
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
