import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_auth_ui');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return Map();
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startUi', () async {
    expect(
      await FlutterAuthUi.startUi(
        items: [],
        tosAndPrivacyPolicy: TosAndPrivacyPolicy(
          tosUrl: '',
          privacyPolicyUrl: '',
        ),
      ),
      true,
    );
  });
}
