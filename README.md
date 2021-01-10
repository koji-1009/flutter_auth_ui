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
  AuthUiItem.AuthApple,
  AuthUiItem.AuthGithub,
  AuthUiItem.AuthGoogle,
  AuthUiItem.AuthMicrosoft,
  AuthUiItem.AuthYahoo,
];
final tosAndPrivacyPolicy = TosAndPrivacyPolicy(
  tosUrl: Terms of Service URL,
  privacyPolicyUrl: Privacy Policy URL,
);

final result = await FlutterAuthUi.startUi(
  items: providers,
  tosAndPrivacyPolicy: tosAndPrivacyPolicy,
  enableSmartLockForAndroid: (option) true(default)/false,
);
```
### Email link authentication

If you want to enable email link authentication on iOS, check `AuthUiItem.AuthEmail' doc.
