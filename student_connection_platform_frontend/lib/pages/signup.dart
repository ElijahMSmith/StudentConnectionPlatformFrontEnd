import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/AccountDetails.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserOverview.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/UserDetails.dart';

// Once finished on signup:
// Navigator.pop(context) - pop the current page off the Navigator stack
// Navigator.pushNamed(context, '/ContentFrame');

// Allow passing back of info from each individual sigup page
// This signup.dart should add one page to stack individually and get back based on which button pressed (forwards, backwards)
// https://flutter.dev/docs/cookbook/navigation/returning-data

String _appName;

class SignupForm extends StatefulWidget {
  SignupForm(String appName) {
    _appName = appName;
  }

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // Create widgets for each page - write accessors to getting their data
  // Make a current page tracker count - display a different page depending on which widget is pressed
  // When button is pressed, validate if current page is complete. If so, can more forwards. Can always move back.
  // Each page keeps its data when transitioning pages. Eventually make this transition an animation.

  List<Widget> _pages = [
    AccountDetails(_appName),
    UserOverview(_appName),
    UserDetails(_appName)
  ];

  // 0 - account details, 1 - user overview, 2 - user details
  int _currentPage = 0;

  final AssetImage _emptyDotAsset =
      new AssetImage('assets/images/EmptyDot.png');
  final AssetImage _fullDotAsset =
      new AssetImage('assets/images/FilledDot.png');

  bool _submitAccount() {
    // TODO - at this point all widgets should have valid account information
    // Just a question of how to access it here.
    return true;
  }

  void _nextPage() {
    if (_currentPage == 2) {
      if (_submitAccount()) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/ContentFrame');
      } else {
        print("Submission Failed!");
      }
    } else {
      _currentPage++;
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
                    onTap: () {},
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
                    onTap: _nextPage,
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
