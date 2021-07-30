import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/theme_shared_prefs.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  ThemePreference preference = ThemePreference();

  //getter
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  // //setter
  // set isDarkTheme(bool value) {
  //   _isDarkTheme = value;
  //   preference.setTheme(value);
  //   notifyListeners();
  // }
}
