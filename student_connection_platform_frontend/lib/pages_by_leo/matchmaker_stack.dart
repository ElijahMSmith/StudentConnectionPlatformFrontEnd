import 'package:flutter/material.dart';
import '../account.dart';

class MatchMakerStack with ChangeNotifier {
  List<Account> _usersStack = [];

  List<Account> get usersStack {
    return _usersStack;
  }

  void loadStackFromList(List<Account> matches) {
    _usersStack = [...matches];
  }

  void pop(String cardUserID) {
    print("Initially ${_usersStack.length}");
    for (int i = 0; i < _usersStack.length; i++) {
      if (_usersStack[i].userID == cardUserID) {
        print("Removing at $i");
        _usersStack.removeAt(i);
        i--;
      }
    }
    notifyListeners();
    print("Finally ${_usersStack.length}");
  }

  void push(Account a) {
    _usersStack.add(a);
    notifyListeners();
  }

  bool isEmpty() {
    return _usersStack.isEmpty;
  }
}
