import 'package:flutter/material.dart';
import '../constants.dart';

class DMChat extends StatefulWidget {
  @override
  _DMChatState createState() => _DMChatState();
}

class _DMChatState extends State<DMChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text('This is the dm chat page'),
            ),
          ),
      ),
    );
  }
}
