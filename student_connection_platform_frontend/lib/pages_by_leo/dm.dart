import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/OwnMessageBubble.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/reply_message_bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/MessageModel.dart';
import 'models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

// https://flutter.dev/docs/cookbook/networking/web-sockets
/*
  -Connect to a WebSocket server.
  -Listen for messages from the server.
  -Send data to the server.
  -Close the WebSocket connection.
*/

enum Options {
  CLEAR_MESSAGES,
}

/// this widget will hold the direct message boilerplate for each match in your matchlist
class DM extends StatefulWidget {
  // information at your disposal from both your own account and that of the user you are
  // direct messaging
  final Account activeUser, otherUser;
  DM({
    this.activeUser,
    this.otherUser,
  });

  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  TextEditingController controller = TextEditingController();
  ScrollController sc = ScrollController();
  // final String ipAddyAndPortNum = 'ws://rruiz.dev:5000'; // 192.168.1.84

  List<MessageModel> messages = [];
  IO.Socket socket;
  // final String ipAddyAndPortNum = 'http://192.168.1.84:5000';
  final String ipAddyAndPortNum = 'https://t3-chat.rruiz.dev';
  SharedPreferences sp;
  Options options;

  // message to send to the other person by you
  // senderID: who's sending the message
  // targetId: who's receiving the message
  void sendMessage(String message, String senderID, String targetId) {
    // add to list of messages to display on screen
    setMessage('source', message);

    // send to the socket server so that the other user can receive it
    socket.emit('message',
        {'message': message, 'senderID': senderID, 'targetId': targetId});
  }

  void setMessage(String type, String message) {
    var msgModel = MessageModel(
        type: type,
        message: message,
        // get the hours and the minutes
        time: DateTime.now().toString().substring(10, 16));
    messages.add(msgModel);
    saveListOfMessages();
    setState(() {});
  }

  void scrollToBottom({int milliseconds = 300}) {
    // scrolls the list view to the bottom of everytime a new message is sent
    sc.animateTo(sc.position.maxScrollExtent,
        duration: Duration(milliseconds: milliseconds), curve: Curves.easeOut);
  }

  void connect() {
    // tell the socket server that this user has signed in
    socket = IO.io(ipAddyAndPortNum, <String, dynamic>{
      'transports': ['websocket'],
      // 'autoConnect': false,
    });
    socket.emit('signin', [widget.activeUser.userID, widget.otherUser.userID]);

    socket.connect();
    print('you have signed in to your account');
    socket.onConnect((data) {
      // the code inside runs when a user signs into the socket server
      socket.on('message', (msg) {
        print('received message from the other user');

        for (var obj in msg) {
          setMessage('destination', obj['message']);
          scrollToBottom();
        }
      });
    });

    socket.on('disconnect', (_) => print('disconnected'));
  }

  void saveListOfMessages() {
    List<String> spList = messages
        .map((MessageModel message) => json.encode(message.toMap()))
        .toList();
    // concatenated unique key of the active user and the other user
    String uniqueKey = widget.activeUser.userID + widget.otherUser.userID;
    sp.setStringList(uniqueKey, spList);
  }

  void loadListOfMessages() {
    String uniqueKey = widget.activeUser.userID + widget.otherUser.userID;
    List<String> spList = sp.getStringList(uniqueKey);
    messages = spList
        .map((String message) => MessageModel.fromMap(json.decode(message)))
        .toList();
    setState(() {});
  }

  void initSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    String uniqueKey = widget.activeUser.userID + widget.otherUser.userID;
    // necessary key check or else console throws an error
    if (sp.containsKey(uniqueKey)) {
      loadListOfMessages();
    }
  }

  /// clears all messages between you and the other user
  void clearMessages() {
    String uniqueKey = widget.activeUser.userID + widget.otherUser.userID;
    if (sp.containsKey(uniqueKey)) {
      sp.remove(uniqueKey);
    }

    messages.clear();
    setState(() {});
  }

  @override
  void initState() {
    print('entering chat with ${widget.otherUser.name}');
    initSharedPreferences();
    print('there are ${messages.length} messages in the chat');
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      child: Image.asset(
                        'assets/images/baby_yoda.jpg',
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUser.name,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "last seen today at 12:05",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),
                PopupMenuButton<Options>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    switch (value) {
                      case Options.CLEAR_MESSAGES:
                        clearMessages();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("Clear all messages"),
                        value: Options.CLEAR_MESSAGES,
                      ),
                      // PopupMenuItem(
                      //   child: Text("View Contact"),
                      //   value: "View Contact",
                      // ),
                      // PopupMenuItem(
                      //   child: Text("Media, links, and docs"),
                      //   value: "Media, links, and docs",
                      // ),
                      // PopupMenuItem(
                      //   child: Text("Search"),
                      //   value: "Search",
                      // ),
                      // PopupMenuItem(
                      //   child: Text("Mute Notification"),
                      //   value: "Mute Notification",
                      // ),
                      // PopupMenuItem(
                      //   child: Text("Wallpaper"),
                      //   value: "Wallpaper",
                      // ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // messages from both yourself and the other person will be here
                Container(
                  height: MediaQuery.of(context).size.height - 110,
                  child: ListView.builder(
                    controller: sc,
                    itemCount: messages.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // offset for the most recent message to be
                      // visible without manually scrolling up to see it
                      if (index == messages.length) {
                        return Container(
                          height: 60,
                        );
                      }

                      // your own message will be aligned to the right of the screen
                      if (messages[index].type == 'source') {
                        print(messages.length);
                        return OwnMessageBubble(
                          message: messages[index].message,
                          time: messages[index].time,
                        );
                      }

                      // the other person's will be aligned to the left of the screen
                      return ReplyBubble(
                        message: messages[index].message ?? 'null message',
                        time: messages[index].time ?? 'null time',
                      );
                    },
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  // row will be at the bottom of the screen
                  child: Container(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
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
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, right: 2),
                              child: CircleAvatar(
                                radius: 25,
                                child: IconButton(
                                  onPressed: () {
                                    if (controller.text.isEmpty) {
                                      print('cannot send blank text');
                                      return;
                                    }
                                    scrollToBottom();
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    sc.dispose();

    print('you have signed out of your account');
    socket.emit('signedout', widget.activeUser.userID);
    // socket.close() gave an error, so I commented it out
    socket.dispose();
  }
}
