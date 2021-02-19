import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AuthUiItem {
  /// set Anonymous provider.
  AuthAnonymous,

  /// set Email provider.
  ///
  /// If you want email link authentication, set enableEmailLink at option.
  /// (see <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>)
  /// (see <https://firebase.google.com/docs/auth/android/firebaseui#email_link_authentication>)
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
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#google>
  ///   - Android: <https://firebase.google.com/docs/auth/android/google-signin>
  AuthGoogle,

  /// set Facebook Login provider.
  ///
  /// Facebook login needs extra configurations.
  /// See following guide.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
  ///   - Android: <https://firebase.google.com/docs/auth/android/facebook-login>
  AuthFacebook,

  /// set Twitter provider.
  ///
  /// Twitter login needs extra configurations.
  /// See following guide.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#twittern>
  ///   - Android: <https://firebase.google.com/docs/auth/android/twitter-login>
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
  /// [enableMailLink] enables email link sign in instead of password based sign in on Android.
  /// [requireName] enables require name option on Android.
  const AndroidOption({
    this.enableSmartLock = true,
    this.enableMailLink = false,
    this.requireName = true,
  });

  final bool enableMailLink;
  final bool enableSmartLock;
  final bool requireName;
}

class IosOption {
  /// [enableMailLink] enables email link sign in instead of password based sign in on iOS.
  /// [requireName] enables require name option on iOS.
  const IosOption({
    this.enableMailLink = false,
    this.requireName = true,
  });

  final bool enableMailLink;
  final bool requireName;
}

class EmailAuthOption {
  /// [handleURL] represents the state/Continue URL in the form of a universal link.
  /// [androidPackageName] the Android package name, if available.
  /// [androidMinimumVersion] the minimum Android version supported, if available.
  const EmailAuthOption({
    this.handleURL = '',
    this.androidPackageName = '',
    this.androidMinimumVersion = '',
  });

  final String handleURL;
  final String androidPackageName;
  final String androidMinimumVersion;
}

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  /// Start Firebase Auth UI process.
  ///
  /// Return `true` if login process is completed.
  static Future<bool> startUi({
    @required List<AuthUiItem> items,
    @required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    AndroidOption androidOption = const AndroidOption(),
    IosOption iosOption = const IosOption(),
    EmailAuthOption emailAuthOption = const EmailAuthOption(),
  }) async {
    final providers = items.map((e) => e.providerName).join(',');
    try {
      final data = await _channel.invokeMethod<bool>(
        'startUi',
        <String, dynamic>{
          'providers': providers,
          'tosUrl': tosAndPrivacyPolicy.tosUrl,
          'privacyPolicyUrl': tosAndPrivacyPolicy.privacyPolicyUrl,

          /// Android
          'enableSmartLockForAndroid': androidOption.enableSmartLock,
          'enableEmailLinkForAndroid': androidOption.enableMailLink,
          'requireNameForAndroid': androidOption.requireName,

          /// iOS
          'enableEmailLinkForIos': iosOption.enableMailLink,
          'requireNameForIos': iosOption.requireName,

          /// EmailLink
          'emailLinkHandleURL': emailAuthOption.handleURL,
          'emailLinkAndroidPackageName': emailAuthOption.androidPackageName,
          'emailLinkAndroidMinimumVersion':
              emailAuthOption.androidMinimumVersion,
        },
      );
      if (data == null) return false;

      return data;
    } catch (e) {
      print('flutter_auth_ui: error => $e');
      return false;
    }
  }
}
