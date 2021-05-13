import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/matchmaker_stack.dart';
import 'navigator.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages_by_leo/models/account.dart';

final String appName = "NameTBD";

// Will be updated with filled version when signin or signup finishes
Account _userAccount = Account.empty();


/*
two accounts to use for testing chat functionality
dummy04 Dumdum1!
dummy05 Dumdum1!
*/

void main()
{
  runApp(AppHome());
}

class AppHome extends StatelessWidget
{
  void updateAccount(Account newAccount)
  {
    _userAccount = newAccount;
  }

  @override
  Widget build(BuildContext context)
  {
    // We must have change notifier provider at the top
    // of the tree in order for this line: final users = Provider.of<Users>(context).users;
    // to work.
    return ChangeNotifierProvider.value(
      value: MatchMakerStack(),
      child: MaterialApp(
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: SigninForm.routeID,
          routes: {
            //use static strings for the route id as a way to avoid typos
            SigninForm.routeID: (context) => SigninForm(appName, this),
            SignupForm.routeID: (context) => SignupForm(appName, this),
            NavigationHelperWidget.routeID: (context) =>
                NavigationHelperWidget(_userAccount),
          }),
    );
  }
}
