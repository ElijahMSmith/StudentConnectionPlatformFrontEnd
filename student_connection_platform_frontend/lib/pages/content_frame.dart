import 'package:flutter/material.dart';

/*

Defines the frame for holding our three content tabs (which should be individual files for organization)

*/

String _appName;

class ContentFrame extends StatefulWidget
{
  ContentFrame(String appName)
  {
    _appName = appName;
  }

  @override
  _ContentFrameState createState() => _ContentFrameState();
}

class _ContentFrameState extends State<ContentFrame>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold();
  }
}
