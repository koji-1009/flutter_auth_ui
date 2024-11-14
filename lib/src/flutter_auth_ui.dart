import 'package:flutter_auth_ui/src/flutter_auth_ui_options.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_platform_interface.dart';

/// The main class of the plugin.
abstract class FlutterAuthUi {
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
    return FlutterAuthUiPlatform.instance.startUi(
      items: items,
      tosAndPrivacyPolicy: tosAndPrivacyPolicy,
      autoUpgradeAnonymousUsers: autoUpgradeAnonymousUsers,
      androidOption: androidOption,
      webAuthOption: webAuthOption,
      emailAuthOption: emailAuthOption,
    );
  }

  /// Sign out the current user.
  static Future<void> signOut() async {
    return FlutterAuthUiPlatform.instance.signOut();
  }
}
