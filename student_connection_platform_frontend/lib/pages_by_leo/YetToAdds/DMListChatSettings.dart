import 'package:flutter/material.dart';

class DMChatSettingsPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(child: SelectableText('Hide this chat')),

              Container(
                  child: SelectableText(
                      "Show 'unfollow' if already following. Otherwise, show 'follow'")),
              // bio text
              Container(child: SelectableText('Block this person')),

              Container(child: SelectableText('Clear this chat of messages')),

              Container(
                  child: GestureDetector(
                onTap: ()
                {
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
