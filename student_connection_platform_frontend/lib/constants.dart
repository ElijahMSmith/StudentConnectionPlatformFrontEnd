import 'package:flutter/material.dart';

List<BottomNavigationBarItem> ourBottomNavBar()
{
  return const <BottomNavigationBarItem>
  [
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


// blueprint for any user displayed in the card for the match maker
class User
{
  final int id;
  final String name, intro, imgUrl;
  User({@required this.id, @required this.name, @required this.intro, @required this.imgUrl});
}

// Will be used by the Provider state management package to
// have all of the children widgets have access to the information in this list
class Users with ChangeNotifier
{
  List<User> _users = [
    User(id: 1, name: "Maul", intro: "My name is Maul !", imgUrl: 'assets/maul.png'),
    User(id: 2, name: "Obi-wan", intro: "My name is Obi-wan!", imgUrl: 'assets/obiwan.jpg'),
    User(id: 3, name: "Anakin", intro: "My name is Anakin !", imgUrl: 'assets/anakin.png'),
    User(id: 4, name: "Baby_Yoda", intro: "My name is Grogu !", imgUrl: 'assets/baby_yoda.jpg'),
  ];

  List<User> _usersStack = [];

  List<User> get users
  {
    return [..._users];
  }

  List<User> get usersStack
  {
    return [..._usersStack];
  }

  void loadUsersStack()
  {
    _usersStack = [..._users];
    notifyListeners();
  }

  void deleteFromStack(int id)
  {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }
}
