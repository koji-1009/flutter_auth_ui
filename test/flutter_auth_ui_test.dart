import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_auth_ui');

  TestWidgetsFlutterBinding.ensureInitialized();

  final mockUser = PlatformUser(
      providerId: "test",
      uid: "001",
      displayName: "test",
      photoUrl: null,
      email: null,
      phoneNumber: null,
      creationTimestamp: 12345,
      lastSignInTimestamp: 12345,
      isAnonymous: false,
      isEmailVerified: false,
      providerData: Iterable.empty());

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockUser;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startUi', () async {
    expect(await FlutterAuthUi.startUi(), mockUser);
  });
}
