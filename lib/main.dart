import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_gmail_api/screens/HomeScreen.dart';
import 'package:test_gmail_api/screens/SignInScreen.dart';

void main() => runApp( const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> credentialsPresent;
  late Widget redirectedScreen;

  // returns the local path to the documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // if present, creates a reference to the credentials file stored in the documents directory
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/credentials.json');
  }

  @override
  void initState() {
    super.initState();
    credentialsPresent = init();
  }

  Future<void> init() async {
    await checkForCredentials();
  }

  Future<void> checkForCredentials() async {
    final file = await _localFile;
    redirectedScreen = await file.exists() ? const HomeScreen() : const SignInScreen() ;
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: credentialsPresent,
      builder: (context, snapshot) {
        if( snapshot.connectionState == ConnectionState.done ){
          return redirectedScreen;
        }
        else if( snapshot.hasError ){
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Text( snapshot.error.toString() ),
            ),
          );
        }
        else {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Flutter",
      home: buildFutureBuilder(),
    );
  }
}