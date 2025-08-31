## Rules

SAST rules live in `rules` folder. They can be referenced and reused by the demos.

### Semgrep rules

[https://semgrep.dev/docs/getting-started/quickstart/](https://semgrep.dev/docs/getting-started/quickstart/)
[https://semgrep.dev/learn](https://semgrep.dev/learn)
[https://academy.semgrep.dev/courses/secure-guardrails](https://academy.semgrep.dev/courses/secure-guardrails) 

Tip: use [https://semgrep.dev/playground/new](https://semgrep.dev/playground/new) for experimentation.

They must be named `mastg-<name of the test>.yaml` and follow valid syntax according to [https://semgrep.dev/docs/writing-rules/rule-syntax/](https://semgrep.dev/docs/writing-rules/rule-syntax/) 

* **id**:  same as the file name
* **severity**:
  * WARNING
  * ERROR
* **languages**: e.g. xaml, java (we don't create rules for kotlin as we only work with decompiled code which is in java)
* **metadata**: must include summary
  * summary: Short description of the rule.
  * original_source: you may use rules from sources on the internet be sure to check that the license allows this and always link to the original source here. Modify the rule if needed and the license allows for it.
* **message**: must start with the MASVS control ID and concisely explain what the rule is reporting.
* **patterns**: see [https://semgrep.dev/docs/writing-rules/pattern-syntax/](https://semgrep.dev/docs/writing-rules/pattern-syntax/) 

Do not include authors in the semgrep rules. If it was copied from some other place, **include the link to the original source**. Since many people will potentially contribute to the rule as part of the MASTG work, the authors will be calculated using git.

Example:

```yml
rules:
  - id: mastg-android-insecure-random-use
    severity: WARNING
    languages:
      - java
    metadata:
      summary: This rule looks for common patterns including classes and methods.
    message: "[MASVS-CRYPTO-1] The application makes use of an insecure random number generator."

    pattern-either:
        - patterns:
            - pattern-inside: $M(...){ ... }
            - pattern-either:
                - pattern: Math.random(...)
                - pattern: (java.util.Random $X).$Y(...)
```