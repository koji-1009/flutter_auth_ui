import 'dart:async';

import 'dart:html' as html;
import 'package:firebase/firebase.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_auth_ui_web/src/firebaseui_web.dart';

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
        case "Anonymous":
          return 'anonymous';
        case "Email":
          return EmailAuthProvider.PROVIDER_ID;
        case "Phone":
          return PhoneAuthProvider.PROVIDER_ID;
        case "Apple":
          return 'apple.com';
        case "GitHub":
          return GithubAuthProvider.PROVIDER_ID;
        case "Microsoft":
          return 'microsoft.com';
        case "Yahoo":
          return 'yahoo.com';
        case "Google":
          return GoogleAuthProvider.PROVIDER_ID;
        case "Facebook":
          return FacebookAuthProvider.PROVIDER_ID;
        case "Twitter":
          return TwitterAuthProvider.PROVIDER_ID;
      }
    }).toList();

    final tosUrl = args["tosUrl"];
    final privacyPolicyUrl = args["privacyPolicyUrl"];

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
      tosUrl: tosUrl,
      privacyPolicyUrl: privacyPolicyUrl,
    );

    final authUi = getInstance(auth().app.name) ?? AuthUI(auth().jsObject);
    authUi.start(containerDiv, config);

    return completer.future;
  }
}
