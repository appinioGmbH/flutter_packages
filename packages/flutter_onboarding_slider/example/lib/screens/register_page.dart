import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
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
