// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_options.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_platform_interface.dart';
import 'package:flutter_auth_ui/src/flutter_auth_ui_web_types.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

/// A web implementation of the FlutterAuthUiPlatform of the FlutterAuthUi plugin.
class FlutterAuthUiWeb extends FlutterAuthUiPlatform {
  /// Constructs a FlutterAuthUiWeb
  FlutterAuthUiWeb();

  static void registerWith(Registrar registrar) {
    FlutterAuthUiPlatform.instance = FlutterAuthUiWeb();
  }

  late final _authUi = AuthUI(getAuth());

  @override
  Future<bool> startUi({
    required List<AuthUiProvider> items,
    required TosAndPrivacyPolicy tosAndPrivacyPolicy,
    bool autoUpgradeAnonymousUsers = false,
    AndroidOption androidOption = const AndroidOption(),
    WebAuthOption webAuthOption = const WebAuthOption(),
    EmailAuthOption emailAuthOption = const EmailAuthOption(),
  }) async {
    final pageTitle = webAuthOption.pageTitle;
    final title = pageTitle ?? window.document.title;
    final path = window.location.href;

    final options = items
        .map<JSAny?>((item) {
          switch (item.providerName) {
            case 'Anonymous':
              return 'anonymous'.toJS;
            case 'Email':
              final requireDisplayName = emailAuthOption.requireDisplayName;
              final enableEmailLink = emailAuthOption.enableMailLink;
              if (!enableEmailLink) {
                return EmailSignInOption(
                  provider: 'password',
                  signInMethod: 'password',
                  requireDisplayName: requireDisplayName,
                );
              }

              final url = emailAuthOption.handleURL;
              if (url.isEmpty) {
                throw PlatformException(
                  code: 'InvalidArgs',
                  details: 'Missing handleURL',
                );
              }

              final packageName = emailAuthOption.androidPackageName;
              final minimumVersion = emailAuthOption.androidMinimumVersion;
              return EmailSignInOption(
                provider: 'password',
                signInMethod: 'emailLink',
                requireDisplayName: requireDisplayName,
                emailLinkSignIn: ActionCodeSettings(
                  url: url,
                  handleCodeInApp: true,
                  android: packageName.isNotEmpty
                      ? ActionCodeSettingsAndroid(
                          packageName: packageName,
                          installApp: false,
                          minimumVersion: minimumVersion,
                        )
                      : null,
                ),
              );
            case 'Phone':
              return 'phone'.toJS;
            case 'Apple':
              return 'apple.com'.toJS;
            case 'GitHub':
              return 'github.com'.toJS;
            case 'Microsoft':
              return 'microsoft.com'.toJS;
            case 'Yahoo':
              return 'yahoo.com'.toJS;
            case 'Google':
              return 'google.com'.toJS;
            case 'Facebook':
              return 'facebook.com'.toJS;
            case 'Twitter':
              return 'twitter.com'.toJS;
          }

          return null;
        })
        .nonNulls
        .toList()
        .toJS;

    final tosUrl = tosAndPrivacyPolicy.tosUrl;
    final privacyPolicyUrl = tosAndPrivacyPolicy.privacyPolicyUrl;

    final overlayDiv = HTMLDivElement();
    overlayDiv.style
      ..position = 'fixed'
      ..top = '0'
      ..left = '0'
      ..width = '100vw'
      ..height = '100vh'
      ..zIndex = '9999'
      ..backgroundColor = webAuthOption.backgroundColor;
    window.document.body?.appendChild(overlayDiv);

    late final JSFunction popStateListener;
    popStateListener = () {
      window.document.body?.removeChild(overlayDiv);
      window.removeEventListener('popstate', popStateListener);
    }.toJS;
    window.addEventListener(
      'popstate',
      popStateListener,
    );

    final completer = Completer<bool>();
    final config = Config(
      callbacks: Callbacks(
        signInSuccessWithAuthResult: () {
          window.history.back();
          window.document.body?.removeChild(overlayDiv);
          window.removeEventListener('popstate', popStateListener);

          completer.complete(getAuth().currentUser != null);
          return false;
        }.toJS,
        signInFailure: (JSObject error) {
          window.history.back();
          window.document.body?.removeChild(overlayDiv);
          window.removeEventListener('popstate', popStateListener);

          completer.completeError(error);
        }.toJS,
        uiShown: () {
          window.history.pushState(null, title, path);
        }.toJS,
      ),
      signInOptions: options,
      signInFlow: 'popup',
      autoUpgradeAnonymousUsers: autoUpgradeAnonymousUsers,
      tosUrl: tosUrl,
      privacyPolicyUrl: privacyPolicyUrl,
    );

    _authUi.reset();
    _authUi.start(overlayDiv, config);

    return completer.future;
  }

  @override
  Future<void> signOut() async {
    await getAuth().signOut().toDart;
  }
}
