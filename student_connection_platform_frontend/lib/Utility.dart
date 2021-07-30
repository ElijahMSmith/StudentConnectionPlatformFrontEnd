import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUtility {
  static const String IMG_KEY = "IMG_KEY";

  static Future<bool> saveImageToPreferences(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(IMG_KEY, value);
  }

  static Future<String> getImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(IMG_KEY);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image getImageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );
}
