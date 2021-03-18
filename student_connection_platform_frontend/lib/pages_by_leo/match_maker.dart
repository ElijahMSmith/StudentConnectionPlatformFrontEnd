import 'package:flutter/material.dart';
import '../constants.dart';

// TODO probably should use a state management package as opposed to a stateful widget

class MatchMaker extends StatefulWidget
{
  static const String routeId = 'match_maker';

  @override
  _MatchMakerState createState() => _MatchMakerState();
}

class _MatchMakerState extends State<MatchMaker>
{

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text('MEET NEW PEOPLE!!'),
            ),
          ),
      ),
    );
  }
}
