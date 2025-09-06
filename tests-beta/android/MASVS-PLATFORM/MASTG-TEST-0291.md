---
title: References to Screen Capturing Prevention APIs
platform: android
id: MASTG-TEST-0291
type: [static]
profiles: [L2]
best-practices: [MASTG-BEST-0014]
weakness: MASWE-0055
---

## Overview

This test verifies whether an app references Android screen capture prevention APIs. On Android, developers can prevent screenshots and non-secure display mirroring using [`FLAG_SECURE`](https://developer.android.com/security/fraud-prevention/activities#flag_secure). When set, Android blocks screenshots, prevents content from appearing on non-secure displays (including remote screen sharing), and blocks capture through MediaProjection or virtual displays. Screenshots are blocked (resulting images are blank or obscured and the system may show a policy message), and the app's content is not shown in Recents when backgrounded.

**UI Components Exposing Window Getters or LayoutParams:**

`FLAG_SECURE` is applied per window. Any UI that creates its own `Window` must set it if sensitive content can appear there. This includes all components that:

- can call `getWindow()` (e.g., `Activity`, `Dialog`, `Presentation`)
- expose `.window` (e.g., `DialogFragment`)
- allow setting `LayoutParams` (e.g., overlays or custom views added with `WindowManager.addView()`)

Other components that create separate windows but do not expose `getWindow()` directly (e.g., `PopupWindow`) cannot have `FLAG_SECURE` applied directly.

The flag is applied with [`addFlags()`](https://developer.android.com/reference/android/view/Window#addFlags(int)) or [`setFlags()`](https://developer.android.com/reference/android/view/Window#setFlags(int,int)). Common failure modes include:

- Missing a window: not setting `FLAG_SECURE` on all windows that can show sensitive data.
- Lifecycle gaps: setting too late or clearing during transitions (e.g., using [`clearFlags()`](https://developer.android.com/reference/android/view/Window#clearFlags(int)) or `setFlags()` without reapplying). Sensitive previews for Recents can be captured before callbacks like `onPause()`.

**SurfaceViews:**

`SurfaceView` create a separate surface that is not protected by `FLAG_SECURE` even if the containing window has it set. To protect content in a `SurfaceView`, developers must use [`setSecure(true)`](https://developer.android.com/reference/android/view/SurfaceView#setSecure(boolean)) before the surface view's containing window is attached to the window manager.

**Compose Dialogs:**

In Compose dialogs, developers can set the secure policy which enables or disables the `FLAG_SECURE` flag to the dialog window using:

- [`SecureOn`](https://developer.android.com/reference/kotlin/androidx/compose/ui/window/SecureFlagPolicy#SecureOn)
- [`Inherit`](https://developer.android.com/reference/kotlin/androidx/compose/ui/window/SecureFlagPolicy#Inherit)
- [`SecureOff`](https://developer.android.com/reference/kotlin/androidx/compose/ui/window/SecureFlagPolicy#SecureOff)

**Recents Screenshots:**

Starting with Android 13 (API level 33), developers can disable Recents screenshots using [`setRecentsScreenshotEnabled()`](https://developer.android.com/reference/android/app/Activity#setRecentsScreenshotEnabled(boolean)):

- This prevents sensitive content from appearing in the system-generated snapshots used for the Recents screen:
    - the snapshots saved to `/data/system_ce/<user_id>/snapshots` will be blank/obscured.
    - the previews blank after the user switches away from the app completely, similar to the behavior of `FLAG_SECURE`
- It does not prevent user-initiated screenshots or screen recordings.
    - Users can take screenshots using the hardware shortcut and the content will appear in those screenshots.
    - Tapping "Screenshot" in Recents will not produce a snapshot (the system may show a policy message depending on device/ROM).

## Steps

1. Run a static analysis (@MASTG-TECH-0014) tool to identify instances of the relevant APIs.

## Observation

The output should include a list of locations where the relevant APIs are used.

## Evaluation

The test case fails if the relevant APIs are missing or inconsistently applied on any UI component that displays sensitive data, or if code paths clear the protection without an adequate justification.

NOTE: Detecting all possible instances of `FLAG_SECURE` can be challenging:

- This flag cannot be applied globally. Every component that creates a window must explicitly set it, e.g. `Activity`, `Dialog`, `DialogFragment`, `AlertDialog`, or any custom window added via `WindowManager`. Sometimes apps use a base UI class and make all sensitive screens inherit it.
- The lifecycle of the app must be considered, as the flag needs to be set before sensitive content is rendered in a new window. For example, trying to add the flag in `onPause()` is not effective, as the preview is created before this method is called.
- Special care must be taken with fragments and their lifecycle, as they can be added or removed dynamically.

Also note that even if the flag is correctly set, the content is not obscured until the user actually switches to another app or the home screen.
