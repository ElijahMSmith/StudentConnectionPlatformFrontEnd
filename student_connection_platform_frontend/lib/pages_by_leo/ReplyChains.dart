// TODO possibly let the wrapper of reply chains inherit from flutter's ModalRoute class to become a custom popup

import 'package:flutter/material.dart';

class DMChatSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: Text('Return'),
              ),

              // TODO Will probably need to change to a listview builder for dynamic behavior
              Container(
                  child: Column(children: <Widget>[
                Text('Parent Reply'),
                Row(children: <Widget>[
                  TextButton(onPressed: () {}, child: Text('Reply')),
                  TextButton(onPressed: () {}, child: Text('Delete')),
                ])

                // ETC.
              ])),
              // bio text
              Container(child: SelectableText('Block this person')),

              Container(child: SelectableText('Clear this chat of messages')),

              Container(
                  child: GestureDetector(
                onTap: () {
                  print('return to DMs!');
                },
                child: Text('Close'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
