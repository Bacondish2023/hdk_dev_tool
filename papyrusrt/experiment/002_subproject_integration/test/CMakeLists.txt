add_executable( TestExperiment
    TestExperiment.cpp
)

target_link_libraries( TestExperiment
    PRIVATE
        libSubProject
        librts
        GTest::gtest        # This target requires CMake version 3.20
        GTest::gtest_main   # This target requires CMake version 3.20
        GTest::gmock        # This target requires CMake version 3.23
        GTest::gmock_main   # This target requires CMake version 3.23
)

add_test(
    NAME TestExperiment
    COMMAND TestExperiment
)
