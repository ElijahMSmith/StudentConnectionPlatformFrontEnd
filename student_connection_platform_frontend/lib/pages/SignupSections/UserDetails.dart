import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String _appName;
List<String> _allInterests = [
  "Hobbies and interests list not loaded. Sorry!"
]; //Remove default if load successful in method below

int loadCount = 0;

void loadHobbiesAndInterests() async {
  print("Running");

  final file = File('assets/hobbies_interests.txt');
  Stream<String> lines = file
      .openRead()
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()); // Convert stream to individual lines.
  try {
    await for (var line in lines) {
      _allInterests.add(line);
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  _allInterests.removeAt(0);

  loadCount++;
}

class UserDetails extends StatefulWidget {
  UserDetails(String appName) {
    _appName = appName;
    loadHobbiesAndInterests();
    print("Constructor");
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
  List<String> _personalInterests = [];

  @override
  Widget build(BuildContext context) {
    print("Builder");
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            Container(
              width: 400,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 190,
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      maxLength: 25,
                      decoration:
                          InputDecoration(filled: true, hintText: 'City'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 190,
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      maxLength: 25,
                      decoration:
                          InputDecoration(filled: true, hintText: 'Country'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // School and major
            Text('University Information',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 10),
            Container(
              width: 400,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 190,
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      maxLength: 25,
                      decoration: InputDecoration(
                          filled: true, hintText: 'University Name'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 190,
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      maxLength: 25,
                      decoration: InputDecoration(
                          filled: true, hintText: 'Field of Study'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // School and major
            Text('List size = ${_allInterests.length}, loadCount = $loadCount',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            // Interests and Hobbies
          ],
        ),
      ),
    );
  }
}
