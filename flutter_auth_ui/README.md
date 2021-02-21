# flutter_auth_ui

Unofficial firebaseui package for flutter. This library aims to provide support for Android, iOS and the web. Login with Email, Phone, Google account and etc.

## Getting Started

This plugin is wrapped Android/iOS's native plugin.

Check documents and setup your firebase project.

* iOS : <https://firebase.google.com/docs/auth/ios/firebaseui>
* Android : <https://firebase.google.com/docs/auth/android/firebaseui>

## How to use

```dart
// Set provider
final providers = [
  AuthUiItem.AuthAnonymous,
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
  ),
  emailAuthOption: EmailAuthOption(
    requireDisplayName: true, // default true
    enableMailLink: false, // default false
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

### iOS

- iOS 12 or higher

## Tips

### To change the title of AppBar on Android

Add the string value as `app_name` or `fui_default_toolbar_title` to your app's `strings.xml` file.
Sample code is [here](https://github.com/koji-1009/flutter_auth_ui/blob/main/flutter_auth_ui/example/android/app/src/main/res/values/strings.xml).

Behavior depends on [this](https://github.com/firebase/FirebaseUI-Android/blob/master/auth/src/main/AndroidManifest.xml).
