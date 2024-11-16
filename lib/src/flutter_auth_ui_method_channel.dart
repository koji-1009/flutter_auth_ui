import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_options.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_platform_interface.dart';

/// An implementation of [FlutterAuthUiPlatform] that uses method channels.
class MethodChannelFlutterAuthUi extends FlutterAuthUiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_auth_ui');

  @override
  Future<bool> startUi({
    required List<AuthUiProvider> items,
    required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    bool autoUpgradeAnonymousUsers = false,
    AndroidOption androidOption = const AndroidOption(),
    WebAuthOption webAuthOption = const WebAuthOption(),
    EmailAuthOption emailAuthOption = const EmailAuthOption(),
  }) async {
    final providers = items.map((e) => e.providerName).join(',');
    try {
      final data = await methodChannel.invokeMethod<bool>(
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
      log('flutter_auth_ui: error => $e');
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await methodChannel.invokeMethod<void>('signOut');
  }
}
