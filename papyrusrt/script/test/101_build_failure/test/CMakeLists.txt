add_executable( TestLibAliceAndBobProxy
    TestLibAliceAndBobProxy.cpp
)

target_link_libraries( TestLibAliceAndBobProxy
    PRIVATE
        libAliceAndBobProxy
        librts
        GTest::gtest        # This target requires CMake version 3.20
        GTest::gtest_main   # This target requires CMake version 3.20
        GTest::gmock        # This target requires CMake version 3.23
        GTest::gmock_main   # This target requires CMake version 3.23
)

add_test(
    NAME TestLibAliceAndBobProxy
    COMMAND TestLibAliceAndBobProxy
)
