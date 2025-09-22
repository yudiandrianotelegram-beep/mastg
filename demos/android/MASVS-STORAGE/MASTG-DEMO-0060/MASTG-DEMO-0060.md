---
platform: android
title: App Writing Sensitive Data to Sandbox using EncryptedSharedPreferences
id: MASTG-DEMO-0060
code: [kotlin]
test: MASTG-TEST-0287
kind: pass
note: This demo shows how to store sensitive data securely in the app sandbox using the EncryptedSharedPreferences class.
---

### Sample

The following Kotlin code demonstrates how to securely store sensitive data (such as a password and API key) in the app sandbox using `EncryptedSharedPreferences`:

{{ MastgTest.kt }}

### Steps

1. Install the app on a device (@MASTG-TECH-0005)
2. Make sure you have @MASTG-TOOL-0001 installed on your machine and the frida-server running on the device
3. Run `run.sh` to spawn the app with Frida
4. Click the **Start** button
5. Stop the script by pressing `Ctrl+C` and/or `q` to quit the Frida CLI

{{ hooks.js # run.sh }}

### Observation

The output shows all instances of strings written using `EncryptedSharedPreferences` via `SharedPreferences` that were found at runtime. A backtrace is also provided to help identify the location in the code.

{{ output.json }}

### Evaluation

This test **passes** because sensitive data is stored using `EncryptedSharedPreferences`, which encrypts both keys and values at rest. Even if an attacker gains access to the app's sandbox, the data remains protected and unreadable without the app's encryption keys.

For example, to confirm this, run the following command:

```sh
adb shell cat /data/data/org.owasp.mastestapp/shared_prefs/MasSharedPref_Sensitive_Data.xml
```

Which returns:

{{ MasSharedPref_Sensitive_Data.xml }}

The actual values are not visible in plain text, confirming that encryption is applied.
