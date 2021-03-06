import 'package:flutter/material.dart';

/*

Defines the layout for the sign in page of the app
Users can input an email or username to the first blank and a password to the second
When the click the login button, it will validate those fields against the database
  If the credentials don't work, clear the fields and show the hidden text saying it was invalid
  If the credentials DO work, do whatever other login information is necessary and move to content page

*/

String _appName;

class SigninForm extends StatefulWidget {
  SigninForm(String appName) {
    _appName = appName;
  }

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  String _usernameOrEmail;
  String _password;
  bool _storeLoginInfo = false; // TODO: Get/set in local storage

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
              children: [
                // Welcome message
                Text('Welcome!',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 2.0)),

                // Welcome description
                Text('Log in using the fields below',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 1.5)),

                // Validation error text: Hidden until login attempt fails
                Text(
                    'The login information provided didn\'t match anything in our system.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 1.5)),

                // Username or email field - will validate against database
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  //validator: (value) {return x},
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your username or password',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _usernameOrEmail = value;
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                // Password field - will validate against database
                TextFormField(
                  validator: (value) {},
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your password',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                // Checkbox for retaining login information for next session
                Row(
                  children: [
                    Checkbox(
                      value: _storeLoginInfo,
                      onChanged: (value) {
                        _storeLoginInfo = value;
                      },
                    ),
                    Text(
                      'Remember my last login',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),

                SizedBox(
                  height: 24,
                ),

                TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: Text('Log in'),
                  onPressed: () {
                    // Checks the input fields are not empty
                    var valid = _formKey.currentState.validate();
                    if (!valid) return;

                    // TODO: Validate against database
                    // Show failure text and clear inputs if validation fails
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
//Validate form data when button is pressed
onPressed: () {
  // Validate the form by getting the FormState from the GlobalKey
  // and calling validate() on it.
  var valid = _formKey.currentState.validate();
  if (!valid) {
    return;
  }

  //Do our other stuff
},

*/
