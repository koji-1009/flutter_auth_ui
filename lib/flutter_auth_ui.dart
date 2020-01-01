import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAuthUi {
  static const MethodChannel _channel =
      const MethodChannel('flutter_auth_ui');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
