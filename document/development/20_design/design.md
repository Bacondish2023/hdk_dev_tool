# High Level Design

## Concept

The deliverables of this project are the reusable workflow **integration-gate** [FR_1]
and the **Generic Project Operation Scripts** [FR_2].

The figure below illustrates the concept of **hdk_dev_tool**.

![Concept](image/concept.png)

Users copy the Generic Project Operation Scripts into another project (the foo project in the figure)
and register them in the repository (hereafter referred to as **Copied Scripts**).
The Copied Scripts serve as interfaces for the other project.

Users can use the Copied Scripts when developing the other project.
If necessary, users can customize the Copied Scripts [FR_2.2].
For example, build types such as `Release` or `Debug` can be configured to be project-specific.

Users can configure workflows in other projects to invoke integration-gate.
This workflow verifies the target branch through the Copied Scripts.
Based on the return codes from the Copied Scripts,
the workflow performs error handling when errors occur [FR_2.1].

The figure below shows an expected usage of **hdk_dev_tool**.

![ExpectedUsage](image/expected_usage.png)

In step 1.1, the Author (User) pushes changes to the integration branch.

In step 1.2, when the Author (User) creates a pull request,
the Integration Workflow is triggered (1.3).
The Integration Workflow invokes integration-gate (1.4).
The integration-gate workflow verifies the target branch and returns the result.

The workflow execution results can be viewed through the Development Platform.
After that, the Reviewer (User) reviews both the changes and the workflow execution results,
and decides whether the changes should be merged into the main branch.
Only changes that are approved are merged into the main branch [FR_1.1] [FR_1.1.1].

In step 1.10, the Development Platform merges the changes into the main branch.
As a result, the Main Branch Verification Workflow is triggered (1.10).
The Main Branch Verification Workflow invokes integration-gate (1.11).
The integration-gate workflow similarly verifies the main branch and returns the result.

The workflow execution results can be viewed through the Development Platform.
In the event of a failure, the Development Platform also sends an email notification.

In step 1.14, the Author (User) deletes the integration branch.
Some platforms are known to provide settings that automatically delete
the integration branch after the pull request is approved and merged into the main branch.
If such a setting is enabled, the Author (User) does not need to delete the integration branch manually.

## Reusable Workflows

#### integration-gate

This workflow verifies the target branch.
The workflow consists of the following steps:

* Checkout
* Setup Environment
* Build
* Lint
* Test

In the **Setup Environment** step, tools such as GoogleTest and Boost are set up as needed.
Whether these tools are installed or not can be specified via parameters of this workflow.

The reason for performing GoogleTest setup and similar tasks within this workflow is
that the caller cannot perform environment setup before invoking a reusable workflow.

Parameters:

|Item|Description|Mandatory?|Type|Default|
|:---|:---|:---|:---|:---|
|platforms|Platforms in JSON array format|No|string|'["ubuntu-latest", "windows-latest", "macos-latest"]'|
|python-versions|Python versions in JSON array format|No|string|'["3.x"]'|
|build-type-library|Build type for external libraries.<br>One of {Debug, Release, RelWithDebInfo, MinSizeRel}.<br>Keep same with your do_build script|No|string|Debug|
|is-required-googletest|Setup switch for GoogleTest|No|boolean|true|
|is-required-boost|Setup switch for Boost|No|boolean|true|
|is-required-cppcheck|Setup switch for Cppcheck|No|boolean|true|

## Generic Project Operation Scripts

To support multiple platforms,
batch files and shell scripts are used for the implementation [NFR_1].

The return codes of the scripts are defined as follows [FR_2.1].

* 0: Success
* 1: Failure

The overall structure of the scripts is shown below:

* do_build.bat
* do_build.sh
* do_clean.bat
* do_clean.sh
* do_lint.bat
* do_lint.sh
* do_test.bat
* do_test.sh
