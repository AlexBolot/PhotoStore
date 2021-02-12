# PhotoStore  ![Build Workflow Status](https://github.com/AlexBolot/PhotoStore/workflows/Build/badge.svg?branch=master)

A Gallery app with cloud backup of your photos

# Preview

|  Application Start  |  b  |
| --- | --- |
|<img src="assets/app-startup.gif" height="400" alt="n"> |b |

# Requirements

## 1. Flutter

You can find the install process of the latest version [here](https://flutter.dev/docs/get-started/install)

Result of `flutter --version` on my machine :

```
Flutter 1.22.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 9b2d32b605 (il y a 3 semaines) • 2021-01-22 14:36:39 -0800
Engine • revision 2f0af37152
Tools • Dart 2.10.5
```
## 2. Android SDK / NDK

You must setup these directly in your AndroidStudio in `Tools > SDK Manager`
Find official documentation [here](https://developer.android.com/studio/projects/install-ndk)

```
minSdkVersion : 23 (Android 6)
targetSdkVersion : 29 (Android 10)
NDK version : 22.0.7026061
```
This is setup in [android/app/build.gradle](https://github.com/AlexBolot/PhotoStore/blob/master/android/app/build.gradle)

## 3. Tools

### IDE

There are various available IDEs for Flutter development

The list is available [here](https://flutter.dev/docs/get-started/editor)

### Plugins

Add the Flutter/Dart plugin available for your chosen IDE
