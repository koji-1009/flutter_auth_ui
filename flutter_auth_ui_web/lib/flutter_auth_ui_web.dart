import 'dart:async';
import 'dart:html' as html;

import 'package:firebase/firebase.dart' show auth;
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui_web/src/firebaseui_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart' show allowInterop;

class FlutterAuthUiWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'flutter_auth_ui',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterAuthUiWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    if (call.method != 'startUi') {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'doesn\'t implement \'${call.method}\'',
      );
    }

    // add history
    final title = html.window.document.documentElement.title;
    final path = html.window.location.origin + '/#/';
    html.window.history.pushState(null, title, path);

    final args = Map<String, dynamic>.from(call.arguments);
    final providers = args['providers'] as String;
    final setProviders = providers.split(',');
    final options = setProviders.map((name) {
      switch (name) {
        case 'Anonymous':
          return 'anonymous';
        case 'Email':
          bool requireNameForWeb = args["requireNameForWeb"] ?? true;
          bool enableEmailLinkForWeb = args["enableEmailLinkForWeb"] ?? false;
          if (!enableEmailLinkForWeb) {
            return EmailSignInOption(
              provider: 'password',
              signInMethod: 'password',
              requireDisplayName: requireNameForWeb,
            );
          }

          String url = args['emailLinkHandleURL'] ?? '';
          if (url.isEmpty) {
            throw PlatformException(
              code: 'InvalidArgs',
              details: 'Missing handleURL',
            );
          }

          String packageName = args["emailLinkAndroidPackageName"] ?? '';
          String minimumVersion = args["emailLinkAndroidMinimumVersion"] ?? '';
          return EmailSignInOption(
            provider: 'password',
            signInMethod: 'emailLink',
            requireDisplayName: requireNameForWeb,
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
          return 'password';
        case 'Phone':
          return 'phone';
        case 'Apple':
          return 'apple.com';
        case 'GitHub':
          return 'github.com';
        case 'Microsoft':
          return 'microsoft.com';
        case 'Yahoo':
          return 'yahoo.com';
        case 'Google':
          return 'google.com';
        case 'Facebook':
          return 'facebook.com';
        case 'Twitter':
          return 'twitter.com';
      }
    }).toList();

    final tosUrl = args['tosUrl'];
    final privacyPolicyUrl = args['privacyPolicyUrl'];

    // add div element instead of 'firebaseui-auth-container' div
    final containerDiv = html.Element.div();
    html.window.document.documentElement.append(containerDiv);

    // get flutter web's main view
    final fltGlassPane = html.window.document
        .getElementsByTagName('flt-glass-pane')[0] as html.Element;

    // watch back event, if not, we cannot support back key
    html.window.addEventListener('popstate', (event) {
      containerDiv.remove();
      fltGlassPane.style.visibility = 'visible';
    });

    final completer = Completer();
    final callbacks = Callbacks(
      signInSuccessWithAuthResult: allowInterop((authResult, redirectUrl) {
        completer.complete(auth().currentUser != null);
        html.window.history.back();

        return false;
      }),
      signInFailure: allowInterop((error) {
        completer.completeError(error);
        html.window.history.back();
      }),
      uiShown: allowInterop(() {
        fltGlassPane.style.visibility = 'hidden';
      }),
    );

    final config = Config(
      callbacks: callbacks,
      signInOptions: options,
      signInFlow: 'popup',
      autoUpgradeAnonymousUsers: args["autoUpgradeAnonymousUsers"] ?? false,
      tosUrl: tosUrl,
      privacyPolicyUrl: privacyPolicyUrl,
    );

    final authUi = getInstance(auth().app.name) ?? AuthUI(auth().jsObject);
    authUi.reset();
    authUi.start(containerDiv, config);

    return completer.future;
  }
}
