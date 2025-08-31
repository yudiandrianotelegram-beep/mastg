---
masvs_category: MASVS-STORAGE
platform: android
title: Screenshots
best-practices: [MASTG-BEST-0014]
---

## System-Generated Snapshots

Android captures visual representations of apps for different purposes, which can lead to unintended exposure of sensitive data. When an app goes into the background, the system creates a snapshot of its UI for the [Recents screen](https://developer.android.com/guide/components/activities/recents). This behavior is automatic and helps the user visually recognize tasks when switching apps. If the app does not obscure its UI, sensitive information may appear in these snapshots.

System-generated snapshots for the Recents screen are stored under `/data/system_ce/<user_id>/snapshots` on modern Android versions, or `/data/system` on older versions. These locations are protected by the system sandbox, meaning ordinary apps cannot read them, but they can be accessed on rooted or compromised devices or through forensic acquisition. The exact path and structure may vary depending on the Android version and device vendor.

## User-Initiated Screenshots

Users can take screenshots at any time using system shortcuts. A malicious app with screen-capture capabilities, or malware on a rooted or compromised device, can also capture the display contents without the user's knowledge.

User-initiated screenshots are stored in the **shared external storage**, typically under `/sdcard/Pictures/Screenshots/` or a similar public media directory depending on the device and Android version. These files are accessible to the user and to any app with storage or media access permissions. They may also be synced automatically to cloud services such as Google Photos. Because they are outside the app sandbox, once a screenshot is taken the app has no control over its lifecycle, distribution, or deletion.
