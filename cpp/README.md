# C/C++

## Requirements to User Project

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
