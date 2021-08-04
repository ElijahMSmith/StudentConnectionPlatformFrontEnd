import 'package:flutter/material.dart';
import 'account.dart';

class MatchMakerStack with ChangeNotifier {
  List<Account> _matchMakingStack = [];

  List<Account> get usersStack {
    return _matchMakingStack;
  }

  void loadStackFromList(List<Account> matches) {
    _matchMakingStack = [...matches];
  }

  void pop(String cardUserID) {
    _matchMakingStack.removeWhere((element) => element.userID == cardUserID);
    notifyListeners();
  }

  void push(Account a) {
    _matchMakingStack.add(a);
    notifyListeners();
  }

  bool isEmpty() {
    return _matchMakingStack.isEmpty;
  }
}
