import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:student_connection_platform_frontend/theme_shared_prefs.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  ThemePreference themePreference = ThemePreference();

  // getter
  bool get isDarkTheme {
    return this.themeMode == ThemeMode.dark;
  }

  void toggleTheme(bool isOn) {
    print(isOn);
    this.themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    print(this.themeMode.toString());
    themePreference.setTheme(isOn);
    notifyListeners();
  }
}
