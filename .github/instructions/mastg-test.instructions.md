## Tests

Tests are platform-specific and must be located under tests-beta/android/ or tests-beta/ios/, within the corresponding MASVS category. Their file names are the test IDs.

Notes:

- Tests with `platform: network` are still organized under the OS folder that the MASVS category belongs to (for example, Android network tests live under `tests-beta/android/MASVS-NETWORK/`).

Tests have an overview and contain Steps which produce outputs called observations. After following the Steps you come up with an [Observation](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1#heading=h.h9gqgz4hdubj) which you will [Evaluate](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1#heading=h.lare0v58fwbf).

Example:

```sh
% ls -1 -F tests-beta/android/MASVS-CRYPTO/
MASTG-TEST-0204.md
MASTG-TEST-0205.md
```
Each test has two parts: the [Markdown metadata](#markdown-metadata) (YAML `front matter`) and the [Markdown body](#markdown-body).

### Markdown: Metadata

#### title

Test titles should be concise and clearly state the purpose of the test.

In some cases, the test name and the weakness may have the same title, but typically tests cover different aspects of a weakness. Titles should reflect that.

Avoid including Android or iOS unless necessary, as in "Insecure use of the Android Protected Confirmation API".

Follow a consistent style across all test titles.

**Conventions**

- Static: “References to…” (semgrep/r2)
- Dynamic: “Runtime Use …” (frida)

Exceptions may apply where "Runtime ..." feels forced, for example tests using adb, local backups, or filesystem snapshots.

Examples:

- [MASTG-TEST-0207](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0207/)
- [MASTG-TEST-0216](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0216/)
- [MASTG-TEST-0263](https://mas.owasp.org/MASTG/tests-beta/android/MASVS-STORAGE/MASTG-TEST-0263/)

#### platform

The mobile platform. One of: ios, android, network.

- Use network for platform-agnostic traffic analysis tests where the checks are performed purely on captured/observed traffic (often paired with type: [network]).

#### id

The test ID.

#### weakness

The MASWE weakness ID the test references.

- In YAML front matter, specify the bare identifier (for example, `weakness: MASWE-0069`). In body text, include the leading `@` (for example, @MASWE-0069).

#### type

One or more test types.

Supported: static, dynamic, network, manual, filesystem, developer.

- developer: tests that work on developer artifacts or supply-chain outputs (for example SBOM, dependency manager lockfiles, scanner reports) rather than the built app.

Example:

```md
type: [static]
```

Examples with multiple types:

```md
type: [dynamic, manual]
```

```md
type: [network]
```

#### best-practices

Reference platform-specific mitigations or best practices. Automation generates a “Mitigations” section.

New best practice files can be added under [best-practices/](https://github.com/OWASP/owasp-mastg/tree/master/best-practices).

Example:

```md
best-practices: [MASTG-BEST-0001]
```

This links to https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/

Notes:

- If no applicable best practices exist yet, you can omit the field or set an empty list: `best-practices: []`.

#### prerequisites

List prerequisites needed to execute or evaluate the test. Existing files are in `prerequisites/`. Create new ones if needed.

- If there are no prerequisites, you can omit this field or use an empty list.

Example:

```md
prerequisites:
- identify-sensitive-data
- identify-security-relevant-contexts
```

#### profiles

Specify MASVS profiles where the test applies. Valid values: L1, L2, P, R.
The profiles are described in [MAS Testing Profiles Guide]( https://docs.google.com/document/d/1paz7dxKXHzAC9MN7Mnln1JiZwBNyg7Gs364AJ6KudEs/edit?tab=t.0#heading=h.il6q80u4fm3n)

- L1 denotes Essential Security.
- L2 denotes Advanced Security.
- P denotes Privacy.
- R denotes Resilience.

Example:

```md
profiles: [L1, L2, P]
```

#### optional fields

Include these if relevant:

- `status:` draft, placeholder, deprecated
- `note:` short free-form note
- `available_since:` minimum platform/API level
- `deprecated_since:` last applicable platform/API level

Notes:

- For Android, available/deprecated API levels are integers (for example, `deprecated_since: 24`). For iOS, use the iOS release version (for example, `available_since: 13`).

### Markdown: Body

#### Overview

The overview is platform-specific and extends the weakness overview with details on the area tested. It may mention specific APIs and features.

Example:

```md
## Overview

Android apps sometimes use insecure pseudorandom number generators (PRNGs) such as `java.util.Random`, which is essentially a linear congruential generator. This type of PRNG generates a predictable sequence of numbers for any given seed value, making the sequence reproducible and insecure for cryptographic use. In particular, `java.util.Random` and `Math.random()` ([the latter](https://franklinta.com/2014/08/31/predicting-the-next-math-random-in-java/) simply calling `nextDouble()` on a static `java.util.Random` instance) produce identical number sequences when initialized with the same seed across all Java implementations.
```

#### Steps

A test must include one or more steps. Steps can be static, dynamic, manual, or mixed.

Example, to check app notifications:

1. method trace for related APIs (dynamic)
2. use the app (manual)
3. reverse engineer code or use backtraces and hooks (static)
4. perform taint analysis with controlled values (dynamic)
5. grep traces or integrate "grep" in a frida script (static/dynamic)

Example:

```md
## Steps

1. Run @MASTG-TECH-0014 on the app and look for insecure random APIs.
```

Notes:

- Always link to existing MASTG-TECH by ID (for example, @MASTG-TECH-0014)
- Don't reference MASTG tools directly (this may still be happening in some tests and we must fix it.)
- Be consistent by reusing the steps from existing tests. Do not create new phrasing or wording when it's not necessary.

#### Observation

The output you get after executing all steps. It serves as evidence.

It MUST start with “The output should contain ...”.

Example:

```md
## Observation

The output should contain a list of locations where insecure random APIs are used.
```

#### Evaluation

Using the observation as input, describe how to evaluate it. State explicitly what makes the test fail.

It MUST start with “The test case fails if ...”.

Example:

```md
## Evaluation

The test case fails if you can find random numbers generated using those APIs that are used in security-relevant contexts.
```
