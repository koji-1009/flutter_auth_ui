import 'dart:async';

import 'package:flutter/services.dart';

abstract class AuthUiItem {
  String providerName();
}

/// set Anonymous provider.
class AuthAnonymous implements AuthUiItem {
  @override
  String providerName() {
    return 'Anonymous';
  }
}

/// set Email provider.
///
/// If you want iOS support, set following params your `Info.plist`.
/// (see <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>)
///   - FirebaseAuthUiEmailHandleURL : String, set `ActionCodeSettings.url`
///   - FirebaseAuthUiEmailAndroidPackageName : String, set `actionCodeSettings.setAndroidPackageName` - packageName
///   - FirebaseAuthUiEmailAndroidMinimumVersion : Int, set `actionCodeSettings.setAndroidPackageName` - minimumVersion
class AuthEmail implements AuthUiItem {
  @override
  String providerName() {
    return 'Email';
  }
}

/// set PhoneNumber provider.
class AuthPhone implements AuthUiItem {
  @override
  String providerName() {
    return 'Phone';
  }
}

/// set Sign in with Apple provider.
class AuthApple implements AuthUiItem {
  @override
  String providerName() {
    return 'Apple';
  }
}

/// set Github provider.
class AuthGithub implements AuthUiItem {
  @override
  String providerName() {
    return 'Github';
  }
}

/// set Microsoft provider.
class AuthMicrosoft implements AuthUiItem {
  @override
  String providerName() {
    return 'Microsoft';
  }
}

/// set Yahoo provider.
class AuthYahoo implements AuthUiItem {
  @override
  String providerName() {
    return 'Yahoo';
  }
}

/// set Google Sign-In provider.
///
/// Google Sign-In needs extra configurations.
/// See following guide.
///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#google>
///   - Android : <https://firebase.google.com/docs/auth/android/google-signin>
class AuthGoogle implements AuthUiItem {
  @override
  String providerName() {
    return 'Google';
  }
}

/// set Facebook Login provider.
///
/// Facebook login needs extra configurations.
/// See following guide.
///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
class AuthFacebook implements AuthUiItem {
  @override
  String providerName() {
    return 'Facebook';
  }
}

/// set Twitter provider.
///
/// Twitter login needs extra configurations.
/// See following guide.
///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
class AuthTwitter implements AuthUiItem {
  @override
  String providerName() {
    return 'Twitter';
  }
}

/// Terms of service(Tos) and Privacy Policy link.
class TosAndPrivacyPolicy {
  TosAndPrivacyPolicy(this.tosUrl, this.privacyPolicyUrl);

  String tosUrl;
  String privacyPolicyUrl;
}

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  /// Start Firebase Auth UI process.
  ///
  /// Return `true` if login process is completed.
  static Future<bool> startUi(
      List<AuthUiItem> items, TosAndPrivacyPolicy tosAndPrivacyPolicy) async {
    final providers = items.map((e) => e.providerName()).join(',');
    final data = await _channel.invokeMapMethod('startUi', <String, String>{
      'providers': providers,
      'tosUrl': tosAndPrivacyPolicy.tosUrl,
      'privacyPolicyUrl': tosAndPrivacyPolicy.privacyPolicyUrl
    });
    if (data == null) return false;

    return true;
  }
}
