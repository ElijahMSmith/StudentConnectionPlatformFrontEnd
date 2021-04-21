import 'package:flutter/material.dart';
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

class DMChat extends StatefulWidget
{
  @override
  _DMChatState createState() => _DMChatState();
}


class _DMChatState extends State<DMChat>
{
  TextEditingController _controller;
  List<MessagesBubble> messages;
  IO.Socket socket;
  final String ipAddyAndPortNum = 'ws://localhost:3000'; // 192.168.1.84

  void connect()
  {
    socket = IO.io(ipAddyAndPortNum, <String, dynamic>{
      'transports' :['websocket'],
      'autoConnect' : false,
    });
    socket.connect();
    socket.onConnect((data) => print('connected'));
    print(socket.connected ? 'connected' : 'not connected');

    socket.emit('/test', 'hello there!');
  }


  // IMPORTANT!! DO NOT PASS THIS DOWN THE CONSTRUCTOR OF THIS STATEFUL WIDGET.
  // IT WILL GIVE YOU BUGS WHEN SWITCHING BETWEEN PAGES. IT TOOK ME HOURS TO FINALLY
  // FIGURE THIS OUT AFTER COUNTLESS TRIAL AND ERRORS!
  WebSocketChannel channel;

  // _DMChatState({this.channel});



    @override
  void initState()
  {
    super.initState();
    connect();
    _controller = TextEditingController();
    messages = [];
    channel = IOWebSocketChannel.connect('wss://echo.websocket.org');
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Listen for messages from the server.
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot)
              {
                if (!snapshot.hasData) return Text('No data 🥺');

                print(snapshot.data);

                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index)
                    {
                      return messages[index];
                    }),
                );
              },
            ),
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void _sendMessage()
  {
    if (_controller.text.isNotEmpty)
    {
      // Send data to the server
      channel.sink.add(_controller.text);
      messages.add(MessagesBubble(text: _controller.text));
      setState(() {});
    }

    _controller.clear();
  }

  @override
  void dispose()
  {
    // Close the WebSocket connection
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}


class MessagesBubble extends StatelessWidget
{
  final String sender;
  final String text;
  MessagesBubble({this.sender='dummy sender', this.text});


  @override
  Widget build(BuildContext context)
  {
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


