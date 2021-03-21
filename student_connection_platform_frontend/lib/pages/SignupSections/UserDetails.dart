import 'package:flutter/material.dart';

String _appName;

class UserDetails extends StatefulWidget {
  UserDetails(String appName) {
    _appName = appName;
  }

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

/*
Still need:
- City and country
- School and major
- Current job
- Interests
- Date of birth (account details page preferably)
*/

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
