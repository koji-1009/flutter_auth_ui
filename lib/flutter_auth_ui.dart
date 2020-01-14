import 'dart:async';

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/services.dart';

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  /// Start Firebase Auth UI process.
  ///
  /// Return `PlatformUser` if login process is completed.
  static Future<PlatformUser> startUi() async {
    final data = await _channel.invokeMapMethod<String, dynamic>("startUi");
    if (data == null) return null;

    final List<PlatformUserInfo> providerData = new List();
    data["providerData"].forEach((element) => providerData.add(PlatformUserInfo(
        providerId: element["providerId"],
        uid: element["uid"],
        displayName: element["displayName"],
        photoUrl: element["photoUrl"],
        email: element["email"],
        phoneNumber: element["phoneNumber"])));

    final user = PlatformUser(
        providerId: data["providerId"],
        uid: data["uid"],
        displayName: data["displayName"],
        photoUrl: data["photoUrl"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        creationTimestamp: data["creationTimestamp"],
        lastSignInTimestamp: data["lastSignInTimestamp"],
        isAnonymous: data["isAnonymous"],
        isEmailVerified: data["isEmailVerified"],
        providerData: providerData);

    return user;
  }

  /// set Anonymous provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setAnonymous() async {
    final bool result = await _channel.invokeMethod("setAnonymous");
    return result;
  }

  /// set Email provider.
  ///
  /// If you want iOS support, set following params your `Info.plist`.
  /// (see <https://firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication>)
  ///   - FirebaseAuthUiEmailHandleURL : String, set `ActionCodeSettings.url`
  ///   - FirebaseAuthUiEmailAndroidPackageName : String, set `actionCodeSettings.setAndroidPackageName` - packageName
  ///   - FirebaseAuthUiEmailAndroidMinimumVersion : Int, set `actionCodeSettings.setAndroidPackageName` - minimumVersion
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setEmail() async {
    final bool result = await _channel.invokeMethod("setEmail");
    return result;
  }

  /// set PhoneNumber provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setPhone() async {
    final bool result = await _channel.invokeMethod("setPhone");
    return result;
  }

  /// set Sign in with Apple provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setApple() async {
    final bool result = await _channel.invokeMethod("setApple");
    return result;
  }

  /// set Github provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setGithub() async {
    final bool result = await _channel.invokeMethod("setGithub");
    return result;
  }

  /// set Microsoft provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setMicrosoft() async {
    final bool result = await _channel.invokeMethod("setMicrosoft");
    return result;
  }

  /// set Yahoo provider.
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setYahoo() async {
    final bool result = await _channel.invokeMethod("setYahoo");
    return result;
  }

  /// set Google Sign-In provider.
  ///
  /// Google Sign-In needs extra configurations.
  /// See following guide.
  ///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#google>
  ///   - Android : <https://firebase.google.com/docs/auth/android/google-signin>
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setGoogle() async {
    final bool result = await _channel.invokeMethod("setGoogle");
    return result;
  }

  /// set Facebook Login provider.
  ///
  /// Facebook login needs extra configurations.
  /// See following guide.
  ///   - iOS : <https://firebase.google.com/docs/auth/ios/firebaseui#facebook>
  ///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setFacebook() async {
    final bool result = await _channel.invokeMethod("setFacebook");
    return result;
  }

  /// set Twitter provider.
  ///
  /// Twitter login needs extra configurations.
  /// See following guide.
  ///   - Android : <https://firebase.google.com/docs/auth/android/firebaseui#before_you_begin>
  ///
  /// Return 'true' if configuration is successful.
  static Future<bool> setTwitter() async {
    final bool result = await _channel.invokeMethod("setTwitter");
    return result;
  }

  /// set Terms of service(Tos) and Privacy Policy link.
  ///
  /// Return 'true' if configuration is successful.
  static Future setTosAndPrivacyPolicy(
      String tosUrl, String privacyPolicyUrl) async {
    await _channel.invokeMethod("setTosAndPrivacyPolicy", <String, String>{
      "tosUrl": tosUrl,
      "privacyPolicyUrl": privacyPolicyUrl
    });
  }
}
