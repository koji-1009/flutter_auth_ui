import 'package:flutter/foundation.dart';

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
  twitter,
  ;

  String get providerName => switch (this) {
        AuthUiProvider.anonymous => 'Anonymous',
        AuthUiProvider.email => 'Email',
        AuthUiProvider.phone => 'Phone',
        AuthUiProvider.apple => 'Apple',
        AuthUiProvider.github => 'GitHub',
        AuthUiProvider.microsoft => 'Microsoft',
        AuthUiProvider.yahoo => 'Yahoo',
        AuthUiProvider.google => 'Google',
        AuthUiProvider.facebook => 'Facebook',
        AuthUiProvider.twitter => 'Twitter'
      };
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
    this.backgroundColor = 'white',
  });

  /// title displayed on the auth page, if null, set window's title
  final String? pageTitle;

  /// color of the FirebaseUI page background, default is white
  /// see: [https://developer.mozilla.org/en-US/docs/Web/CSS/background-color]
  final String backgroundColor;
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
