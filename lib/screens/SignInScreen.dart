import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:test_gmail_api/screens/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late gmail.GmailApi gmailApi;
  late http.Client client;

  // context to show Dialog for the link
  late BuildContext currentContext;

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

  // prompt for user to sign-in using the consent Screen
  void _prompt(String url) {
    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () async {
              launch(url);
              Navigator.of(context).pop();
            },
            child: Text(' Please go the following URL and grant access: $url'),
          ),
        );
      },
    );
  }

  Future<void> obtainCredentials(context) async {
    currentContext = context;
    client = http.Client();

    try {
      AutoRefreshingAuthClient authClient = await clientViaUserConsent(
        ClientId(
          '',
          '',
        ),
        [gmail.GmailApi.gmailReadonlyScope],
        _prompt,
      );

      final file = await _localFile;

      await file.writeAsString(jsonEncode(authClient.credentials));
    }
    on Exception catch (exception) {
      print( exception );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () async {
            await obtainCredentials(context);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return const HomeScreen( );
              }),
            );
          },
          child: const Text('Sign in'),
        ),
      ),
    );
  }
}
