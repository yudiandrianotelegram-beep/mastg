---
Title: Testing Enforced Updating
ID: MASTG-TEST-0x80
Platform: ios
MASVS v1: ['MSTG-ARCH-9']
MASVS v2: ['MASVS-CODE-2']
type: [static]
---

## Overview

This test verifies whether an app can force the user to update their app version when direct to by a the backend. This can be done by submitting the current version to the backend and blocking the user from using the application in case the backend deteremins that the user should update.

## Steps

1. Run a static analysis tool (@MASTG-TECH-0066) to examine the initial code flows of the application. Look for all paths that are executed before the user authenticates.

1. Examine the startup flow of the application. Identify if the application calls out to a backend with the application's version information included.
2. Examine if the application can handle a specific response from the backend indicating that the application must be updated. For example, the application might evaluate the response from the backend and show a specific error message. Note that the error message can also come from the backend, so the lack of a custom error message in the application does not mean that the feature isn't implemented.

## Observation

The application contains specific logic to handle a force-update event. The user may be able to ignore the prompt and continue using the application, or they may be unable to use the application without updating.

## Evaluation

The test case fails if the application does not contain any logic to handle a forced application update. Additionally, the test case fails if the application informs the user that they must update, but the user can ignore the prompt and still use the application.
