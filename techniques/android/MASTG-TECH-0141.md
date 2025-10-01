---
title: Inspecting the merged Manifest.xml
platform: android
---

The AndroidManifest.xml file is a crucial component of any Android application. During the build process, the Android build tools merge multiple manifest files from different sources (main app, flavors and libraries) into a single merged manifest file. This merged manifest file is what gets packaged into the final APK or AAB.

Inspecting the merged manifest file can help you understand the final configuration of the app, including permissions, components (i.e, Activities, Services, Providers), and other settings. It can also help you identify the inherited permissions and components from third-party libraries.

To inspect the merged manifest file, you can use Android Studio or command-line tools. Here are two methods:

### Method 1: Using Android Studio

1. Open your project in Android Studio.
2. In the Project view, navigate to `app/src/main/AndroidManifest.xml`.
3. Click on the "Merged Manifest" tab at the bottom of the editor window. This will show you the merged manifest file, along with a tree view of the sources that contributed to each element.
4. You can click on any element such as a permission or an Activity in the merged manifest to see its source in the tree view.

### Method 2: Using Command-Line Tools

> Limitation:
> With this method you cannot track the source of each element in the merged manifest file. For that, you would need to use Android Studio as described in Method 1.

1. You can manually generate the merged manifest file of the desired build variant using a command like `./gradlew app:processDebugManifest`. Replace `Debug` with the desired build variant if necessary.
2. After running the command, you can find the merged manifest file in the `app/build/intermediates/merged_manifests/debug/AndroidManifest.xml` directory. Again, replace `debug` with the appropriate build variant if needed.
3. Open the `AndroidManifest.xml` file in a text editor to inspect its contents.
