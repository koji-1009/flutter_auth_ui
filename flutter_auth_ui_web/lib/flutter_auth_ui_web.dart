import 'dart:async';
import 'dart:html' as html;

import 'package:firebase/firebase.dart' show auth;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart' show allowInterop;

import 'src/firebaseui_web.dart';

/// Implementation for the firebaseui-web
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

  Future<dynamic> startUi(MethodCall call) async {
    // add history
    final title = html.window.document.documentElement?.title ?? '';
    final path = '${html.window.location.origin}/#/';
    html.window.history.pushState(null, title, path);

    final args = Map<String, dynamic>.from(call.arguments);
    final providers = args['providers'] as String;
    final setProviders = providers.split(',');
    final options = setProviders.map((name) {
      switch (name) {
        case 'Anonymous':
          return 'anonymous';
        case 'Email':
          bool requireDisplayName = args["emailLinkRequireDisplayName"] ?? true;
          bool enableEmailLink = args["emailLinkEnableEmailLink"] ?? false;
          if (!enableEmailLink) {
            return EmailSignInOption(
              provider: 'password',
              signInMethod: 'password',
              requireDisplayName: requireDisplayName,
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

    // get flutter web's main view
    final fltGlassPane = html.window.document.querySelector('flt-glass-pane');
    if (fltGlassPane == null) {
      throw PlatformException(
        code: 'IllegalStateException',
        details: 'Failed to locate <flt-glass-pane>',
      );
    }

    final containerDiv = html.Element.div();
    // add div element instead of 'firebaseui-auth-container' div
    // 'fltGlassPane.parent' is a body element, maybe
    fltGlassPane.parent?.append(containerDiv);

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

  Future<void> signOut(MethodCall call) async {
    await auth().signOut();
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'startUi':
        return await startUi(call);
      case 'signOut':
        return await signOut(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
