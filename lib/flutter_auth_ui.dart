import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AuthUiItem {
  /// set Anonymous provider.
  /// Note: Anonymous ui is not supported on iOS
  AuthAnonymous,

  /// set Email provider.
  ///
  /// If you want email link authentication on iOS , set following params your `Info.plist`.
  /// (see <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>)
  ///   - FirebaseAuthUiEmailHandleURL : String, set `ActionCodeSettings.url`
  ///   - FirebaseAuthUiEmailAndroidPackageName : String, set `actionCodeSettings.setAndroidPackageName` - packageName
  ///   - FirebaseAuthUiEmailAndroidMinimumVersion : String, set `actionCodeSettings.setAndroidPackageName` - minimumVersion
  AuthEmail,

  /// set PhoneNumber provider.
  AuthPhone,

  /// set Sign in with Apple provider.
  AuthApple,

  /// set Github provider.
  AuthGithub,

  /// set Microsoft provider.
  AuthMicrosoft,

  /// set Yahoo provider.
  AuthYahoo,

  /// set Google Sign-In provider.
  ///
  /// Google Sign-In needs extra configurations.
  /// See following guide.
  ///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#google>
  ///   - Android : <https://firebase.google.com/docs/auth/android/google-signin>
  AuthGoogle,

  /// set Facebook Login provider.
  ///
  /// Facebook login needs extra configurations.
  /// See following guide.
  ///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
  ///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
  AuthFacebook,

  /// set Twitter provider.
  ///
  /// Twitter login needs extra configurations.
  /// See following guide.
  ///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
  AuthTwitter
}

extension ExtendedAuthUiItem on AuthUiItem {
  String get providerName {
    switch (this) {
      case AuthUiItem.AuthAnonymous:
        return 'Anonymous';
      case AuthUiItem.AuthEmail:
        return 'Email';
      case AuthUiItem.AuthPhone:
        return 'Phone';
      case AuthUiItem.AuthApple:
        return 'Apple';
      case AuthUiItem.AuthGithub:
        return 'Github';
      case AuthUiItem.AuthMicrosoft:
        return 'Microsoft';
      case AuthUiItem.AuthYahoo:
        return 'Yahoo';
      case AuthUiItem.AuthGoogle:
        return 'Google';
      case AuthUiItem.AuthFacebook:
        return 'Facebook';
      case AuthUiItem.AuthTwitter:
        return 'Twitter';
      default:
        return '';
    }
  }
}

/// Terms of service(Tos) and Privacy Policy link.
class TosAndPrivacyPolicy {
  TosAndPrivacyPolicy({
    @required this.tosUrl,
    @required this.privacyPolicyUrl,
  });

  final String tosUrl;
  final String privacyPolicyUrl;
}

class AndroidOption {
  /// [enableSmartLock] enables SmartLock on Android.
  /// [requireName] enables require name option on Android.
  AndroidOption({
    this.enableSmartLock = true,
    this.requireName = true,
  });

  final bool enableSmartLock;
  final bool requireName;
}

class IosOption {
  /// [requireName] enables require name option on iOS.
  IosOption({
    this.requireName = true,
  });

  final bool requireName;
}

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  /// Start Firebase Auth UI process.
  ///
  /// Return `true` if login process is completed.
  static Future<bool> startUi({
    @required List<AuthUiItem> items,
    @required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    AndroidOption androidOption,
    IosOption iosOption,
  }) async {
    final providers = items.map((e) => e.providerName).join(',');
    final data = await _channel.invokeMethod('startUi', <String, dynamic>{
      'providers': providers,
      'tosUrl': tosAndPrivacyPolicy.tosUrl,
      'privacyPolicyUrl': tosAndPrivacyPolicy.privacyPolicyUrl,

      /// Android
      'enableSmartLockForAndroid': androidOption.enableSmartLock,
      'requireNameForAndroid': androidOption.requireName,

      /// iOS
      'requireNameForIos': iosOption.requireName,
    });
    if (data == null) return false;

    return true;
  }
}
