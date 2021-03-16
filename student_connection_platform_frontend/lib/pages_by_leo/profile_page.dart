import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget
{
  static const String routeId = 'profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
{

  int _selectedIndex = 0;

  final aboutMe = [
    'Greetings! I am currently a Computer Science graduate student attending ',
    'The University of Central Florida. My productive spare-time ',
    'hobbies include full-stack development on web, mobile, and game applications. ',
    'I am fascinated by what machine learning can do for the society; ',
    'as a result, I am trying to get a more in-depth understanding of the application of machine learning, ',
    'and such a desire has motivated me to continue my education in graduate school. ',
    'Eventually, I would have a better understanding of the machine learning algorithms '
        'behind the scenes as I incorporate such applications & concepts into my personal projects, ',
    'and leverage such skills to contribute in the software idustry.'
  ];

  final aboutMeBuffer = StringBuffer();


  // navigate to the page based on the index selected
  // one approach is to use a switch statement on the index selected
  void _onItemTapped(int bottomNavButtonIndex)
  {
    _selectedIndex = bottomNavButtonIndex;
    setState((){});

    switch (_selectedIndex)
    {
      // todo navigate to the proper page
    }
  }

  /// initialize the buffer.
  /// Note that this method
  /// clears out any contents
  /// previously inside.
  void fillBufferFromList(StringBuffer b, List < String > l)
  {
    if (b.isNotEmpty)
    {
      b.clear();
    }

    b.writeAll(l);
  }

  SingleChildScrollView bioSection({
    Widget body = const Text('bio text'),
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),})
  {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: body
      ),
    );
  }



  @override
  Widget build(BuildContext context)
  {
    fillBufferFromList(aboutMeBuffer, aboutMe);

    return Scaffold(
      body: SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    // for picture and text
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('please profile pic here')
                          ),
                          SizedBox(width: 30),
                          Text('User\'s settings')
                        ],
                      ),
                    ),

                    // bio text
                    Container(
                      child: bioSection(body: SelectableText(
                        aboutMeBuffer.toString()
                      ))
                    ),

                    // log out button
                    RaisedButton(onPressed: () => print('log out'),child: Text('Log out'),),

                  ],

                ),
        ),
      ),

      // https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
      // https://www.youtube.com/watch?v=elLkVWt7gRM&ab_channel=ProgrammingAddict
      bottomNavigationBar: BottomNavigationBar(items:
      const <BottomNavigationBarItem>
      [
          BottomNavigationBarItem(
          backgroundColor: Colors.red,
          icon: Icon(Icons.add, color: Colors.black),
          label: 'Post'),

          BottomNavigationBarItem(
          backgroundColor: Colors.green,
          icon: Icon(Icons.chat, color: Colors.black),
          label: 'Chat'),

          BottomNavigationBarItem(
          backgroundColor: Colors.purple,
          icon: Icon(Icons.search, color: Colors.black),
          label: 'Search'),

          BottomNavigationBarItem(
          backgroundColor: Colors.pink,
          icon: Icon(Icons.settings, color: Colors.black),
          label: 'Settings'),

      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped),
    );
  }
}
