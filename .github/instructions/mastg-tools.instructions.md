## Tools

Authoring standards for tool reference pages under `tools/`. These pages document tools used throughout tests, demos, and techniques in the MASTG.

Locations:

- `tools/android/MASTG-TOOL-####.md`
- `tools/ios/MASTG-TOOL-####.md`
- `tools/generic/MASTG-TOOL-####.md` (cross-platform or platform-agnostic tools)
- `tools/network/MASTG-TOOL-####.md` (traffic analysis and proxying)

File naming:

- The tool ID is defined by the filename: `MASTG-TOOL-\d{4}.md`.
- Do not add an `id:` field to the YAML front matter for tools.
- Use the next available number for the target folder. Coordinate in PRs to avoid clashes.

Follow the global Markdown rules (see `.github/instructions/markdown.instructions.md`) for headings, images, code blocks, and style.

### Markdown: Metadata

Include a YAML front matter block with these fields.

Required:

- `title:` Concise tool name. Add a qualifier when needed to disambiguate (for example, "Frida for Android", "nm - iOS").
- `platform:` One of: `android`, `ios`, `generic`, `network`.

Optional:

- `source:` Canonical homepage or repository URL.
- `host:` List of operating systems the tool runs on. Prefer this exact set (case-sensitive values): `windows`, `linux`, `macOS`, `ios`, `android`.
  - Use `host:` with a YAML list (preferred). If you find `hosts:` in legacy pages, migrate to `host:` when touching the file.
  - Use `ios` / `android` for on-device tools (for example, Filza).
- `alternatives:` List of tool IDs that provide comparable functionality.
- `status:` `draft`, `placeholder`, or `deprecated`.
- `deprecation_note:` Short justification and replacement guidance (required when `status: deprecated`).
- `covered_by:` List of tool IDs that supersede this tool (required when `status: deprecated`).
- `note:` Short free-form note to clarify scope or limitations.

Examples:

```yaml
---
title: Frida for Android
platform: android
source: https://github.com/frida/frida
host: [windows, linux, macOS]
alternatives:
  - MASTG-TOOL-0031   # Frida (generic)
---
```

```yaml
---
title: Cycript
platform: ios
source: https://www.cycript.org/
status: deprecated
deprecation_note: Cycript is no longer maintained and fails on modern iOS versions. Prefer Frida which is actively supported and more capable.
covered_by: [MASTG-TOOL-0039]
---
```

### Markdown: Body

Keep pages practical, scannable, and focused on security testing use. Use `##` and `###` headings.

Recommended section outline:

- Overview: One short paragraph describing what the tool is and where it fits.
- Capabilities and Use Cases: Bullet list of relevant features for mobile testing.
- Installation: Platform-specific notes (link out to official docs when appropriate). Include the minimal, verified commands to get started.
- Usage: Common commands, flags, or workflows relevant to MASTG tests/demos. Prefer concrete, copyable examples.
- Examples: Short, targeted examples for typical tasks. If examples are long, link to demos or techniques instead.
- Caveats and Limitations: Version compatibility, jailbreak/root requirements, known issues.
- References: Links to official docs, repos, and authoritative resources.
- Related: Cross-link to relevant tests, demos, and techniques.

Cross-linking rules:

- In body text, reference project identifiers with a leading `@` (for example, @MASTG-TEST-0204, @MASTG-TOOL-0031, @MASTG-TECH-0014).
- In YAML front matter, always use bare identifiers without the `@`.

Example snippets:

````markdown
## Usage

List running apps and attach to a process:

```sh
frida-ps -Uai
frida -U -n com.example.app -l hook.js
```

See @MASTG-TECH-0014 for guidance on dynamic method tracing and @MASTG-TEST-0252 for a test that benefits from this tool.
````

````markdown
## References

- GitHub: https://github.com/frida/frida
- Docs: https://frida.re/docs/home/
````

### Conventions and Quality

- Prefer official sources for installation steps; avoid advertising or endorsing third-party distributions.
- Favor commands that work across supported hosts when possible; otherwise clearly label host-specific commands.
- For images, use HTML `<img>` tags per the markdown instructions (store assets in an appropriate images folder if needed).
- Keep examples minimal and verifiable; longer walkthroughs belong in demos with runnable scripts.

### How tests and demos should reference tools

- Tests and demos should reference tools by ID whenever available:
  - In body text: `@MASTG-TOOL-0031`.
  - In YAML (for example, demo `tools:` list): `MASTG-TOOL-0031`.
- If a commonly used tool lacks an official MASTG tool page, demos may temporarily list the tool by name (for example, `tools: [semgrep]`). Prefer adding a tool page and switching to the ID in follow-ups.
