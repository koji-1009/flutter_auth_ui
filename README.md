# flutter_auth_ui

A Flutter plugin for using the Firebase Auth UI with Dart in Flutter apps.
(not official plugin.)

## Status

- Android
  - support
- iOS
  - support
- web
  - partial support

## Configuration

### Android

Open `[flutter_project]/android/build.gradle` and update version:

```
buildscript {
  ...
  ext.kotlin_version = '1.4.30'
  ...
  dependencies {
    ...
    classpath 'com.android.tools.build:gradle:4.1.2'
    ...
  }
  ...
}
```

Open `[flutter_project]/android/app/build.gradle` and update minSdkVersion:

```
android {
  ...
  defaultConfig {
    ...
    minSdkVersion 21
    ...
  }
  ...
}
```
