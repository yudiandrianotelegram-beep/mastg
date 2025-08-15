---
title: Hiding Sensitive Content from Screenshots Before Backgrounding
alias: hiding-sensitive-content-from-screenshots-before-backgrounding
id: MASTG-BEST-0016
platform: ios
---

Ensure that the app hides sensitive content, such as credit card details and passcodes, before entering the background state. The system takes a screenshot, also known as a "snapshot" on iOS, of the current app's view and stores it on disk. An attacker may be able to extract this screenshot.

Depending on the user interface, there are several ways to overlay the screen content:

## SwiftUI Interface

### iOS 17 and Later: Using `.backgroundTask(.snapshot)`

Starting with iOS 17, SwiftUI provides [`backgroundTask(.snapshot)`](https://developer.apple.com/documentation/swiftui/backgroundtask/snapshot), which allows you to [prepare your app for a system snapshot](https://developer.apple.com/documentation/swiftui/backgroundtask#Preparing-for-a-snapshot) (such as when the app is backgrounded). This is an ideal place to hide or mask sensitive content before the system takes a screenshot.

Example:

```swift
@State private var showPrivacyScreen = false
@Environment(\.scenePhase) private var scenePhase

var body: some Scene {
    WindowGroup {
        ZStack {
            ContentView()
            if showPrivacyScreen {
                Image("overlayImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
    }
    .backgroundTask(.snapshot) {
        // This code runs right before the system takes a snapshot
        showPrivacyScreen = true
    }
    .onChange(of: scenePhase) { newPhase in
        if newPhase == .active {
            showPrivacyScreen = false
        }
    }
}
```

### Before iOS 17: Using `scenePhase` and `.onChange` in SwiftUI

For earlier iOS versions, you can use the [`scenePhase`](https://developer.apple.com/documentation/swiftui/scenephase) environment value and the [`onChange(of:initial:_:)`](https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:)-8wgw9) modifier to detect when your app moves to the background or becomes inactive. You can then overlay or mask sensitive content at those times to protect it from being captured in system snapshots.

Example:

```swift
@Environment(\.scenePhase) private var scenePhase
@State private var showPrivacyScreen = false

var body: some Scene {
    WindowGroup {
        ZStack {
            ContentView()
            if showPrivacyScreen {
                Image("overlayImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
    }
    .onChange(of: scenePhase) { newPhase in
        switch newPhase {
        case .background, .inactive:
            showPrivacyScreen = true
        case .active:
            showPrivacyScreen = false
        default:
            break
        }
    }
}
```

## UIKit Interface

In UIKit-based apps, you can protect sensitive content from being captured in system snapshots by overlaying a privacy view when your app is about to move to the background or become inactive. This can be achieved using either the Scene Delegate or App Delegate, depending on your app's lifecycle setup.

### Using Scene Delegate

If your app uses a Scene Delegate (introduced in iOS 13), you can add or remove a privacy overlay in response to scene lifecycle events. When the app is about to become inactive or move to the background, add the overlay. When it becomes active again, remove it.

Relevant APIs:

- [`UIScene`](https://developer.apple.com/documentation/uikit/uiscene)
- [`sceneWillResignActive(_:)`](https://developer.apple.com/documentation/uikit/uiscenedelegate/scenewillresignactive(_:))
- [`sceneDidBecomeActive(_:)`](https://developer.apple.com/documentation/uikit/uiscenedelegate/scenedidbecomeactive(_:))
- [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview)

```swift
func sceneDidBecomeActive(_ scene: UIScene) {
    removePrivacyView()
}

func sceneWillResignActive(_ scene: UIScene) {
    addPrivacyView()
}

var privacyImageView: UIImageView?

private func addPrivacyView() {
    guard let window = self.window else { return }

    let imageView = UIImageView(image: UIImage(named: "overlayImage"))
    imageView.contentMode = .scaleAspectFill
    imageView.frame = window.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    self.privacyImageView = imageView
    window.addSubview(imageView)
}

private func removePrivacyView() {
    privacyImageView?.removeFromSuperview()
    privacyImageView = nil
}
```

### Using App Delegate

If your app uses the traditional App Delegate lifecycle, you can achieve the same effect by responding to app lifecycle events. Add the privacy overlay when the app enters the background, and remove it when the app returns to the foreground.

Relevant APIs:

- [`UIApplication`](https://developer.apple.com/documentation/uikit/uiapplication)
- [`applicationDidEnterBackground(_:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/applicationdidenterbackground(_:))
- [`UIApplication.willEnterForegroundNotification`](https://developer.apple.com/documentation/uikit/uiapplication/willenterforegroundnotification) (preferred over the deprecated `applicationWillEnterForeground(_:)` in iOS 26)

```swift
private var privacyImageView: UIImageView?

func applicationDidEnterBackground(_ application: UIApplication) {
    addPrivacyView()
}

func startObservingForegroundNotification() {
    NotificationCenter.default.addObserver(
        forName: UIApplication.willEnterForegroundNotification,
        object: nil,
        queue: .main
    ) { [weak self] _ in
        self?.removePrivacyView()
    }
}
```

Refer to the "[Testing Data Storage](../Document/0x06d-Testing-Data-Storage.md "Testing Data Storage")" chapter for more information and best practices on securely storing sensitive data.
