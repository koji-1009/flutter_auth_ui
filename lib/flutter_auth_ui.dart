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

  static Future get setEmail async {
    await _channel.invokeMethod("setEmail");
  }

  static Future get setPhone async {
    await _channel.invokeMethod("setPhone");
  }

  static Future get setApple async {
    await _channel.invokeMethod("setApple");
  }
}
