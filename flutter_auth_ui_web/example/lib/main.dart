import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                child: const Text("start ui"),
                onPressed: () async {
                  final providers = [
                    AuthUiItem.AuthAnonymous,
                    AuthUiItem.AuthEmail,
                    AuthUiItem.AuthPhone,
                    AuthUiItem.AuthApple,
                    AuthUiItem.AuthGithub,
                    AuthUiItem.AuthGoogle,
                    AuthUiItem.AuthMicrosoft,
                    AuthUiItem.AuthYahoo,
                  ];

                  final result = await FlutterAuthUi.startUi(
                    items: providers,
                    tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                      tosUrl: "https://www.google.com",
                      privacyPolicyUrl: "https://www.google.com",
                    ),
                    androidOption: AndroidOption(
                      enableSmartLock: false, // default true
                    ),
                    // If you need EmailLink mode, please set EmailAuthOption
                    emailAuthOption: EmailAuthOption(
                      enableMailLink: false, // default false
                      requireName: true, // default true
                      handleURL: '',
                      androidPackageName: '',
                      androidMinimumVersion: '',
                    ),
                  );
                  print(result);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
