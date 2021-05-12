import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/OwnMessageBubble.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/reply_message_bubble.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import '../constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/MessageModel.dart';
import 'models/account.dart';

// https://flutter.dev/docs/cookbook/networking/web-sockets
/*
  -Connect to a WebSocket server.
  -Listen for messages from the server.
  -Send data to the server.
  -Close the WebSocket connection.
*/

// this widget will hold the direct message boilerplate for each match in your matchlist
class DM extends StatefulWidget {
  // information at your disposal from both your own account and that of the user you are
  // direct messaging
  final Account activeUser, otherUser;
  DM({this.activeUser, this.otherUser});

  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  var controller = TextEditingController();
  // final String ipAddyAndPortNum = 'ws://rruiz.dev:5000'; // 192.168.1.84
  final String ipAddyAndPortNum = 'http://192.168.1.84:5000'; // 192.168.1.84
  IO.Socket socket;
  List<MessageModel> messages = [];
  DateTime now = DateTime.now();

  void connect() {
    socket = IO.io(ipAddyAndPortNum, <String, dynamic>{
      'transports': ['websocket'],
      // 'autoConnect': false,
    });

    socket.connect();
    // socket.on('connect', (msg) {
    //   print('connected to socket');

    //   // message sent to you from the other person
    //   setMessage('destination', msg['message']);
    //   socket.emit('msg', 'test');
    // });

    socket.onConnect((data) {
      print('connected to socket');

      socket.on('message', (msg) {
        //// json map => map<string,string>
        print(msg.runtimeType);
        print('received message from the other user');
        // setMessage('destination', msg['message']);

        for (var obj in msg) {
          print(obj.runtimeType);
          setMessage('destination', obj['message']);
        }
      });
    });
    // socket.on('message', (msg) {
    //     print(msg);
    //     print('receiving message from the other user');
    //     setMessage('destination', msg['message']);
    //   });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnected'));
    socket.on('fromServer', (_) => print(_));

    // print(socket.connected);

    // tell the socket server that this user has signed in
    socket.emit('signin', widget.activeUser.userID);

    // socket.emit('/test', 'hello there!');
  }

  // message to send to the other person by you
  // sourceId: who's sending the message
  // targetId: who's receiving the message
  void sendMessage(String message, String sourceId, String targetId) {
    setMessage('source', message);

    socket.emit('message',
        {'message': message, 'sourceId': sourceId, 'targetId': targetId});
  }

  void setMessage(String type, String message) {
    var msgModel = MessageModel(type: type, message: message);
    messages.add(msgModel);
    setState(() {});
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
                    child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // your own message will be aligned to the right of the screen
                        if (messages[index].type == 'source') {
                          print(messages.length);
                          return OwnMessageBubble(
                            message: messages[index].message,
                            time: now.hour.toString() +
                                ":" +
                                now.minute.toString(),
                          );
                        }

                        // the other person's will be aligned to the left of the screen
                        return ReplyBubble(
                          message: messages[index].message,
                          time:
                              now.hour.toString() + ":" + now.minute.toString(),
                        );
                      },
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
                              controller: controller,
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
                              onPressed: () {
                                // get account object that holds the id of the user
                                sendMessage(
                                    controller.text,
                                    widget.activeUser.userID,
                                    widget.otherUser.userID);
                                controller.clear();
                              },
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
    controller.dispose();
    print('left the dm chat');
    socket.emit('signedout', widget.activeUser.userID);

    // socket.close() gave an error, so I commented it out
    socket.dispose();
    // socket.disconnect();
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
