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
                      AuthUiItem.AuthApple,
                      AuthUiItem.AuthGithub,
                      AuthUiItem.AuthGoogle,
                      AuthUiItem.AuthMicrosoft,
                      AuthUiItem.AuthYahoo,
                    ];
                    final tosAndPrivacyPolicy = TosAndPrivacyPolicy(
                        "https://www.google.com", "https://www.google.com");

                    final result = await FlutterAuthUi.startUi(
                        providers, tosAndPrivacyPolicy);
                    print(result);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
