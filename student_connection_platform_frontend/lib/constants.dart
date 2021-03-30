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
  final String name, userName, intro, imgUrl;
  final String dob, profession, bio, major;
  User({this.major, this.dob, this.profession, @required this.userName, @required this.bio, @required this.id, @required this.name, @required this.intro, @required this.imgUrl});
}

// Will be used by the Provider state management package to
// have all of the children widgets have access to the information in this list
class Users with ChangeNotifier
{
  List<User> _users = [
    User(id: 1, userName: 'DarthMaul123', name: "Maul", dob: '', profession: '', major: '', intro: "My name is Maul !", imgUrl: 'assets/maul.png', bio: 'KENOBIII!!!!'),
    User(id: 2, userName: 'HelloThere123', name: "Obi-wan", dob: '', profession: '', major: '', intro: "My name is Obi-wan!", imgUrl: 'assets/obiwan.jpg', bio: 'The negotiations were short'),
    User(id: 3, userName: 'TheChosenOne123', name: "Anakin", dob: '', profession: '', major: '', intro: "My name is Anakin !", imgUrl: 'assets/anakin.png', bio: 'This is where the fun begins'),
    User(id: 4, userName: 'grogu123', name: "Baby_Yoda", dob: '', profession: '', major: '', intro: "My name is Grogu !", imgUrl: 'assets/baby_yoda.jpg', bio: 'goo goo gaga'),
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
