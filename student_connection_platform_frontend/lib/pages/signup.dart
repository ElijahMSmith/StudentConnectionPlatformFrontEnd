import 'package:student_connection_platform_frontend/pages/SignupSections/AccountDetails.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserOverview.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserDetails.dart';
import 'package:student_connection_platform_frontend/account.dart';
import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/profile_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Since it's still highly variable, minimize the places we'll have to change it
String appName;
// Stores all the information about the new account we're creating
Account _newAccount;

// Failed submission reasons
enum FailedSubmissionResult { INCOMPLETE_INFORMATION, BAD_REQUEST, OTHER_ERROR }

class SignupForm extends StatefulWidget {
  static String routeID = "/Signup";

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

  Future<void> _showFailedSubmissionDialog(
      FailedSubmissionResult result) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        switch (result) {
          case FailedSubmissionResult.INCOMPLETE_INFORMATION:
            {
              return AlertDialog(
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
              );
            }
            break;

          case FailedSubmissionResult.BAD_REQUEST:
            {
              return AlertDialog(
                title: Text("Signup request to servers failed!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'The information submitted to the server to sign up your account is invalid.\n'),
                      Text(
                          'If you believe this is a problem on our end, please let us know!'),
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
            }
            break;

          default: //FailedSubmissionResult.OTHER_ERROR:
            {
              return AlertDialog(
                title: Text("Account Submission Failed!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'There was an error submitting your account to the system.\n'),
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
            }
            break;
        }
      },
    );
  }

  _attemptSubmit() async {
    String bodyJSON = jsonEncode(<String, String>{
      "name": _newAccount.name,
      "username": _newAccount.username,
      "email": _newAccount.email,
      "dob": _newAccount.dateOfBirth,
      "password": _newAccount.password,
      "bio": _newAccount.bio,
      "interests": jsonEncode(_newAccount.interests),
      "school": _newAccount.school,
      "major": _newAccount.major,
      "job": _newAccount.job,
      "country": _newAccount.country,
      "city": _newAccount.city
    });

    final response = await http.post(
        Uri.parse("https://t3-dev.rruiz.dev/api/users"),
        headers: {"Content-Type": "application/json"},
        body: bodyJSON);

    if (response.statusCode == 200) {
      // Successful signup
      Fluttertoast.showToast(
          msg: "Signed up successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        // TODO: Send account to profile page (when Leo has it set up to take the account)
      });
    } else if (response.statusCode == 400) {
      // Bad request or other error
      print("Error 400 on submission:\n" + response.body);
      _showFailedSubmissionDialog(FailedSubmissionResult.BAD_REQUEST);
    } else {
      // Other error
      print(response.statusCode);
      print(response.toString());
      print(response.headers.toString());
      print(response.body);
      _showFailedSubmissionDialog(FailedSubmissionResult.OTHER_ERROR);
    }
  }

  void _nextPage() {
    print(_currentPage);
    if (_currentPage == 0) {
      if (_newAccount.validAccountDetails()) {
        _currentPage++;
      } else {
        _showFailedSubmissionDialog(
            FailedSubmissionResult.INCOMPLETE_INFORMATION);
      }
    } else if (_currentPage == 1) {
      if (_newAccount.validUserOverview()) {
        _currentPage++;
      } else {
        _showFailedSubmissionDialog(
            FailedSubmissionResult.INCOMPLETE_INFORMATION);
      }
    } else {
      if (_newAccount.validUserDetails()) {
        _attemptSubmit();
      } else {
        _showFailedSubmissionDialog(
            FailedSubmissionResult.INCOMPLETE_INFORMATION);
      }
    }
  }

  void _previousPage() {
    print(_currentPage);
    if (_currentPage == 0) {
      Navigator.pop(context);
    } else {
      _currentPage--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
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
    );
  }
}
