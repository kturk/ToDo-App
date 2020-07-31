import 'package:ToDo_App/screens/toDoList.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../sign_in.dart';

class LogIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogInState();
  }
}

class _LogInState extends State<LogIn> {
  GoogleSignInAccount _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: buildSignInButton(),
        ),
      ),
    );
  }

  Column buildSignInButton() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
        _signInButton(),
      ],
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      onPressed: () {
        goToToDoList();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: textAndImageOfSignIn(),
        ),
      ),
    );
  }

  Future<String> goToToDoList() {
    return signInWithGoogle().whenComplete(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ToDoList();
          },
        ),
      );
    });
  }

  List<Widget> textAndImageOfSignIn() {
    return <Widget>[
      Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      )
    ];
  }
}
