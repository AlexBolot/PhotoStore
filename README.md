# PhotoStore  ![Build Workflow Status](https://github.com/AlexBolot/PhotoStore/workflows/Build/badge.svg?branch=master)

A Gallery app with cloud backup of your photos

# Requirements 

## 1. Flutter
You can find the install process of the latest version [here](https://flutter.dev/docs/get-started/install)

Result of `flutter --version` on my machine :
```
Flutter 1.26.0-2.0.pre.275 • channel master • https://github.com/flutter/flutter.git
Framework • revision d9044a8a61 (il y a 2 semaines) • 2021-01-09 04:04:04 -0500
Engine • revision caf6a8191f
Tools • Dart 2.12.0 (build 2.12.0-204.0.dev)
```
## 2. Android SDK / NDK

You must setup these directly in your AndroidStudio in `Tools > SDK Manager`
Find official documentation [here](https://developer.android.com/studio/projects/install-ndk)

```
minSdkVersion : 23 (Android 6)
targetSdkVersion : 29 (Android 10)
NDK version : 21.3.6528147
```
This is setup in [android/app/build.gradle](https://github.com/AlexBolot/PhotoStore/blob/master/android/app/build.gradle)

## 3. Tools

### IDE
There are various available IDEs for Flutter development

The list is available [here](https://flutter.dev/docs/get-started/editor)

### Plugins 
Add the Flutter/Dart plugin available for your chosen IDE 
