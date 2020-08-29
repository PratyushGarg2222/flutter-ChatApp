import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../chat/messages.dart';
import '../chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.configure(
        //If the app is running in foreground
        onMessage: (msg) {
      print(msg);
      return;
    },
        //Runs if the notification is clicked when the app is killed
        onLaunch: (msg) {
      print(msg);
      return;
    },
        //Runs when the user clicks the notification if he is in other app ( but flutterchat is still running)
        onResume: (msg) {
      print(msg);
      return;
    });

    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
