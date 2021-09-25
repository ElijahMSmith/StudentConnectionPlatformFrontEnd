import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/models/account.dart';
import 'package:student_connection_platform_frontend/navigator.dart';
import 'package:student_connection_platform_frontend/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:student_connection_platform_frontend/push_notifications/notification_api.dart';
import 'package:student_connection_platform_frontend/speech_to_text/speech_to_text.dart';
import '../main.dart';

// Reference to the name of the app, when we decide on one
String? _appName;
// Local device storage
SharedPreferences? prefs;
// Reference to the page controller
AppHome? _homeController;

class SigninForm extends StatefulWidget {
  static const String routeID = '/';

  SigninForm(String appName, AppHome homeController) {
    _appName = appName;
    _homeController = homeController;
  }

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();

  bool _storeLoginInfo = false;
  String? _username;
  String? _password;
  bool _validationFailed = false;
  bool _otherError = false;
  bool _showLoginTimeout = false;
  int _loginAttempts = 0;

  final textDetector = GoogleMlKit.vision.textDetector();
  final inputImage = InputImage.fromFile(File('assets/images/text.jpg'));

  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenToNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    textDetector.close();
  }

  void listenToNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String payload) {
    print('clicked on notification!');
  }

  _SigninFormState() {
    _getSharedPrefs();
  }

  _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _storeLoginInfo = prefs!.getBool("storeLoginInfo") ?? false;
    print("SP loaded store as $_storeLoginInfo\n");
    if (_storeLoginInfo) {
      setState(() {
        _username = prefs!.getString("usernameOrEmail");
        _password = prefs!.getString("password");
      });
    }
  }

  _attemptSignin() async {
    if (_loginAttempts >= 5) {
      //If we've already timed out previously, don't start the timeout again
      if (_showLoginTimeout) return;

      // Remove any current error messages and show timeout message instead
      _otherError = false;
      _validationFailed = false;
      _showLoginTimeout = true;

      // After one minute, let them try again
      await Future.delayed(const Duration(milliseconds: 60000), () {
        setState(() {
          _showLoginTimeout = false;
          _loginAttempts = 0;
        });
      });
      return;
    }

    String bodyJSON = jsonEncode(
        <String?, String?>{"username": _username, "password": _password});

    final response = await http.post(
        Uri.parse("https://t3-dev.rruiz.dev/api/login"),
        headers: {"Content-Type": "application/json"},
        body: bodyJSON);

    _validationFailed = false;
    _otherError = false;

    // print(response.body);

    if (response.statusCode == 200) {
      // Successful login

      Account user = new Account.fromLoginRequest(response.body);

      // TODO: What do I do with the JWT (_responseBody["token"])?

      // Successful login
      Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          backgroundColor: Colors.greenAccent,
          fontSize: 16.0);

      _homeController!.updateAccount(user);

      Navigator.pushNamed(context, NavigationHelperWidget.routeID);

      return;
    } else if (response.statusCode == 401) {
      // Failed login
      setState(() {
        _validationFailed = true;
      });
    } else {
      // Other error
      setState(() {
        _otherError = true;
      });
    }

    _loginAttempts++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign in to $_appName")),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                // Welcome message
                Text('Welcome!',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),

                SizedBox(
                  height: 5,
                ),

                // Welcome description
                Text('Log in using the fields below',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),

                SizedBox(
                  height: 10,
                ),

                // Validation error text: Hidden until login attempt fail
                Visibility(
                  visible: _validationFailed || _otherError,
                  child: Text(
                      _validationFailed
                          ? 'We couldn\'t find a user with that login information.'
                          : 'An error occurred while trying to log you in.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.red)),
                ),

                // Login timeout error text: Hidden until login attempts time out
                Visibility(
                  visible: _showLoginTimeout,
                  child: Text(
                      'You\'re doing that too much.\nPlease wait 60s and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.red)),
                ),

                // Adds extra padding below error message when it shows
                Visibility(
                    visible:
                        _validationFailed || _otherError || _showLoginTimeout,
                    child: SizedBox(height: 10)),

                // Username or email field - will validate against database
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) return 'Please enter your username';
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your username',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _username = value;
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                // Password field - will validate against database
                TextFormField(
                  validator: (value) {
                    if (value == null) return 'Please enter a password';
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your password',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: true,
                ),

                SizedBox(
                  height: 24,
                ),

                // Checkbox for retaining login information for next session
                FormField(
                  initialValue: _storeLoginInfo,
                  builder: (FormFieldState formFieldState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _storeLoginInfo,
                              onChanged: (value) {
                                formFieldState.didChange(value);
                                setState(() {
                                  _storeLoginInfo = value!;
                                  prefs!.setBool("storeLoginInfo", value);
                                });
                              },
                            ),
                            Text(
                              'Remember my last login',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      ],
                    );
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Log in'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      // Checks the input fields are not empty
                      var valid = _formKey.currentState!.validate();
                      if (!valid) return;

                      setState(() {
                        prefs!.setString("username", _username!);
                        prefs!.setString("password", _password!);

                        _attemptSignin();
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Sign up'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      Navigator.pushNamed(context, SignupForm.routeID);
                    },
                  ),
                ),

                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => TextRecognitionWidget(),
                //         ),
                //       );
                //     },
                //     child: Text('Image recognition test')),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => SpeechScreen(),
                //       ),
                //     );
                //   },
                //   child: Text('microphone test'),
                // ),

                // ElevatedButton(
                //   onPressed: () {
                //     NotificationApi.showNotification(
                //       title: 'date plans',
                //       body: 'Hey babe, what are we doing tonight? I miss you',
                //       payload: 'Sarah',
                //     );
                //   },
                //   child: Text('simple notification test'),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     await NotificationApi.showScheduledDailyNotification(
                //       title: 'date plans',
                //       body: 'Hey babe, what are we doing tonight? I miss you',
                //       payload: 'Sarah',
                //       time: Time(0,29),
                //     );
                //   },
                //   child: Text('scheduled notification test'),
                // ),

                ElevatedButton(
                  onPressed: () async {
                    final RecognisedText recognisedText =
                        await textDetector.processImage(inputImage);

                    String text = recognisedText.text;
                    print(text);
                    // for (TextBlock block in recognisedText.blocks) {
                    //   final Rect rect = block.rect;
                    //   final List<Offset> cornerPoints = block.cornerPoints;
                    //   final String text = block.text;
                    //   final List<String> languages = block.recognizedLanguages;

                    //   for (TextLine line in block.lines) {
                    //     print(line.text);
                    //     // Same getters as TextBlock
                    //     // for (TextElement element in line.elements) {
                    //     //   // Same getters as TextBlock
                    //     //   print(element.text);
                    //     // }
                    //   }
                    // }
                  },
                  child: Text('image-to-text test'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
