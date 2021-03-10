import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget> [
                    // for picture and text
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('please profile pic here')
                        ),

                        Text('User\'s settings')
                      ],
                    ),

                    // bio text
                    Container(
                      child: SelectableText(
                        'Enter bio here'
                      )
                    ),

                    // log out button
                    RaisedButton(onPressed: () => print('log out')),

                  ],
                ),
        ),
      ),

      // https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
      // https://www.youtube.com/watch?v=elLkVWt7gRM&ab_channel=ProgrammingAddict
      bottomNavigationBar: BottomNavigationBar(items:
      const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Post'),

          BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat'),

          BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search'),

          BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings'),

      ]),
    );
  }
}
