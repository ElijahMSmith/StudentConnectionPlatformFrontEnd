import 'package:flutter/material.dart';
import '../account.dart';

class MatchMakerStack with ChangeNotifier {
  List<Account> _usersStack = [];

  List<Account> get usersStack {
    return [..._usersStack];
  }

  void loadStackFromList(List<Account> matches) {
    _usersStack = [...matches];
    notifyListeners();
  }

  Account pop() {
    Account off = _usersStack.removeLast();
    notifyListeners();
    return off;
  }

  void push(Account a) {
    _usersStack.add(a);
  }
}
