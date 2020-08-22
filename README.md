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

final tosAndPrivacyPolicy = TosAndPrivacyPolicy(Terms of Service URL, Privacy Policy URL);
final isSuccess = await FlutterAuthUi.startUi(providers, tosAndPrivacyPolicy);
```
### Email link authentication

If you want to enable email link authentication on iOS, check `AuthUiItem.AuthEmail' doc.
