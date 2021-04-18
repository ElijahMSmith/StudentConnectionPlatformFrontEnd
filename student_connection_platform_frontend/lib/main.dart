import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/constants.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/dm_chat.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/match_maker.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/post_page.dart';
import 'pages_by_leo/SelectContact.dart';
import 'pages_by_leo/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages_by_leo/about.dart';
import 'dart:isolate';


final String appName = "NameTBD";

// # 5C5 = 1
// # 5C1 = 5

// # nCn = 1
// # nC1 = n
// # nCk = n! / k!(n-k)!
// # nCk = nC(n-k)
// int choose(int n, int k)
// {
//     if (n < k)
//     {
//       throw new Exception('k must be less than or equal to n');
//     }
//     if (n == k) return 1;
//     if (k == 1) return n;

//     // either just take k or take both n and k
//     return choose(n, k-1) + choose(n-1, k-1);
// }

// Future<int> compute2() async
// {
//   return await compute(choose, 10, 6);
// }


void main()
{
  // int i = choose(Args(10, 6));
  // print(i);
  runApp(AppHome());
}

class AppHome extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    // We must have change notifier provider at the top
    // of the tree in order for this line: final users = Provider.of<Users>(context).users;
    // to work.
    return ChangeNotifierProvider.value(
          value: Users(),
          child: MaterialApp(
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: NavigationHelperWidget(),
          // home: AboutPage(),
          // initialRoute: ProfilePage.routeId,
          // routes:
          // {
          //   // use static strings for the route id as a way to avoid typos
          //   SigninForm.routeId: (context) => SigninForm(appName),
          //   SignupForm.routeId: (context) => SignupForm(appName),
          //   ContentFrame.routeId: (context) => ContentFrame(appName),
          //   ProfilePage.routeId: (context) => ProfilePage(),
          // }
      ),
    );
  }
}


// this helper widget will help avoid circular dependencies among the other dart files
class NavigationHelperWidget extends StatefulWidget
{
  @override
  _NavigationHelperWidgetState createState() => _NavigationHelperWidgetState();
}

class _NavigationHelperWidgetState extends State<NavigationHelperWidget>
{

  int _selectedIndex = 0;


  final List<Widget> pages =
  [
    PostPage(),
    // Connect to a WebSocket server
    // don't pass the websocket channel down this widget. Instead, declare and initialze
    // it inside
    // DMChat(),
    SelectContact(),
    MatchMaker(),
    ProfilePage(),
  ];

  // navigate to the page based on the index selected
  void _onItemTapped(int bottomNavButtonIndex)
  {
    _selectedIndex = bottomNavButtonIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context)
  {

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
