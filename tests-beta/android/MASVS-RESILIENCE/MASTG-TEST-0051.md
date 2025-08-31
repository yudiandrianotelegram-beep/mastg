---
title: Testing Obfuscation
platform: android
id: MASTG-TEST-0051
type: [static, dynamic]
profiles: [R]
---

## Overview

Code obfuscation is a form of software protection that makes code more difficult to understand and analyze, thereby increasing the effort required for reverse engineering. While obfuscation doesn't prevent reverse engineering entirely, it raises the bar for attackers by making static and dynamic analysis more time-consuming and complex.

This test checks whether the app implements obfuscation techniques to protect sensitive code and data. Common obfuscation techniques include:

- **Name obfuscation**: Replacing meaningful class, method, and variable names with meaningless identifiers
- **String encryption**: Encrypting hardcoded strings and decrypting them at runtime
- **Control flow flattening**: Restructuring code to make the program flow harder to follow
- **Dead code injection**: Adding non-functional code to increase analysis overhead
- **Instruction substitution**: Replacing standard instructions with more complex equivalents

For Android apps, obfuscation can be applied at both the Java bytecode level (using tools like ProGuard or R8) and the native code level (using tools like Obfuscator-LLVM).

## Steps

### Static Analysis

1. Decompile the APK using @MASTG-TECH-0017.
2. Review the decompiled code using @MASTG-TECH-0023 to identify obfuscation patterns:
   - Look for meaningless class, method, and variable names (e.g., `a`, `b`, `aa`, `ab`)
   - Check for encrypted or encoded string literals
   - Examine the control flow structure for signs of flattening or complex branching
   - Identify any dead code or dummy instructions
3. For native libraries, analyze using @MASTG-TECH-0018 to detect:
   - Symbol stripping
   - Control flow obfuscation
   - Instruction substitution
   - API call obfuscation

### Dynamic Analysis

1. Use @MASTG-TOOL-0009 to analyze the APK and detect obfuscation techniques:

   ```bash
   apkid <app.apk>
   ```

2. Look for indicators such as:
   - "unreadable field names"
   - "unreadable method names"
   - Specific obfuscator signatures
   - Packer identification

## Observation

The output should include:

### Static Analysis

- Evidence of name obfuscation (meaningless identifiers in decompiled code)
- Presence of encrypted or obfuscated strings
- Complex or flattened control flow structures
- Native code obfuscation indicators

### Dynamic Analysis

- APKiD detection results showing obfuscation techniques
- Identified obfuscators, packers, or protection tools

## Evaluation

The test case passes if obfuscation techniques are properly implemented:

- **For basic obfuscation**: Class, method, and variable names should be meaningless identifiers rather than descriptive names
- **For string protection**: Sensitive strings should be encrypted or encoded, not stored in plaintext
- **For control flow protection**: Code structure should show signs of flattening or complexity beyond normal compilation
- **For native code**: Symbols should be stripped and code should show signs of obfuscation

The test case fails if:

- No obfuscation is detected in either Java bytecode or native code
- Sensitive functionality uses clear, descriptive names that aid reverse engineering
- Hardcoded secrets, keys, or sensitive strings are stored in plaintext
- The code structure follows standard, easily readable patterns without any protection

Note that the effectiveness of obfuscation should be evaluated based on the sensitivity of the protected functionality and the threat model of the application.
