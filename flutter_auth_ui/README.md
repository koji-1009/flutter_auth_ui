# flutter_auth_ui

A Flutter plugin for using the Firebase Auth UI with Dart in Flutter apps.
(not official plugin.)

## Getting Started

This plugin is wrapped Android/iOS's native plugin.

Check documents and setup your firebase project.

* iOS : <https://firebase.google.com/docs/auth/ios/firebaseui>
* Android : <https://firebase.google.com/docs/auth/android/firebaseui>

## How to use

```
// Set provider
final providers = [
  AuthUiItem.AuthEmail,
  AuthUiItem.AuthPhone,
  AuthUiItem.AuthApple,
  AuthUiItem.AuthFacebook,
  AuthUiItem.AuthGithub,
  AuthUiItem.AuthGoogle,
  AuthUiItem.AuthMicrosoft,
  AuthUiItem.AuthYahoo,
  AuthUiItem.AuthTwitter,
];

final result = await FlutterAuthUi.startUi(
  items: providers,
  tosAndPrivacyPolicy: TosAndPrivacyPolicy(
    tosUrl: "https://www.google.com",
    privacyPolicyUrl: "https://www.google.com",
  ),
  androidOption: AndroidOption(
    enableSmartLock: false, // default true
    enableMailLink: false, // default false
    requireName: true, // default true
  ),
  iosOption: IosOption(
    enableMailLink: false, // default false
    requireName: true, // default true
  ),
  // If you need EmailLink mode, please set EmailAuthOption
  emailAuthOption: EmailAuthOption(
    handleURL: '',
    androidPackageName: '',
    androidMinimumVersion: '',
  ),
);
```

## Requirements

- flutter 1.22.0 or higher
- [firebase_auth](https://pub.dev/packages/firebase_auth) 0.20.1

### Android

- minSdkVersion 21
- compileSdkVersion 30
- Kotlin 1.4.30

### iOS

- iOS 12 or higher

## Tips

### To change the title of AppBar on Android

Add the string value as `app_name` or `fui_default_toolbar_title` to your app's `strings.xml` file.
Sample code is [here](https://github.com/koji-1009/flutter_auth_ui/blob/change_appbar_title/example/android/app/src/main/res/values/strings.xml).

Behavior depends on [this](https://github.com/firebase/FirebaseUI-Android/blob/master/auth/src/main/AndroidManifest.xml).
