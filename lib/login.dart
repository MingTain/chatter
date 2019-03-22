import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  _login() {
    Navigator.of(context).pop({'name': 'Yang'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: RaisedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        )
    );
  }
}