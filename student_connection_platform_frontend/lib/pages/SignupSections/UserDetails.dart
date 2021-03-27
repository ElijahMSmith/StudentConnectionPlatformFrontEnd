import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:student_connection_platform_frontend/account.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'dart:async';

Account _newAccount;

List<String> _allInterests = [
  "Hobbies and interests list not loaded. Sorry!"
]; //Remove default if load successful in method below

List<String> _allInterestsComparable = [
  //All lower case
];

Future<String> loadInterests() async {
  return await rootBundle.loadString('assets/textFiles/hobbies_interests.txt');
}

void loadHobbiesAndInterests() async {
  loadInterests().then((String result) => {
        _allInterests = result.split("\n"),
        _allInterestsComparable = result.toLowerCase().split("\n"),
      });
}

class UserDetails extends StatefulWidget {
  static String routeID = "/UserDetails";

  UserDetails(Account account) {
    _newAccount = account;
    loadHobbiesAndInterests();
  }

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<AutoCompleteTextFieldState<String>> _textFieldKey = new GlobalKey();
  SimpleAutoCompleteTextField _textField;
  String currentText = "";

  _UserDetailsState() {
    _textField = SimpleAutoCompleteTextField(
      key: _textFieldKey,
      decoration: InputDecoration(
          filled: true,
          hintText: 'Pick 5-10 of your favorite interests/hobbies.'),
      suggestions: _allInterests,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (_newAccount.interests.length >= 10) return;
        if (_newAccount.interests.contains(text)) return;

        int find = _allInterestsComparable.indexOf(text.toLowerCase());
        if (find == -1) return;

        _newAccount.interests.add(_allInterests[find]);
        if (_newAccount.interests.length >= 5 &&
            _newAccount.interests.length <= 10)
          _newAccount.validInterests = true;
        else
          _newAccount.validInterests = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 25),
            Text('Almost Done!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(height: 25),

            // Location
            Text('Where are you from?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      initialValue: _newAccount.city,
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        _newAccount.validCity = true;
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration:
                          InputDecoration(filled: true, hintText: 'City'),
                      onChanged: (value) {
                        _newAccount.validCity = false;
                        _newAccount.city = value;
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      initialValue: _newAccount.country,
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        _newAccount.validCountry = true;
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration:
                          InputDecoration(filled: true, hintText: 'Country'),
                      onChanged: (value) {
                        _newAccount.validCity = false;
                        _newAccount.country = value;
                      },
                    ),
                  ),
                ),
              ],
            ),

            // School and major
            Text('Where do you go to school?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      initialValue: _newAccount.school,
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        _newAccount.validSchool = true;
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true, hintText: 'University Name'),
                      onChanged: (value) {
                        _newAccount.validSchool = false;
                        _newAccount.school = value;
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      initialValue: _newAccount.major,
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        _newAccount.validMajor = true;
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true, hintText: 'Field of Study'),
                      onChanged: (value) {
                        _newAccount.validMajor = false;
                        _newAccount.major = value;
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Interests and Hobbies
            // School and major
            Text('What interests you?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: _textField,
                    ),
                  ),
                ]),
                Scrollbar(
                  isAlwaysShown: true,
                  child: Container(
                      width: 300,
                      height: 200,
                      child: ListView.builder(
                        itemCount: _newAccount.interests.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              '${_newAccount.interests[index]}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
