import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("start ui"),
                onPressed: () async {
                  final providers = [
                    AuthUiProvider.anonymous,
                    AuthUiProvider.email,
                    AuthUiProvider.phone,
                    AuthUiProvider.apple,
                    AuthUiProvider.github,
                    AuthUiProvider.google,
                    AuthUiProvider.microsoft,
                    AuthUiProvider.yahoo,
                  ];

                  final result = await FlutterAuthUi.startUi(
                    items: providers,
                    tosAndPrivacyPolicy: const TosAndPrivacyPolicy(
                      tosUrl: "https://www.google.com",
                      privacyPolicyUrl: "https://www.google.com",
                    ),
                    androidOption: const AndroidOption(
                      enableSmartLock: false, // default true
                      showLogo: true, // default false
                      overrideTheme: true, // default false
                    ),
                    emailAuthOption: const EmailAuthOption(
                      requireDisplayName: true,
                      // default true
                      enableMailLink: false,
                      // default false
                      handleURL: '',
                      androidPackageName: '',
                      androidMinimumVersion: '',
                    ),
                  );
                  debugPrint(result.toString());
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await FlutterAuthUi.signOut();
                  debugPrint('Signed out !');
                },
                child: const Text('sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
