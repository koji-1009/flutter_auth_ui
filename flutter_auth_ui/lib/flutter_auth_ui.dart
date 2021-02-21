import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AuthUiItem {
  /// set Anonymous provider.
  AuthAnonymous,

  /// set Email provider.
  ///
  /// If you want email link authentication, set enableEmailLink at option.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>
  ///   - Android: <https://firebase.google.com/docs/auth/android/firebaseui#email_link_authentication>
  ///   - Web: <https://firebase.google.com/docs/auth/web/firebaseui#email_link_authentication>
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
  AuthGoogle,

  /// set Facebook Login provider.
  ///
  /// Facebook login needs extra configurations.
  /// See following guide.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
  ///   - Android: <https://firebase.google.com/docs/auth/android/firebaseui#facebook>
  AuthFacebook,

  /// set Twitter provider.
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
  const AndroidOption({
    this.enableSmartLock = true,
  });

  final bool enableSmartLock;
}

class EmailAuthOption {
  /// [requireDisplayName] enables the option to require the display name.
  /// [enableMailLink] enables email link signin instead of password based signin.
  /// [handleURL] represents the state/continue URL in the form of a universal link.
  /// [androidPackageName] the Android package name, if available.
  /// [androidMinimumVersion] the minimum Android version supported, if available.
  const EmailAuthOption({
    this.requireDisplayName = true,
    this.enableMailLink = false,
    this.handleURL = '',
    this.androidPackageName = '',
    this.androidMinimumVersion = '',
  });

  final bool requireDisplayName;
  final bool enableMailLink;
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
    bool autoUpgradeAnonymousUsers = false,
    AndroidOption androidOption = const AndroidOption(),
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

          /// anonymous
          'autoUpgradeAnonymousUsers': autoUpgradeAnonymousUsers,

          /// Android
          'enableSmartLockForAndroid': androidOption.enableSmartLock,

          /// EmailLink
          'emailLinkRequireDisplayName': emailAuthOption.requireDisplayName,
          'emailLinkEnableEmailLink': emailAuthOption.enableMailLink,
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
