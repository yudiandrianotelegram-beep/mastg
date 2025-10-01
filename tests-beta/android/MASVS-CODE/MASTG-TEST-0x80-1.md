---
Title: Testing Enforced Updating
ID: MASTG-TEST-0x80-1
Platform: android
MASVS v1: ['MSTG-ARCH-9']
MASVS v2: ['MASVS-CODE-2']
type: [dynamic]
---

## Overview

This test verifies whether an app can force the user to update their app version when direct to by a the backend. This can be done by submitting the current version to the backend and blocking the user from using the application in case the backend deteremins that the user should update.

## Steps

1. Obtain a MitM position between the application and its backend (see @MASTG-TECH-0011).
2. Identify if version information is sent to the backend or if a minimum supported version is retrieved from the backend. This can be as part of a header, the URL, a URL parameter or the HTTP body.
3. In case the app's version is submitted to the backend, interact with the backend to see if different version numbers trigger different responses.
4. If a different response can be identified, modify an active request with the old version number to examine how the application reacts to the new backend response.

## Observation

The server responds differently to older versions.

## Evaluation

The test case fails if the application does not send its version information to the backend.
