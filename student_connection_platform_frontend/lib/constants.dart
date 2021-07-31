import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> ourBottomNavBar() {
  return const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        backgroundColor: Colors.pink,
        icon: Icon(Icons.account_circle, color: Colors.black),
        label: 'Account'),
    BottomNavigationBarItem(
        backgroundColor: Colors.purple,
        icon: Icon(Icons.search, color: Colors.black),
        label: 'Match'),
    BottomNavigationBarItem(
        backgroundColor: Colors.green,
        icon: Icon(Icons.chat, color: Colors.black),
        label: 'Chat'),
  ];
}

final materialThemeData = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.blue.shade600),
    primaryColor: Colors.blue,
    secondaryHeaderColor: Colors.blue,
    canvasColor: Colors.blue,
    backgroundColor: Colors.red,
    textTheme: TextTheme().copyWith(bodyText2: TextTheme().bodyText2));
final cupertinoTheme = CupertinoThemeData(
    primaryColor: Colors.blue,
    barBackgroundColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white);
