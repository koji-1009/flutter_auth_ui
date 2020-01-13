import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initProviders();
  }

  Future<void> initProviders() async {
    FlutterAuthUi.setEmail();
    FlutterAuthUi.setApple();
    FlutterAuthUi.setGithub();
    FlutterAuthUi.setGoogle();
    FlutterAuthUi.setMicrosoft();
    FlutterAuthUi.setYahoo();
  }

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
                    final user = await FlutterAuthUi.startUi();
                    print(user);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
