import 'package:flutter_auth_ui/src/flutter_auth_ui_method_channel.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterAuthUiPlatform extends PlatformInterface {
  /// Constructs a FlutterAuthUiPlatform.
  FlutterAuthUiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAuthUiPlatform _instance = MethodChannelFlutterAuthUi();

  /// The default instance of [FlutterAuthUiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAuthUi].
  static FlutterAuthUiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAuthUiPlatform] when
  /// they register themselves.
  static set instance(FlutterAuthUiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Start Firebase Auth UI process.
  ///
  /// Return `true` if login process is completed.
  Future<bool> startUi({
    required List<AuthUiProvider> items,
    required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    bool autoUpgradeAnonymousUsers = false,
    AndroidOption androidOption = const AndroidOption(),
    WebAuthOption webAuthOption = const WebAuthOption(),
    EmailAuthOption emailAuthOption = const EmailAuthOption(),
  }) async {
    throw UnimplementedError('startUi() has not been implemented.');
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    throw UnimplementedError('signOut() has not been implemented.');
  }
}
