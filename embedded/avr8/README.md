# Embedded AVR8

The AVR8 scripts use CMake Presets to manage the build configuration.
Embedded software may require not only a build configuration for the actual hardware,
but also a build configuration for the host computer for testing purposes.
Therefore, flexible build configuration management using CMake Presets is important.

This repository provides a `real` build configuration for the actual hardware
and a `simulation` build configuration for the host computer.
The `simulation` build configuration defines the `SIMULATION` symbolic constant.
You can use `SIMULATION` in the source code
to switch between processing for the actual hardware and processing for the host computer.

```c++
#ifdef SIMULATION
    // Host computer specific code
#else
    // Real hardware specific code
#endif
```

Each build configuration has its own CMake toolchain file.
The `configure_embedded_executable` function is defined in these files.
For the `real` build configuration,
this function configures executable targets appropriately for the embedded environment.
It makes it easy to create targets that generate disassembly files
and program (flash) the actual hardware.

An example of using `configure_embedded_executable` is shown below:

```cmake
add_executable(your_executable main.cpp)

configure_embedded_executable(your_executable)
```

## Requirements to User Project

### Package Target

The `do_build` scripts require a `package` target to be defined.
This target is used by the reusable workflow to perform the packaging process.
It is intended for CPack integration.

If you do not have any packaging steps to perform,
you can define a dummy `package` target as shown below.

``` cmake
add_custom_target(package
    COMMAND cmake -E echo Nothing to do about package.
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
```

### Lint Target

The `do_lint` scripts require a `lint` target to be defined.
This target is used by the reusable workflow to perform static analysis
and determine the success or failure of the lint step.

If you use the Generic Project Operation Scripts **as-is**, without customization,
it is recommended to define the `lint` target in the top-level
`CMakeLists.txt` file of your project.
If you customize the scripts, this requirement does not necessarily apply.

An example is shown below:

```cmake
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
```
