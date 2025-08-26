---
title: Hiding sensitive content from the screenshots
alias: hiding-sensitive-content-from-the-screenshots
id: MASTG-BEST-0015
platform: ios
---

Screenshots of sensitive content, as screenshots may be stored in locations accessible to other applications (such as the device's photo gallery, shared storage, or cloud backup services), which could lead to data leakage. On iOS, the only available API for preventing screenshots is [`isSecureTextEntry`](https://developer.apple.com/documentation/uikit/uitextinputtraits/issecuretextentry), which protects password text fields. There is no public API to secure other UI elements, such as those displaying credit card numbers or other confidential data.

However, it is possible to detect when a screenshot has been taken by observing the [`userDidTakeScreenshotNotification`](https://developer.apple.com/documentation/uikit/uiapplication/userdidtakescreenshotnotification).
