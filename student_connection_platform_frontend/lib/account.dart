import 'dart:io';

class Account {
  // Validation and setting values handled by forms, so leaving these public
  String email = "";
  bool validEmail = false;
  String password = "";
  bool validPassword = false;
  String dateOfBirth = "";
  bool validDOB = false;

  // Only used when pulled, not when account is created
  String userID;

  File profilePicture;
  bool validProfilePicture = false;

  String name = "";
  bool validName = false;
  String username = "";
  bool validUsername = false;
  String job = "";
  String bio = "";
  bool validBio = false;

  String city = "";
  bool validCity = false;
  String country = "";
  bool validCountry = false;
  String school = "";
  bool validSchool = false;
  String major = "";
  bool validMajor = false;
  List<String> interests = [];
  bool validInterests = false;

  bool validAccountDetails() {
    return validEmail && validPassword && validDOB;
  }

  bool validUserOverview() {
    return validProfilePicture && validName && validUsername && validBio;
  }

  bool validUserDetails() {
    return validCity &&
        validCountry &&
        validSchool &&
        validMajor &&
        validInterests;
  }
}
