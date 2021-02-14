@JS('firebaseui.auth')
library firebaseui;

import 'dart:html' as html;
import 'package:js/js.dart';

@JS('AuthUI.getInstance')
external AuthUI getInstance(String appId);

@JS('AuthUI')
class AuthUI {
  external factory AuthUI(dynamic auth, [String appId]);

  external void disableAutoSignIn();

  external void start(html.Element element, Config config);

  external void setConfig(Config config);

  external void signIn();

  external void reset();

  external bool isPendingRedirect();
}

typedef SignInAuthResultSuccess = bool Function(
  dynamic authResult,
  String redirectUrl,
);
typedef SignInFailure = void Function(
  dynamic error,
);

@anonymous
@JS()
abstract class Callbacks {
  external bool signInSuccessWithAuthResult(dynamic authResult,
      [String redirectUrl]);

  external void signInFailure(dynamic error);

  external void uiShown();

  external factory Callbacks({
    SignInAuthResultSuccess signInSuccessWithAuthResult,
    SignInFailure signInFailure,
    void Function() uiShown,
  });
}

@anonymous
@JS()
abstract class Config {
  external Callbacks get callbacks;

  external List<dynamic> get signInOptions;

  external String get tosUrl;

  external String get privacyPolicyUrl;

  external factory Config({
    Callbacks callbacks,
    List<dynamic> signInOptions,
    String tosUrl,
    String privacyPolicyUrl,
  });
}
