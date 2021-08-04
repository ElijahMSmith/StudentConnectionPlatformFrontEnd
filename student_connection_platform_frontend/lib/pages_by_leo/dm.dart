import 'dart:convert';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_connection_platform_frontend/Utility.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/OwnMessageBubble.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/reply_message_bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'models/MessageModel.dart';
import 'models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profanity_filter/profanity_filter.dart';

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

  //? this pattern can be built upon for filtering out more curse words and misspelled variations of curse words that aren't handled by the profanity filter package
  final String pattern = r"([FfSs]uck)|(fu)|(fagot)|(d[iy]ke)";
  SharedPreferences sp;
  Options options;
  FocusNode msgField;
  bool show = false;
  ProfanityFilter filter;
  RegExp profanityRegex;
  String uniqueKey;

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
    ChatMessageSaveUtil.saveListOfMessages(uniqueKey, messages);
    setState(() {});
  }

  // scrolls the list view to the bottom of everytime a new message is sent
  void scrollToBottom({int milliseconds = 300}) {
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
          // scrollToBottom();
        }
      });
      scrollToBottom();
    });

    socket.on('disconnect', (_) => print('disconnected'));
  }

  void getMessagesFromPrefs() async {
    var stringList = await ChatMessageSaveUtil.loadListOfMessages(uniqueKey);
    if (stringList == null) {
      print('there was no list of messages saved in prefs for this chat');
    } else {
      messages = stringList
          .map((String message) => MessageModel.fromMap(json.decode(message)))
          .toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // print('entering chat with ${widget.otherUser.name}');
    // concatenated unique key of the active user and the other user
    uniqueKey = widget.activeUser.userID + widget.otherUser.userID;
    getMessagesFromPrefs();

    // print('there are ${messages.length} messages in the chat');
    filter = ProfanityFilter();
    // print('list of curse words: ${filter.wordsToFilterOutList}');
    // print(filter.wordsToFilterOutList.length);
    profanityRegex = RegExp(pattern, caseSensitive: false, multiLine: false);
    connect();
    msgField = FocusNode();
    msgField.addListener(() {
      if (msgField.hasFocus) {
        show = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    sc.dispose();
    msgField.dispose();

    // print('you have signed out of your account');
    socket.emit('signedout', widget.activeUser.userID);
    // socket.close() gave an error, so I commented it out
    socket.dispose();
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
                        ChatMessageSaveUtil.clearMessages(
                          uniqueKey,
                        );
                        messages.clear();
                        setState(() {});
                        break;
                    }
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("Clear all messages"),
                        value: Options.CLEAR_MESSAGES,
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              onWillPop: () {
                if (show) {
                  setState(() {
                    print('wont pop');
                    show = false;
                  });
                } else {
                  print('here about to pop');
                  Navigator.pop(context, false);
                }

                print('here i am');
                return Future.value(false);
              },
              child: Column(
                children: [
                  // messages from both yourself and the other person will be here
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: sc,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        // offset for the most recent message to be
                        // visible without manually scrolling up to see it
                        if (index == messages.length) {
                          return Container(
                            height: 35,
                          );
                        }
                        // your own message will be aligned to the right of the screen
                        if (messages[index].type == 'source') {
                          // print(messages.length);
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
                                width: MediaQuery.of(context).size.width - 60,
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
                                    autofocus: true,
                                    focusNode: msgField,
                                    controller: controller,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Please type a message',
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          show
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!show) {
                                            msgField.unfocus();
                                            msgField.canRequestFocus = false;
                                          }
                                          show = !show;
                                          print('show: $show');
                                          setState(() {});
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) {
                                                    return bottomSheet();
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, right: 2, left: 2),
                                child: CircleAvatar(
                                  radius: 25,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.text.isEmpty) {
                                        print('cannot send blank text');
                                        return;
                                      }
                                      if (profanityRegex
                                              .hasMatch(controller.text) ||
                                          filter
                                              .hasProfanity(controller.text)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please do not type any profanity",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
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
                  show ? emojiSelect() : Container()
                ],
              ),
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ],
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          // print(emoji);
          controller.text = '${controller.text}${emoji.emoji}';
          setState(() {});
        });
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
