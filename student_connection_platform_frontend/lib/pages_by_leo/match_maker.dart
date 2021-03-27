import 'package:student_connection_platform_frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'animated_card.dart';

class MatchMaker extends StatelessWidget // should be cardstack.dart
{
  static const String routeId = 'match_maker';

  @override
  Widget build(BuildContext context)
  {
    // provider instantiation
    final users = Provider.of<Users>(context).users;

    // Center(child: Container(child: Text('blank')));
    return users.isEmpty
    ? outofCardsDisplay()
    // LIFO stack ordering (i.e. value at index 0 will be shown last and value at index n - 1 will be shown first, where n is the size of the list)
    : Stack(children: users.map((user) => AnimatedCard(user)).toList());
  }
}


Widget outofCardsDisplay()
{
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
            SizedBox(height: 10,),
            Text("Out of Cards :(" , style: TextStyle(color: Colors.lightBlue ,fontSize: 30 , fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    ),
  );
}
