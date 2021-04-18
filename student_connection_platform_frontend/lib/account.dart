import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Account {
  // Validation and setting values handled by forms, so leaving these public
  String email = "";
  bool validEmail = false;
  // Only stored for signup, removed after successful signup
  // Not stored during any other web requests
  String password = "";
  bool validPassword = false;
  String dateOfBirth = "";
  bool validDOB = false;
  int age = 18;

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

  // Signals to signup for whether we need to send another server request to check this name
  bool usernameChecked = false;

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

  List<dynamic> matchIDs = [];

  Account.empty();

  Account.fromRequest(String responseBody) {
    final values = jsonDecode(responseBody);

    name = values["name"] ?? "";
    username = values["username"] ?? "";

    final user = values["user"];

    email = user["email"] ?? "";
    age = user["age"] ?? 18;
    userID = user["id"] ?? "";
    job = user["job"] ?? "";
    bio = user["bio"] ?? "";
    city = user["city"] ?? "";
    country = user["country"] ?? "";
    school = user["school"] ?? "";
    major = user["major"] ?? "";
    interests =
        user["interests"] == Null ? [] : user["interests"].cast<String>();
    matchIDs = user["matches"] ?? [];
  }

  Future<http.Response> checkUsernameUnique() {
    return http.get(Uri.parse("https://t3-dev.rruiz.dev/api/users/" + username),
        headers: {"Content-Type": "application/json"});
  }

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

  @override
  String toString() {
    return "Email: $email\nUsername: $username\nName: $name\nID: $userID\n" +
        "DOB: $dateOfBirth\nJob: $job\nCity: $city\nCountry $country\n" +
        "Major: $major\nSchool: $school\nInterests: ${interests.toString()}\nMatches: $matchIDs";
  }
}
