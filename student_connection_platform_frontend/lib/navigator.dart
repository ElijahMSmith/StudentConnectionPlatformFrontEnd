import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/constants.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/match_maker.dart';
import 'pages_by_leo/ContactsPage.dart';
import 'pages_by_leo/profile_page.dart';
import 'pages_by_leo/models/account.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Account? _userAccount;

// this helper widget will help avoid circular dependencies among the other dart files
class NavigationHelperWidget extends StatefulWidget {
  static const String routeID = "/UserContent";

  NavigationHelperWidget(Account? userAccount) {
    _userAccount = userAccount;
  }

  @override
  _NavigationHelperWidgetState createState() => _NavigationHelperWidgetState();
}

class _NavigationHelperWidgetState extends State<NavigationHelperWidget> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    // PostPage(),
    ProfilePage(userAccount: _userAccount),
    MatchMaker(activeUser: _userAccount),
    ContactsPage(activeUser: _userAccount),
  ];

  // void signIn() {
  //   // tell the socket server that this user has signed in
  //   socket = IO.io(ipAddyAndPortNum, <String, dynamic>{
  //     'transports': ['websocket'],
  //     // 'autoConnect': false,
  //   });
  //   socket.emit('signin', _userAccount.userID);

  //   socket.connect();
  //   print('you have signed in to your account');
  // }

  @override
  void initState() {
    super.initState();
    // signIn();
  }

  @override
  void dispose() {
    super.dispose();
    // print('you have signed out of your account');
    // socket.emit('signedout', _userAccount.userID);
    // // socket.close() gave an error, so I commented it out
    // socket.dispose();
  }

  // navigate to the page based on the index selected
  void _onItemTapped(int bottomNavButtonIndex) {
    _selectedIndex = bottomNavButtonIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],

      // https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
      // https://www.youtube.com/watch?v=elLkVWt7gRM&ab_channel=ProgrammingAddict
      bottomNavigationBar: BottomNavigationBar(
          items: ourBottomNavBar(),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped),
    );
  }
}
