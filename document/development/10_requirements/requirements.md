# Requirements

## Introduction

#### Background

"Continuous Delivery" is widely known as a software development practice
that enables changes to be released to users safely and rapidly.

[Continuous Delivery Foundation: Continuous Delivery Definitions](https://github.com/cdfoundation/glossary/blob/main/definitions.md)

Traditionally, I have created workflows for my own projects
that incorporate the principles of "Continuous Delivery."
However, each project has its own workflow file,
and existing workflows are copied and reused when creating new projects.
This results in poor maintainability.

To address this issue, this project aims to develop reusable workflows
that can be invoked from other projects.

In addition, scripts that include build options have long been stored
in repositories with the goal of ensuring build reproducibility.
However, these scripts were not designed to be used from workflows
and do not change their return codes based on execution results.

As a result, workflows do not invoke these scripts directly;
instead, their contents are copied and implemented within the workflows,
which again leads to poor maintainability.

To resolve this, this project defines interfaces for generic project operations
such as build, lint, test, and clean,
and develops project operation scripts that can be used by both developers and workflows.

#### Scope

In scope

* Develop reusable workflows that can be invoked from other projects.
* Define interfaces for generic project operations
  and develop project operation scripts that can be used by both developers and workflows.

Out of scope

* Integrating the deliverables of this project into other projects.
  (This is considered the scope of those other projects.)


## Functional Requirements

#### [FR_1] Reusable Workflows

Description:  
Users can configure their projects to invoke reusable workflows provided by this project.

Rationale:  
To improve the maintainability of workflows.

#### [FR_1.1] Support Continuous Integration

Description:  
Users can use reusable workflows when integrating changes into the main branch.

#### [FR_1.1.1] Support the "Gated Commit" Pattern

Description:  
Changes are checked before being merged into the main branch on the remote repository.
Changes are merged only if they pass checks such as build, lint, and test.

[Wikipedia: Gated Commit](https://en.wikipedia.org/wiki/Gated_commit)

Rationale:  
To minimize defect injection and keep the main branch releasable.

#### [FR_1.2] Support Verification of Main Branch Updates

Description:  
Users can use reusable workflows to verify updates to the main branch.
The reusable workflows include checking steps such as build, lint, and test,
and users can receive the results of the verification.

Rationale:  
The possibility of defect creation or injection during the merge step cannot be completely eliminated.
This requirement ensures that users are made aware of issues.

#### [FR_2] Generic Project Operation Scripts

Description:  
Users can copy scripts provided by this project and integrate them into their own projects.

Rationale:  
To improve the maintainability of project operation scripts.

#### [FR_2.1] Error Handling

Description:  
Scripts should return 0 upon successful execution.
Scripts should return 1 upon failure.

Rationale:  
Workflows require return codes based on execution results in order to perform proper error handling.

#### [FR_2.2] Support Project-Specific Settings in Scripts

Description:  
Users can modify the copied scripts to add project-specific settings.

## Non-Functional Requirements

####  [NFR_1] Portability

Workflows and scripts should be platform-independent and support the following platforms:

* Linux
* Windows
* MacOS
