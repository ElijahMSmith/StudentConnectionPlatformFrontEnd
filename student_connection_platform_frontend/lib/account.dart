import 'dart:io';

class Account {
  // Validation and setting values handled by forms, so leaving these public
  String email = "";
  bool validEmail = false;
  String password = "";
  bool validPassword = false;
  String dateOfBirth = "";
  bool validDOB = false;

  File profilePicture;
  bool validProfilePicture = false;
  String username = "";
  bool validUsername = false;
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
    print("$validEmail && $validPassword && $validDOB");
    print("$email && $password && $dateOfBirth");
    return validEmail && validPassword && validDOB;
  }

  bool validUserOverview() {
    print("$validProfilePicture && $validUsername && $validBio");
    return validProfilePicture && validUsername && validBio;
  }

  bool validUserDetails() {
    print(
        "$validCity && $validCountry && $validSchool && $validMajor && $validInterests");
    return validCity &&
        validCountry &&
        validSchool &&
        validMajor &&
        validInterests;
  }
}
