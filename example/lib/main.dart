import 'package:firebase_auth/firebase_auth.dart';
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
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            FilledButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);

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

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      result ? 'Success sign-in' : 'Failed sign-in',
                    ),
                  ),
                );
              },
              child: const Text('Sign in'),
            ),
            FilledButton.tonal(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await FlutterAuthUi.signOut();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Success sign-out'),
                  ),
                );
              },
              child: const Text('Sign out'),
            ),
            OutlinedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      user == null
                          ? 'No user is signed in'
                          : '${user.uid} is signed in',
                    ),
                  ),
                );
              },
              child: const Text('Check sign-in status'),
            ),
          ],
        ),
      ),
    );
  }
}
