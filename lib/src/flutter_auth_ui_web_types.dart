import 'dart:js_interop';

@JS('firebase_auth.getAuth')
external Auth getAuth();

extension type Auth._(JSObject _) implements JSObject {
  external JSPromise signOut();

  external JSObject? currentUser;
}

@JS('firebaseui.auth.AuthUI')
extension type AuthUI._(JSObject _) implements JSObject {
  external factory AuthUI(JSObject auth);

  external void start(JSObject element, Config config);

  external void reset();
}

@JS('firebaseui.auth.Config')
extension type Config._(JSObject _) implements JSObject {
  external factory Config({
    Callbacks callbacks,
    JSArray<JSAny> signInOptions,
    String signInFlow,
    bool autoUpgradeAnonymousUsers,
    String tosUrl,
    String privacyPolicyUrl,
  });
}

extension type Callbacks._(JSObject _) implements JSObject {
  external factory Callbacks({
    JSFunction signInSuccessWithAuthResult,
    JSFunction signInFailure,
    JSFunction uiShown,
  });
}

extension type EmailSignInOption._(JSObject _) implements JSObject {
  external factory EmailSignInOption({
    String provider,
    bool requireDisplayName,
    String signInMethod,
    ActionCodeSettings emailLinkSignIn,
  });
}

extension type ActionCodeSettings._(JSObject _) implements JSObject {
  external factory ActionCodeSettings({
    String url,
    bool handleCodeInApp,
    ActionCodeSettingsAndroid? android,
  });
}

extension type ActionCodeSettingsAndroid._(JSObject _) implements JSObject {
  external factory ActionCodeSettingsAndroid({
    String packageName,
    bool installApp,
    String minimumVersion,
  });
}
