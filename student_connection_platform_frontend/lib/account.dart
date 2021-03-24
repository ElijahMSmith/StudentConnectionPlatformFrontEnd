import 'dart:io';

class Account {
  // Validation and setting values handled by forms, so leaving these public
  String email = "";
  String password = "";
  String dateOfBirth = "";

  File profilePicture;
  String username = "";
  String bio = "";

  String city = "";
  String country = "";
  String school = "";
  String major = "";
  List<String> interests = [];
}
