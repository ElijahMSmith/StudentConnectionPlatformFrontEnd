import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/matchmaker_stack.dart';
import 'package:http/http.dart' as http;
import 'animated_card.dart';
import '../account.dart';

Account _activeUser;
List<Account> allUsers = []; // TODO later: Fix this as essentially a second stack
List<dynamic> parsedBody;

class MatchMaker extends StatelessWidget // should be cardstack.dart
{
  static const String routeId = 'match_maker';

  void removeMatchedUser(Account user) {
    allUsers.removeWhere((element) => element.userID == user.userID);
  }

  MatchMaker(Account activeUser) {
    _activeUser = activeUser;
    
    http.get(Uri.parse("https://t3-dev.rruiz.dev/api/users/"), headers: {
      "Content-Type": "application/json"
    }).then((resp) => {
      parsedBody = jsonDecode(resp.body),
      for (int i = 0; i < parsedBody.length; i++)
      {
        // If the id of this particular user is contained in the matches of the active user, ignore it
        // If the active user IS this user, ignore it
        // Otherwise, add it to the card stack
        if (!_activeUser.matchIDs.contains(parsedBody[i]["id"]) &&
            !(_activeUser.userID == parsedBody[i]["id"]))
          allUsers.add(Account.fromUserRequest(parsedBody[i]))
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // provider instantiation
    final users = Provider.of<MatchMakerStack>(context);
    users.loadStackFromList(allUsers);

    // Center(child: Container(child: Text('blank')));
    return users.isEmpty()
        ? outofCardsDisplay()
        // LIFO stack ordering (i.e. value at index 0 will be shown last and value at index n - 1 will be shown first, where n is the size of the list)
        : Stack(
            children: users.usersStack
                .map(
                    (randomUser) => AnimatedCard(randomUser, _activeUser, this))
                .toList());
  }
}

Widget outofCardsDisplay() {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.perm_identity,
              size: 100,
              color: Colors.lightBlue,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Out of Cards :(",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
