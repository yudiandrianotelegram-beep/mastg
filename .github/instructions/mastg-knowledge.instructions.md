## Knowledge Base

Authoring standards for the Knowledge Base under `knowledge/`. Knowledge pages explain Android or iOS features and concepts that tests and techniques rely on. They are descriptive, not prescriptive: do not include security recommendations here.

Locations and taxonomy:

- `knowledge/android/MASVS-<CATEGORY>/MASTG-KNOW-####.md`
- `knowledge/ios/MASVS-<CATEGORY>/MASTG-KNOW-####.md`
- `knowledge/index.md` is the catalog landing page.

`<CATEGORY>` is one of: `AUTH`, `CODE`, `CRYPTO`, `NETWORK`, `PLATFORM`, `PRIVACY`, `RESILIENCE`, `STORAGE`.

File naming and IDs:

- The knowledge ID is defined by the filename: `MASTG-KNOW-\d{4}.md`.
- Do not add an `id:` field to the YAML front matter.
- Place the file in the platform (`android` or `ios`) and MASVS category folder that best matches the subject.

Follow the global Markdown rules (see `.github/instructions/markdown.instructions.md`). Use `##` and `###` headings in the body.

### Markdown: Metadata

Include a YAML front matter block with these fields.

Required:

- `masvs_category:` One of: `MASVS-AUTH`, `MASVS-CODE`, `MASVS-CRYPTO`, `MASVS-NETWORK`, `MASVS-PLATFORM`, `MASVS-PRIVACY`, `MASVS-RESILIENCE`, `MASVS-STORAGE`.
- `platform:` One of: `android`, `ios`.
- `title:` Clear and specific concept title (for example, "Android KeyStore").

Optional:

- `status:` `draft`, `placeholder`, or `deprecated`.
- `note:` Short free-form note to clarify scope.
- `available_since:` Minimum platform/API level (Android: integer API level; iOS: release version, for example `13`).
- `deprecated_since:` Last applicable platform/API level.
- `deprecation_note:` If deprecated, add a short rationale and replacement guidance.
- `covered_by:` List of knowledge IDs that supersede this page (use bare IDs).

Examples:

```yaml
---
masvs_category: MASVS-STORAGE
platform: android
title: Android KeyStore
available_since: 18
---
```

```yaml
---
masvs_category: MASVS-AUTH
platform: android
title: FingerprintManager
available_since: 23
deprecated_since: 28
status: deprecated
deprecation_note: The FingerprintManager class is deprecated in Android 9 (API level 28). Prefer BiometricPrompt or the Biometric library.
covered_by: [MASTG-KNOW-0001]
---
```

### Markdown: Body

Keep content authoritative, concise, and platform-focused. Avoid duplicating OS documentation; cite it and summarize what the feature is and how it works. Do not prescribe how to use it securely; move guidance to Best Practices and link to it.

Recommended sections:

- Overview: Define the concept and its scope. Relate to OS components, APIs, or security model elements.
- Security Context: Explain typical security-relevant behaviors or implications of the feature without recommending mitigations.
- Platform Details: API names, version nuances, storage locations, configuration knobs. Keep code samples short and explanatory.
- References: Official docs and standards. Avoid non-authoritative sources.
- Related: Cross-link to tests, techniques, tools, and best practices.

Cross-linking rules:

- In body text, reference project identifiers with a leading `@` (for example, @MASTG-TEST-0204, @MASTG-TECH-0014, @MASTG-TOOL-0031, @MASTG-BEST-0011).
- In YAML front matter, always use bare identifiers without the `@`.

### Writing conventions

- Use American spelling, second person, and active voice.
- Prefer short paragraphs and bullet lists for scannability.
- Use HTML `<img>` for images as per the markdown instructions.

### Example

````markdown
## Overview

Android KeyStore is a system-provided credential store that keeps cryptographic keys bound to the device and, optionally, to user authentication. Keys can be marked non-exportable and their usage can be limited.

## Security Context

- Keys can be hardware-backed depending on device support and OS version.
- Key usage can be constrained (purposes, modes, paddings) and optionally bound to user authentication.

## Platform Details

- Introduced in API level 18; many features evolved in later releases.
- Key properties are controlled via KeyGenParameterSpec.

## References

- Android docs - Keystore: https://developer.android.com/training/articles/keystore

## Related

- Tests: @MASTG-TEST-0263
- Techniques: @MASTG-TECH-0014
- Tools: @MASTG-TOOL-0033
- Best practices: @MASTG-BEST-0011 (see this page for actionable guidance)
````

### Edge cases and guidance

- Cross-category content: If a topic spans two MASVS categories, choose the best fit and reference the other in the body; avoid duplicate pages.
- Generic vs platform: Concepts that are identical across platforms should be split into platform folders if platform detail matters; otherwise, place details where they differ and keep overviews succinct.
- Deprecation: Mark with `status: deprecated`, add `deprecation_note`, and point to the replacement via `covered_by` or explicit links.
- Where to place recommendations: Keep all prescriptive advice (do/don't, secure configuration values, mitigations) in Best Practices pages under `best-practices/`, and link them from the "Related" section.
