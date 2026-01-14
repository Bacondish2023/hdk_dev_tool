# Experiment

## Versioning

###### Purpose

CMake's `add_subdirectory` can be used to incorporate other projects, such as libraries.
In most cases, both the top-level project and the incorporated subprojects have their own versions.

Assume that both the top-level project and the subproject specify the `VERSION` argument
in their respective `project()` commands.
In this situation, the variables that provide version information `PROJECT_VERSION`
and `<PROJECT-NAME>_VERSION` should ideally behave as follows:

- In the top-level project's `CMakeLists.txt`, they should represent the top-level project's version.
- In the subproject's `CMakeLists.txt`, they should represent the subproject's version.

However, it was unclear whether CMake actually behaves in this way.
Therefore, this experiment was conducted to verify the behavior.

###### Procedure

Build the example project located in `001_versioning`.

###### Results

The following output was obtained:

```
example_project: PROJECT_VERSION is 0.0.2
example_project: example_project_VERSION is 0.0.2
sub_project: PROJECT_VERSION is 1.0.0
sub_project: sub_project_VERSION is 1.0.0
example_project: PROJECT_VERSION is 0.0.2
example_project: example_project_VERSION is 0.0.2
...
```

Lines starting with `example_project:` are output from the top-level project,
while lines starting with `sub_project:` are output from the subproject.

From these results, it can be concluded that the top-level project obtains
its own version information, and the subproject also obtains its own version
information as expected.
