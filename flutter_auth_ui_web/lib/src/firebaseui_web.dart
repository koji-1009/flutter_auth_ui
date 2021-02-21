@JS('firebaseui.auth')
library firebaseui;

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

@JS('AuthUI.getInstance')
external AuthUI getInstance(String appId);

@JS('AuthUI')
class AuthUI {
  external factory AuthUI(dynamic auth, [String appId]);

  external void start(html.Element element, Config config);

  external void reset();
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
  external bool signInSuccessWithAuthResult(dynamic authResult, [String url]);

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

  external bool get autoUpgradeAnonymousUsers;

  external String get signInFlow;

  external String get tosUrl;

  external String get privacyPolicyUrl;

  external factory Config({
    @required Callbacks callbacks,
    @required List<dynamic> signInOptions,
    @required String signInFlow,
    bool autoUpgradeAnonymousUsers,
    String tosUrl,
    String privacyPolicyUrl,
  });
}

@anonymous
@JS()
abstract class ActionCodeSettings {
  external String get url;

  external bool get handleCodeInApp;

  external ActionCodeSettingsAndroid get android;

  external factory ActionCodeSettings({
    @required String url,
    @required bool handleCodeInApp,
    @required ActionCodeSettingsAndroid android,
  });
}

@anonymous
@JS()
abstract class ActionCodeSettingsAndroid {
  external String get packageName;

  external bool get installApp;

  external String get minimumVersion;

  external factory ActionCodeSettingsAndroid({
    @required String packageName,
    @required bool installApp,
    @required String minimumVersion,
  });
}

@anonymous
@JS()
abstract class EmailSignInOption {
  external String get provider;

  external bool get requireDisplayName;

  external String get signInMethod;

  external ActionCodeSettings get emailLinkSignIn;

  external factory EmailSignInOption({
    @required String provider,
    @required bool requireDisplayName,
    @required String signInMethod,
    ActionCodeSettings emailLinkSignIn,
  });
}
