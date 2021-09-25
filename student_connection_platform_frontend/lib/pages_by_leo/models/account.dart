import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UserAccounts with ChangeNotifier {
  List<Account> _users = [];

  List<Account> _usersStack = [];

  List<Account> get users {
    return [..._users];
  }

  List<Account> get usersStack {
    return [..._usersStack];
  }

  void loadUsersStack() {
    _usersStack = [..._users];
    notifyListeners();
  }

  void deleteFromStack(String id) {
    _users.removeWhere((user) => user.userID == id);
    notifyListeners();
  }
}

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
  String? userID;

  File? profilePicture;
  AssetImage defaultPicture = AssetImage("assets/images/emptyProfileImage.png");
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

  List<String> matchIDs = [];
  List<Account> matchedUsers = [];
  Account.empty();

  Account.fromLoginRequest(String responseBody) {
    print("Login received\n");
    Map<String, dynamic> values = jsonDecode(responseBody);

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
    matchIDs = user["matches"] == Null ? [] : user["matches"].cast<String>();

    print("Trying to get matches\n");
    for (String id in matchIDs) {
      print("Trying to retrieve match '$id'");
      Account currentMatch = new Account.empty();

      http.get(Uri.parse("https://t3-dev.rruiz.dev/api/users/$id"), headers: {
        "Content-Type": "application/json"
      }).then((matchedResponse) => {
            // print(matchedResponse.statusCode),
            // print("Retrieved match account: '${matchedResponse.body}'\n"),
            values = jsonDecode(matchedResponse.body),

            currentMatch.name = values["name"] ?? "",
            currentMatch.username = values["username"] ?? "",
            currentMatch.email = values["email"] ?? "",
            currentMatch.age = values["age"] ?? 18,
            currentMatch.userID = values["id"] ?? "",
            currentMatch.job = values["job"] ?? "",
            currentMatch.bio = values["bio"] ?? "",
            currentMatch.city = values["city"] ?? "",
            currentMatch.country = values["country"] ?? "",
            currentMatch.school = values["school"] ?? "",
            currentMatch.major = values["major"] ?? "",

            currentMatch.interests = values["interests"] == Null
                ? []
                : values["interests"].cast<String>(),
            // We don't currently care about THEIR matches. Might change with a future feature
            currentMatch.matchIDs = values["matches"] == Null
                ? []
                : values["matches"].cast<String>(),

            matchedUsers.add(currentMatch)
          });
    }
  }

  Account.fromUserRequest(Map<String, dynamic> values) {
    name = values["name"] ?? "";
    username = values["username"] ?? "";
    email = values["email"] ?? "";
    age = values["age"] ?? 18;
    userID = values["id"] ?? "";
    job = values["job"] ?? "";
    bio = values["bio"] ?? "";
    city = values["city"] ?? "";
    country = values["country"] ?? "";
    school = values["school"] ?? "";
    major = values["major"] ?? "";
    interests =
        values["interests"] == Null ? [] : values["interests"].cast<String>();
    matchIDs =
        values["matches"] == Null ? [] : values["matches"].cast<String>();

    // print("Pulled '$username' from GET");
  }

  Future<http.Response> submitAccountChanges() {
    String bodyJSON = jsonEncode(<String, dynamic>{
      "interests": jsonEncode(interests),
      "matches": jsonEncode(matchIDs),
      "name": name,
      "username": username,
      "email": email,
      "age": age,
      "password": password,
      "bio": bio,
      "school": school,
      "major": major,
      "job": job,
      "country": country,
      "city": city
    });

    return http.put(Uri.parse("https://t3-dev.rruiz.dev/api/users/" + userID!),
        headers: {"Content-Type": "application/json"}, body: bodyJSON);
  }

  Future<http.Response> checkUsernameUnique() {
    return http.get(
        Uri.parse("https://t3-dev.rruiz.dev/api/users/username/" + username),
        headers: {"Content-Type": "application/json"});
  }

  Future<http.Response> createMatchWith(Account otherUser) async {
    return await http.post(
        Uri.parse(
            "https://t3-dev.rruiz.dev/api/users/$userID/match/${otherUser.userID}"),
        headers: {"Content-Type": "application/json"});
  }

  Future<http.Response> deleteMatchWith(Account otherUser) async {
    return await http.delete(
        Uri.parse(
            "https://t3-dev.rruiz.dev/api/users/$userID/match/${otherUser.userID}"),
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
    return "Email: $email\nUsername: $username\nName: $name\nBio: $bio\nID: $userID\n" +
        "DOB: $dateOfBirth\nJob: $job\nCity: $city\nCountry $country\n" +
        "Major: $major\nSchool: $school\nInterests: '${interests.toString()}'\nMatches: '${matchIDs.toString()}'";
  }
}
