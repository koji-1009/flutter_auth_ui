# flutter_auth_ui

Unofficial firebaseui package for flutter. This library aims to provide support for Android, iOS and the web. Login with Email, Phone, Google account and etc.

## Getting Started

This plugin is wrapped Android/iOS/Web native plugin.

Check documents and setup your firebase project.

* iOS : <https://firebase.google.com/docs/auth/ios/firebaseui>
* Android : <https://firebase.google.com/docs/auth/android/firebaseui>
* Web: <https://firebase.google.com/docs/auth/web/firebaseui>

## How to use

```dart
// Set provider
final providers = [
  AuthUiProvider.anonymous,
  AuthUiProvider.email,
  AuthUiProvider.phone,
  AuthUiProvider.apple,
  AuthUiProvider.facebook,
  AuthUiProvider.github,
  AuthUiProvider.google,
  AuthUiProvider.microsoft,
  AuthUiProvider.yahoo,
  AuthUiProvider.twitter,
];

final result = await FlutterAuthUi.startUi(
  items: providers,
  tosAndPrivacyPolicy: const TosAndPrivacyPolicy(
    tosUrl: "https://www.google.com",
    privacyPolicyUrl: "https://www.google.com",
  ),
  androidOption: const AndroidOption(
    enableSmartLock: false, // default true
    showLogo: true, // default false
    overrideTheme: true, // default false
  ),
  emailAuthOption: const EmailAuthOption(
    requireDisplayName: true, // default true
    enableMailLink: false, // default false
    handleURL: '',
    androidPackageName: '',
    androidMinimumVersion: '',
  ),
);
```

## Requirements

- flutter 3.13.0 or higher
- [firebase_auth](https://pub.dev/packages/firebase_auth) 5.0.0 or higher

### Android

- minSdkVersion 21
- compileSdkVersion 34

### iOS

- iOS 13 or higher

## Link

* [Introduction of flutter_auth_ui.](https://koji-1009.medium.com/introduction-of-flutter-auth-ui-ad5895646f3c)

## Tips

### EmailLink

Note: In order to implement EmailLink, you will need to prepare in advance; check the [firebase documentation](https://firebase.google.com/docs/auth) first.

* [Android](https://firebase.google.com/docs/auth/android/email-link-auth)
* [iOS](https://firebase.google.com/docs/auth/ios/email-link-auth)
* [Web](https://firebase.google.com/docs/auth/web/email-link-auth)

Let's check the code sample for firebase auth.

* [Android](https://github.com/firebase/snippets-android/blob/8184cba2c40842a180f91dcfb4a216e721cc6ae6/auth/app/src/main/java/com/google/firebase/quickstart/auth/MainActivity.java#L340)
* [iOS](https://github.com/firebase/quickstart-ios/blob/70e424c8b3740597d17ad7f25c5f98918a567bc0/authentication/LegacyAuthQuickstart/AuthenticationExampleSwift/PasswordlessViewController.swift#L66)

#### Android

To handle dynamic link, add `FlutterAuthUiPlugin.catchEmailLink` to `onCreate` and `onNewIntent`.
(If you don't use EmailLink, then you don't need to add it.)

```java
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dr1009.app.flutter_auth_ui.FlutterAuthUiPlugin;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, getIntent());
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, intent);
    }
}
```

### Localizing

#### Android

Supported without any special settings.

#### iOS

Check [Localizing for iOS: Updating the iOS app bundle](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).

#### Web

Check [Installation - Option 1: CDN - Localized Widget](https://github.com/firebase/firebaseui-web#localized-widget).

### To change the title of AppBar on Android

Add the string value as `app_name` or `fui_default_toolbar_title` to your app's `strings.xml` file.
Sample code is [strings.xml](https://github.com/koji-1009/flutter_auth_ui/blob/main/flutter_auth_ui/example/android/app/src/main/res/values/strings.xml).

Behavior depends on [FirebaseUI-Android](https://github.com/firebase/FirebaseUI-Android/blob/master/auth/src/main/AndroidManifest.xml).

### Show Logo (Android)

1. Add your logo resource file to `android/app/src/main/res/drawable/flutter_auth_ui_logo.xml` or `android/app/src/main/res/drawable-{m~xxxhdpi}/flutter_auth_ui_logo.png`
2. Enable `AndroidOption.showLogo`

### Change Appbar and link color (Android)

1. Add `flutter_auth_ui_style` style to your `android/app/src/main/res/values/style.xml`
  - [example](https://github.com/koji-1009/flutter_auth_ui/blob/main/example/android/app/src/main/res/values/styles.xml)
2. Enable `AndroidOption.overrideTheme`
