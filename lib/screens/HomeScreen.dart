import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:test_gmail_api/screens/SignInScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> labelIds;
  late List<String> msgIds;
  late Future<void> myFuture;
  late http.Client client;

  @override
  void initState() {
    super.initState();
    myFuture = init();
  }

  Future<void> init() async {
    msgIds = await _getEmailMessages();
  }

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

  Future obtainCredentials(context) async {
    client = http.Client();

    final file = await _localFile;

    // Reading data from the file
    final contents = await file.readAsString();

    // parsing the data from json to Map
    final body = json.decode(contents);
    final tokenBody = body['accessToken'];

    // getting the expiry date for the token
    DateTime expiry = DateTime.parse(tokenBody['expiry']);

    // creating the object for accessToken
    AccessToken token = AccessToken(
      tokenBody['type'],
      tokenBody['data'],
      expiry,
    );

    // creating new AccessCredentials using the initial credential data
    AccessCredentials creds = AccessCredentials(
      token,
      body['refreshToken'],
      [gmail.GmailApi.gmailReadonlyScope],
    );

    // creating a auto-refreshing client from the fetched access-credentials
    AutoRefreshingAuthClient authClient = autoRefreshingClient(
      ClientId(
          '566804110461-f8uuc235otkefg47r9qfpnsdna0g5ihq.apps.googleusercontent.com',
          ''),
      creds,
      client,
    );

    return authClient;
  }

  Future<List<String>> _getEmailMessages() async {
    List<String> msgSnippets = [];

    try {
      AutoRefreshingAuthClient authClient = await obtainCredentials(context);
      gmail.GmailApi api = gmail.GmailApi(authClient);

      gmail.ListMessagesResponse clientMessages =
          await api.users.messages.list('me', maxResults: 10);

      List<String> msgIds = clientMessages.messages!.map((message) {
        return message.id.toString();
      }).toList();

      for (String id in msgIds) {
        gmail.Message msg =
            await api.users.messages.get('me', id, format: 'raw');
        msgSnippets.add(msg.snippet.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return msgSnippets;
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(msgIds[index]),
                ),
              );
            },
            itemCount: msgIds.length,
          );
        } else if (snapshot.hasError) {
          return Card(
            elevation: 10,
            child: Container(
              alignment: Alignment.center,
              child: Text(snapshot.error.toString()),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Application'),
        actions: [
          IconButton(
            onPressed: () async {
              final file = await _localFile;
              file.delete();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignInScreen() )
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Container(child: buildFutureBuilder()),
    );
  }
}
