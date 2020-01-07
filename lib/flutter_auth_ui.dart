import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future startUi() async {
    await _channel.invokeMethod("startUi");
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
      "tos_url": tosUrl,
      "privacy_policy_url": privacyPolicyUrl
    });
  }
}
