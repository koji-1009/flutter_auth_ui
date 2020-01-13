import 'dart:async';
import 'dart:math';

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/services.dart';

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

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

  static Future<bool> setAnonymous() async {
    final bool result = await _channel.invokeMethod("setAnonymous");
    return result;
  }

  static Future<bool> setEmail(
      {String url = "",
      String packageName = "",
      String minimumVersion = ""}) async {
    final bool result =
        await _channel.invokeMethod("setEmail", <String, String>{
      'ios_url': url,
      'ios_package_name': packageName,
      'ios_minimum_version': minimumVersion
    });
    return result;
  }

  static Future<bool> setPhone() async {
    final bool result = await _channel.invokeMethod("setPhone");
    return result;
  }

  static Future<bool> setApple() async {
    final bool result = await _channel.invokeMethod("setApple");
    return result;
  }

  static Future<bool> setGithub() async {
    final bool result = await _channel.invokeMethod("setGithub");
    return result;
  }

  static Future<bool> setMicrosoft() async {
    final bool result = await _channel.invokeMethod("setMicrosoft");
    return result;
  }

  static Future<bool> setYahoo() async {
    final bool result = await _channel.invokeMethod("setYahoo");
    return result;
  }

  static Future<bool> setGoogle() async {
    final bool result = await _channel.invokeMethod("setGoogle");
    return result;
  }

  static Future<bool> setFacebook() async {
    final bool result = await _channel.invokeMethod("setFacebook");
    return result;
  }

  static Future<bool> setTwitter() async {
    final bool result = await _channel.invokeMethod("setTwitter");
    return result;
  }

  static Future setTosAndPrivacyPolicy(
      String tosUrl, String privacyPolicyUrl) async {
    await _channel.invokeMethod("setTosAndPrivacyPolicy", <String, String>{
      "tosUrl": tosUrl,
      "privacyPolicyUrl": privacyPolicyUrl
    });
  }
}
