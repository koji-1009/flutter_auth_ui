import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Supported providers
enum AuthUiProvider {
  /// set Anonymous provider.
  anonymous,

  /// set Email provider.
  ///
  /// If you want email link authentication, set enableEmailLink at option.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>
  ///   - Android: <https://firebase.google.com/docs/auth/android/firebaseui#email_link_authentication>
  ///   - Web: <https://firebase.google.com/docs/auth/web/firebaseui#email_link_authentication>
  email,

  /// set PhoneNumber provider.
  phone,

  /// set Sign in with Apple provider.
  apple,

  /// set Github provider.
  github,

  /// set Microsoft provider.
  microsoft,

  /// set Yahoo provider.
  yahoo,

  /// set Google Sign-In provider.
  ///
  /// Google Sign-In needs extra configurations.
  /// See following guide.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#google>
  google,

  /// set Facebook Login provider.
  ///
  /// Facebook login needs extra configurations.
  /// See following guide.
  ///   - iOS: <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
  ///   - Android: <https://firebase.google.com/docs/auth/android/firebaseui#facebook>
  facebook,

  /// set Twitter provider.
  twitter
}

extension _AuthUiProviderExt on AuthUiProvider {
  String get providerName {
    switch (this) {
      case AuthUiProvider.anonymous:
        return 'Anonymous';
      case AuthUiProvider.email:
        return 'Email';
      case AuthUiProvider.phone:
        return 'Phone';
      case AuthUiProvider.apple:
        return 'Apple';
      case AuthUiProvider.github:
        return 'GitHub';
      case AuthUiProvider.microsoft:
        return 'Microsoft';
      case AuthUiProvider.yahoo:
        return 'Yahoo';
      case AuthUiProvider.google:
        return 'Google';
      case AuthUiProvider.facebook:
        return 'Facebook';
      case AuthUiProvider.twitter:
        return 'Twitter';
    }
  }
}

/// Terms of service(Tos) and Privacy Policy link.
@immutable
class TosAndPrivacyPolicy {
  /// Set Terms of service url and Privacy Policy url.
  const TosAndPrivacyPolicy({
    required this.tosUrl,
    required this.privacyPolicyUrl,
  });

  /// Terms of service url.
  final String tosUrl;

  /// Privacy Policy url.
  final String privacyPolicyUrl;
}

/// for FirebaseUI-Android
@immutable
class AndroidOption {
  /// [enableSmartLock] enables SmartLock on Android.
  /// [showLogo] enables logo display on Android.
  /// [overrideTheme] enables own theme on Android.
  const AndroidOption({
    this.enableSmartLock = true,
    this.showLogo = false,
    this.overrideTheme = false,
  });

  /// enables SmartLock on Android.
  final bool enableSmartLock;

  /// enables logo display on Android.
  final bool showLogo;

  /// enables own theme on Android.
  final bool overrideTheme;
}

/// for firebaseui-web
@immutable
class WebAuthOption {
  /// [pageTitle] is title displayed on the auth page
  /// [authenticationPath] is path on the auth page
  const WebAuthOption({
    this.pageTitle,
    this.authenticationPath = 'authentication',
  });

  /// title displayed on the auth page, if null, set window's title
  final String? pageTitle;

  /// path of the auth page, default is 'authentication'
  final String authenticationPath;
}

/// Email sign-in config
@immutable
class EmailAuthOption {
  /// [requireDisplayName] enables the option to require the display name.
  /// [enableMailLink] enables email link sign-in
  /// instead of password based sign-in.
  /// [handleURL] represents the state/continue URL
  /// in the form of a universal link.
  /// [androidPackageName] the Android package name, if available.
  /// [androidMinimumVersion] the minimum Android version supported,
  /// if available.
  const EmailAuthOption({
    this.requireDisplayName = true,
    this.enableMailLink = false,
    this.handleURL = '',
    this.androidPackageName = '',
    this.androidMinimumVersion = '',
  });

  /// enables the option to require the display name.
  final bool requireDisplayName;

  /// enables email link sign-in instead of password based sign-in.
  final bool enableMailLink;

  /// represents the state/continue URL in the form of a universal link.
  final String handleURL;

  /// the Android package name, if available.
  final String androidPackageName;

  /// the minimum Android version supported, if available.
  final String androidMinimumVersion;
}

/// Call FirebaseUI-Android/iOS/Web using MethodChannel.
class FlutterAuthUi {
  static const MethodChannel _channel = MethodChannel('flutter_auth_ui');

  /// Start Firebase Auth UI process.
  ///
  /// Return `true` if login process is completed.
  static Future<bool> startUi({
    required List<AuthUiProvider> items,
    required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    bool autoUpgradeAnonymousUsers = false,
    AndroidOption androidOption = const AndroidOption(),
    WebAuthOption webAuthOption = const WebAuthOption(),
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
          'showLogoAndroid': androidOption.showLogo,
          'overrideThemeAndroid': androidOption.overrideTheme,

          /// Web
          'webPageTitle': webAuthOption.pageTitle,
          'webAuthenticationPath': webAuthOption.authenticationPath,

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
    } on Exception catch (e) {
      debugPrint('flutter_auth_ui: error => $e');
      return false;
    }
  }

  static Future<void> signOut() {
    return _channel.invokeMethod<void>('signOut');
  }
}
