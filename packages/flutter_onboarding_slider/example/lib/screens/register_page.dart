import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Register Page'),
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
