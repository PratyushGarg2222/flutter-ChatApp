import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (error) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.deepPurple,
          backgroundColor: Colors.pink,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (userSnapShot.hasData)
              return ChatScreen();
            else
              return AuthScreen();
          },
        ),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
