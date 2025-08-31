## Reference Apps

Authoring standards for reference application pages under `apps/`. These list vulnerable or exemplar applications used across tests, techniques, and demos.

Locations:

- `apps/android/MASTG-APP-####.md`
- `apps/ios/MASTG-APP-####.md`
- `apps/index.md` is the catalog landing page.

File naming and IDs:

- The app ID is defined by the filename: `MASTG-APP-\d{4}.md`.
- Do not add an `id:` field to the YAML front matter for apps.
- Use the next available number within the platform folder. Coordinate in PRs to avoid collisions.

Follow the global Markdown rules (see `.github/instructions/markdown.instructions.md`). Use `##` and `###` headings in the body.

### Markdown: Metadata

Include a YAML front matter block with these fields.

Required:

- `title:` App name with a disambiguator if needed (for example, "Android UnCrackable L1").
- `platform:` One of: `android`, `ios`.
- `source:` Canonical page to obtain the app (official repo, release artifact, or MASTG crackmes catalog entry). Prefer a stable, versioned URL when available.

Optional:

- `package:` Android applicationId (for example, `com.example.app`).
- `bundle:` iOS bundle identifier (for example, `com.example.app`).
- `store:` Store listing URL (Google Play, App Store) if relevant.
- `status:` `draft`, `placeholder`, or `deprecated`.
- `note:` Short clarifying note (for example, prerequisites or license).

Examples:

```yaml
---
title: Android UnCrackable L1
platform: android
source: https://mas.owasp.org/crackmes/Android#android-uncrackable-l1
package: sg.vantagepoint.uncrackable1
---
```

```yaml
---
title: iGoat-Swift
platform: ios
source: https://github.com/OWASP/iGoat-Swift
bundle: org.owasp.iGoat-Swift
---
```

### Markdown: Body

Keep entries short and purely referential; avoid duplicating installation or usage docs that belong in the app’s own repo.

Recommended sections:

- Overview: One or two sentences describing the app and what it’s useful for.
- Acquisition: Where to download (link to releases or IPA/APK/APP sources). Include brief notes if side-loading is required.
- Notes: Any platform-specific setup hints (e.g., jailbreak/root expectations, certificate installation for proxies).
- Related: Cross-link to tests, techniques, and demos that commonly use this app.

Cross-linking rules:

- In body text, reference project identifiers with a leading `@` (for example, @MASTG-TEST-0204, @MASTG-TECH-0014, @MASTG-TOOL-0031).
- In YAML front matter, always use bare identifiers without the `@`.

### Writing conventions

- Use the official app name and capitalization as used by the project.
- Prefer official sources (original repo or the MASTG Crackmes catalog) for download links.
- If the original source is gone, mark the page with `status: deprecated` and provide a short `note:` explaining why.

### Example

````markdown
## Overview

Android UnCrackable L1 is a purposely vulnerable application designed to practice reverse engineering and tampering techniques.

## Acquisition

- Crackmes catalog: https://mas.owasp.org/crackmes/Android#android-uncrackable-l1
- APK file is provided via the crackmes page.

## Notes

- Designed for analysis on emulators and physical devices.
- Works well with @MASTG-TOOL-0031 and @MASTG-TECH-0045.

## Related

- Tests: @MASTG-TEST-0252, @MASTG-TEST-0263
- Techniques: @MASTG-TECH-0039, @MASTG-TECH-0045
````

### Edge cases and guidance

- Open-source apps: Prefer linking to release artifacts (APK/IPA) rather than build-from-source instructions unless needed.
- Store-only apps: Use `store:` for the listing and add a short note if side-loading a specific version is necessary for reproducibility.
- Version specificity: When tests/demos require a specific version, state it clearly in the demo/test, not in the app entry; keep the app page evergreen.
- Deprecation: If an app becomes unavailable, set `status: deprecated` and add a `note:` with context and, if possible, a suggested replacement.
