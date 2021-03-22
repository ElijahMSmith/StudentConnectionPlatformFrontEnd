import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

String _appName;

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
  UserDetails(String appName) {
    _appName = appName;
    loadHobbiesAndInterests();
  }

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

/*
Still need:
- City and country
- School and major
- Current job
- Interests (hobbies_interests.txt - sorted alphabetically)
    - https://pub.dev/packages/autocomplete_textfield
*/

class _UserDetailsState extends State<UserDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _city;
  String _country;
  String _school;
  String _major;
  String _job;
  List<String> _addedInterests = [];
  String test = "";

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
        if (_addedInterests.length >= 10) return;
        if (_addedInterests.contains(text)) return;

        int find = _allInterestsComparable.indexOf(text.toLowerCase());
        if (find == -1) return;

        _addedInterests.add(_allInterests[find]);
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
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration:
                          InputDecoration(filled: true, hintText: 'City'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration:
                          InputDecoration(filled: true, hintText: 'Country'),
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
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true, hintText: 'University Name'),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true, hintText: 'Field of Study'),
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
                        itemCount: _addedInterests.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              '${_addedInterests[index]}',
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
