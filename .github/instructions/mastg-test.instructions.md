## Tests

Tests are platform-specific and must be located under tests-beta/android/ or tests-beta/ios/, within the corresponding MASVS category. Their file names are the test IDs.

Tests have an overview and contain Steps which produce outputs called observations: after following the Steps you come up with an [Observation](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1#heading=h.h9gqgz4hdubj) which you will [Evaluate](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1#heading=h.lare0v58fwbf).

Example:

`% ls -1 -F tests-beta/android/MASVS-CRYPTO/`
`MASTG-TEST-0204.md`
`MASTG-TEST-0205.md`

### Markdown: Metadata

#### title

Test titles should be concise and clearly state the purpose of the test.

In some cases, the test name and the weakness may have the same title, but typically the tests will test different aspects of a weakness (as defined in "Modes of introduction"), so the titles need to reflect that.

Avoid including Android or iOS in the titles unless absolutely necessary, as in "Insecure use of the Android Protected Confirmation API".

Please ensure that the titles follow a similar structure and style to other titles in the dataset.

##### **Conventions**

* **Static**: “References to…” (semgrep/r2)
* **Dynamic**: “Runtime Use …” (frida)

We currently consider some exceptions to this convention for “dynamic tests” where it would feel forced to start it with "Runtime ...". For example, when the test is based on using tools like adb (e.g. to perform a local backup), performing file system snapshots, etc.

Examples include: 

* [MASTG-TEST-0207](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0207/)
* [MASTG-TEST-0216](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0216/)
* [MASTG-TEST-0263](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0263/)

platform
The mobile platform. Can be one of: ios, android.

#### id

The ID of the test

#### weakness 

The MASWE weakness ID the test is referencing.

#### 

#### type

A test can have one or more types.

Supported types: static, dynamic, network, manual.

Example:

`type: [static]`

#### mitigations

Use mitigations in the test metadata to add platform specific mitigations or best practices. Our automation will create a “Mitigations” section automatically.

You can create new best practice files under [best-practices/](https://github.com/OWASP/owasp-mastg/tree/master/best-practices) and use them as mitigations.

Example:

`mitigations: [MASTG-BEST-0001]`

This will create a link to [https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/](https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/) 

#### prerequisites

Link to any prerequisites needed for executing or evaluating the test.

Existing prerequisites are in the prerequisites/ folder. Create new ones if required.

For example, for evaluating the results of the test you may need to have identified the sensitive data relevant to your app.

Example:

`prerequisites:`
`- identify-sensitive-data`
`- identify-security-relevant-contexts`

### 

### Markdown: Body

#### Overview

The overview of a test is platform-specific and acts as an extension of the weakness overview for the particular area covered by the test. It may mention specific APIs and platform features.

Example: 

`## Overview`

``Android apps sometimes use insecure pseudorandom number generators (PRNGs) such as `java.util.Random`, which is essentially a linear congruential generator. This type of PRNG generates a predictable sequence of numbers for any given seed value, making the sequence reproducible and insecure for cryptographic use. In particular, `java.util.Random` and `Math.random()` ([the latter](https://franklinta.com/2014/08/31/predicting-the-next-math-random-in-java/) simply calling `nextDouble()` on a static `java.util.Random` instance) produce identical number sequences when initialized with the same seed across all Java implementations.``

#### Steps

A test must include one or more steps that can be static, dynamic, both. Previously in the MASTG we were forcing one or the other and sometimes mention that you can do both. But usually the steps will be mixed.

For example, to "check app notifications"

1. method trace for related APIs (dynamic)
2. use the app (manual)
3. RE to understand use or use backtraces & more hooking (static)
4. taint analysis using known/self-defined values and letting them get to the notification (dynamic)
5. grep the method trace or integrate "grep" in a frida script (static/dynamic)

Example:

`## Steps`

`1. Run a [static analysis](/MASTG/techniques/android/MASTG-TECH-0014.md) tool on the app and look for insecure random APIs.`

**Always link to existing techniques** (or create new ones if they don’t exist yet) to prevent duplication or repetition of content. In this example: techniques/android/MASTG-TECH-0014.md

#### Observation

This is the output you get after executing all steps. It serves as evidence.

Examples: method trace for specific APIs, network traffic trace filtered in some way, hooking events containing sensitive data (indicating which APIs handle that data).

It should start with “The output should contain …”.

Example:

`## Observation`

`The output should contain a **list of locations where insecure random APIs are used**.`

#### Evaluation

Using the observation as input, the evaluation tells you how to evaluate it and must explicitly describe what makes the test fail.

It should start with “The test case fails if …”

Example:

`## Evaluation`

`The test case fails if you can find random numbers generated using those APIs that are used in security-relevant contexts.`