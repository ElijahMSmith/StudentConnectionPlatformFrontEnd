import 'package:flutter/material.dart';

List<BottomNavigationBarItem> ourBottomNavBar() {
  return const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        backgroundColor: Colors.red,
        icon: Icon(Icons.add, color: Colors.black),
        label: 'Post'),
    BottomNavigationBarItem(
        backgroundColor: Colors.green,
        icon: Icon(Icons.chat, color: Colors.black),
        label: 'Chat'),
    BottomNavigationBarItem(
        backgroundColor: Colors.purple,
        icon: Icon(Icons.search, color: Colors.black),
        label: 'Match'),
    BottomNavigationBarItem(
        backgroundColor: Colors.pink,
        icon: Icon(Icons.account_circle, color: Colors.black),
        label: 'Account'),
  ];
}