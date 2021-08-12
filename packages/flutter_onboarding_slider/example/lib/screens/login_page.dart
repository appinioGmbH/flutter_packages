import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Login Page'),
        backgroundColor: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      child: Container(),
    );
  }
}
