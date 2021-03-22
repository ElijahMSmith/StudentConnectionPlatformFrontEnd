import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/constants.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/dm_chat.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/match_maker.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/post_page.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/content_frame.dart';
import 'pages_by_leo/about.dart';
import 'pages_by_leo/profile_page.dart';


final String appName = "NameTBD";

void main()
{
  runApp(AppHome());
}

class AppHome extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        title: appName,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal,
        ),

        // todo I think the default page should be the match maker,
        // we could potentially have the user decide but we'll see
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
    DMChat(),
    MatchMaker(),
    ProfilePage(),
  ];

    // navigate to the page based on the index selected
  // one approach is to use a switch statement on the index selected
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
