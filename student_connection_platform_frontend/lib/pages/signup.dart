import 'package:student_connection_platform_frontend/pages/SignupSections/AccountDetails.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserOverview.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserDetails.dart';
import 'package:student_connection_platform_frontend/account.dart';
import 'package:flutter/material.dart';

// Since it's still highly variable, minimize the places we'll have to change it
String appName;
// Stores all the information about the new account we're creating
Account _newAccount;

class SignupForm extends StatefulWidget {
  SignupForm(String name) {
    appName = name;
    _newAccount = new Account();
  }

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  // Holds references to the account details, user overview, and user details page widgets
  List<Widget> _pages;

  SignupFormState() {
    _pages = [
      AccountDetails(_newAccount),
      UserOverview(_newAccount),
      UserDetails(_newAccount)
    ];
  }

  // 0 - account details, 1 - user overview, 2 - user details
  int _currentPage = 0;

  final AssetImage _emptyDotAsset =
      new AssetImage('assets/images/EmptyDot.png');
  final AssetImage _fullDotAsset =
      new AssetImage('assets/images/FilledDot.png');

  Future<void> _showFailedSubmissionDialog(bool pageSubmission) async {
    // Either page submission or account submission (pageSubmission = false)
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return pageSubmission
            ?
            //pageSubmission = true
            AlertDialog(
              titleTextStyle: ,
                title: Text("Incomplete Information!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'This page still has information that hasn\'t been completed.\n'),
                      Text('Make sure to fill out every field of this form!'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            :

            //pageSubmission = false
            AlertDialog(
                title: Text("Account Submission Failed!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'There was an error submitting your account to the system.\n'),
                      Text(
                          'Check that all your account information is valid as specified.\n'),
                      Text('If this issue persists, try again later.')
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
      },
    );
  }

  bool _submitAccount() {
    // TODO: Submit to DB

    return true;
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_newAccount.validAccountDetails()) {
        _currentPage++;
      } else {
        _showFailedSubmissionDialog(true);
      }
    } else if (_currentPage == 1) {
      if (_newAccount.validUserOverview()) {
        _currentPage++;
      } else {
        _showFailedSubmissionDialog(true);
      }
    } else {
      if (_newAccount.validUserDetails()) {
        if (_submitAccount()) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/ContentFrame');
        } else {
          _showFailedSubmissionDialog(false);
        }
      } else {
        _showFailedSubmissionDialog(true);
      }
    }
  }

  void _previousPage() {
    if (_currentPage == 0) {
      Navigator.pop(context);
    } else {
      _currentPage--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _pages[_currentPage],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Backwards button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _previousPage();
                      });
                    },
                    child: Image(
                      image: AssetImage('assets/images/BackwardsButton.png'),
                      width: 50,
                      height: 50,
                    ),
                  ),

                  SizedBox(
                    width: 25,
                  ),

                  // Page tracker dots
                  Image(
                    image: _currentPage == 0 ? _fullDotAsset : _emptyDotAsset,
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 15,
                  ),

                  Image(
                    image: _currentPage == 1 ? _fullDotAsset : _emptyDotAsset,
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 15,
                  ),

                  Image(
                    image: _currentPage == 2 ? _fullDotAsset : _emptyDotAsset,
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 25,
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _nextPage();
                      });
                    },
                    child: Image(
                      image: AssetImage('assets/images/ForwardsButton.png'),
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
