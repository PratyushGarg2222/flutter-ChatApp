import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //Login

        var authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        //Sign up

        var authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //Image Upload here

        //This returns a ref path
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        //Upload image
        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        //User data upload here
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(
          {
            'username': username,
            'email': email,
            'image_url': url,
          },
        );
      }
    } catch (error) {
      var message = "An error occured, please check your credentials";

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
