---
title: Use `SecureOn` to Prevent Screenshots in Compose Dialogs
alias: use-secureon-in-compose-dialogs
id: MASTG-BEST-0018
parent: MASTG-BEST-0014
platform: android
component: androidx.compose.ui:ui
available_since: 1.0.0
---

In Compose dialogs, set the secure policy to enable `FLAG_SECURE` flag for the dialog window using [`SecureOn`](https://developer.android.com/reference/kotlin/androidx/compose/ui/window/SecureFlagPolicy#SecureOn).
