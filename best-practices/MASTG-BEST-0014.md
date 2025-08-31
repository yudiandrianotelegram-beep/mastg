---
title: Preventing Screenshots and Screen Recording
alias: preventing-screenshots-and-screen-recording
id: MASTG-BEST-0014
platform: android
---

Apps should prevent sensitive data from being captured from the UI, leaving the control of the user, and potentially leaking. This includes:

- **System-generated snapshots** are sandboxed, but may still be accessible on rooted or compromised devices or through forensic acquisition.
- **User-initiated screenshots** are accessible to the user and to any app with storage or media access. They may also be automatically synced to cloud services such as Google Photos.
- **Screen recordings** can capture all visual content, including transient data such as passcodes or one-time codes, and may be stored or shared without the user's awareness.
- **Nonsecure displays and remote screen sharing** can expose sensitive information to external monitors, casting devices, or remote control software.

Depending on the threat model of the app, one or more protections may be required. For example, on-screen keyboards or custom keypad views should be secured to prevent keystroke leakage from passcode fields. A banking app should ensure that account balances or transaction details are never visible in captured images, unless the user explicitly chooses to allow screenshots.

Setting [`FLAG_SECURE`](https://developer.android.com/security/fraud-prevention/activities#flag_secure) on the window prevents screenshots (or makes them appear black), blocks screen recording, and hides content on nonsecure displays and in the system task switcher.

<div style="display:flex; flex-wrap:wrap; gap:16px; align-items:flex-start; margin:16px 0;">
  <figure style="flex:1 1 220px; margin:0; text-align:center;">
    <img src="Images/Chapters/0x05d/task-switcher-without-flag-secure.png" width="200" alt="Task switcher without FLAG_SECURE">
    <figcaption>Without <code>FLAG_SECURE</code></figcaption>
  </figure>
  <figure style="flex:1 1 220px; margin:0; text-align:center;">
    <img src="Images/Chapters/0x05d/task-switcher-with-flag-secure.png" width="200" alt="Task switcher with FLAG_SECURE">
    <figcaption>With <code>FLAG_SECURE</code></figcaption>
  </figure>
</div>

Refer to the official documentation for implementation details, see ["Secure sensitive activities"](https://developer.android.com/security/fraud-prevention/activities). Consider adding an in-app setting to enable or disable this behavior, giving users control without compromising security by default.
