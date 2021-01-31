import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                      enableMailLink: false, // default false
                      requireName: true, // default true
                    ),
                    iosOption: IosOption(
                      enableMailLink: false, // default false
                      requireName: true, // default true
                    ),
                    // If you need EmailLink mode, please set EmailAuthOption
                    emailAuthOption: EmailAuthOption(
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
