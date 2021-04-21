import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/OwnMessageBubble.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/reply_message_bubble.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import '../constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// https://flutter.dev/docs/cookbook/networking/web-sockets
/*
  -Connect to a WebSocket server.
  -Listen for messages from the server.
  -Send data to the server.
  -Close the WebSocket connection.
*/

class DM extends StatefulWidget {
  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  TextEditingController controller;
  IO.Socket socket;
  final String ipAddyAndPortNum = 'ws://localhost:3000'; // 192.168.1.84

  void connect() {
    socket = IO.io(ipAddyAndPortNum, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => print('connected'));
    print(socket.connected);

    socket.emit('/test', 'hello there!');
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // background image for dms
        Image.asset('assets/images/baby_yoda.jpg'),
        Scaffold(
            backgroundColor: Colors.blueGrey,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  // messages from both yourself and the other person will be here
                  Container(
                    height: MediaQuery.of(context).size.height - 110,
                    child: ListView(
                      children: [
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                        OwnMessageBubble(
                          message: 'Hello there',
                          time: '00:00',
                        ),
                        ReplyBubble(
                          message: 'General Kenobi!',
                          time: '00:00',
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    // row will be at the bottom of the screen
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 55,
                          child: Card(
                            margin: EdgeInsets.only(
                              left: 2,
                              right: 2,
                              bottom: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              maxLines: 5,
                              minLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Please type a message',
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.emoji_emotions,
                                  ),
                                  onPressed: () {
                                    print('pick an emoji');
                                  },
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                          child: CircleAvatar(
                            radius: 25,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
            // This trailing comma makes auto-formatting nicer for build methods.
            ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MessagesBubble extends StatelessWidget {
  final String sender;
  final String text;
  MessagesBubble({this.sender = 'dummy sender', this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            // gives shadow to the messages bubbles`
            elevation: 5.0,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
