import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAuthUi {
  static const MethodChannel _channel = const MethodChannel('flutter_auth_ui');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future get startUi async {
    await _channel.invokeMethod("startUi");
  }

  static Future<bool> get setAnonymous async {
    final bool result = await _channel.invokeMethod("setAnonymous");
    return result;
  }

  static Future<bool> get setEmail async {
    final bool result = await _channel.invokeMethod("setEmail");
    return result;
  }

  static Future<bool> get setPhone async {
    final bool result = await _channel.invokeMethod("setPhone");
    return result;
  }

  static Future<bool> get setApple async {
    final bool result = await _channel.invokeMethod("setApple");
    return result;
  }

  static Future<bool> get setGithub async {
    final bool result = await _channel.invokeMethod("setGithub");
    return result;
  }

  static Future<bool> get setMicrosoft async {
    final bool result = await _channel.invokeMethod("setMicrosoft");
    return result;
  }

  static Future<bool> get setYahoo async {
    final bool result = await _channel.invokeMethod("setYahoo");
    return result;
  }

  static Future<bool> get setGoogle async {
    final bool result = await _channel.invokeMethod("setGoogle");
    return result;
  }

  static Future<bool> get setFacebook async {
    final bool result = await _channel.invokeMethod("setFacebook");
    return result;
  }

  static Future<bool> get setTwitter async {
    final bool result = await _channel.invokeMethod("setTwitter");
    return result;
  }
}
