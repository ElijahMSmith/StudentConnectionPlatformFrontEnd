import 'package:flutter/material.dart';
import 'account.dart';

class MatchMakerStack with ChangeNotifier {
  List<Account> _usersStack = [];

  List<Account> get usersStack {
    return _usersStack;
  }

  void loadStackFromList(List<Account> matches) {
    _usersStack = [...matches];
  }

  void pop(String cardUserID) {
    _usersStack.removeWhere((element) => element.userID == cardUserID);
    notifyListeners();
  }

  void push(Account a) {
    _usersStack.add(a);
    notifyListeners();
  }

  bool isEmpty() {
    return _usersStack.isEmpty;
  }
}
