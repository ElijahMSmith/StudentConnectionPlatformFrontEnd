import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants.dart';

class DMChat extends StatefulWidget
{
  final WebSocketChannel channel;

  const DMChat({Key key, this.channel}) : super(key: key);

  @override
  _DMChatState createState() => _DMChatState();
}

class _DMChatState extends State<DMChat>
{
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
