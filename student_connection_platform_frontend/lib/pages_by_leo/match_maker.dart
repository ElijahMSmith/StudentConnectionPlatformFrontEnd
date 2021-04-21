import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/matchmaker_stack.dart';
import 'animated_card.dart';
import '../account.dart';

Account _userAccount;

class MatchMaker extends StatelessWidget // should be cardstack.dart
{
  static const String routeId = 'match_maker';

  MatchMaker(Account userAccount) {
    _userAccount = userAccount;
  }

  @override
  Widget build(BuildContext context) {
    // provider instantiation
    final users = Provider.of<MatchMakerStack>(context).usersStack;

    // Center(child: Container(child: Text('blank')));
    return users.isEmpty
        ? outofCardsDisplay()
        // LIFO stack ordering (i.e. value at index 0 will be shown last and value at index n - 1 will be shown first, where n is the size of the list)
        : Stack(children: users.map((user) => AnimatedCard(user)).toList());
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
