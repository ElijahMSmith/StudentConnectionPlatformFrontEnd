import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/models/MessageModel.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class SaveUtility {
  static const String IMG_KEY = "IMG_KEY";

  static Future<bool> saveImageToPreferences(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(IMG_KEY, value);
  }

  static Future<String?> getImageFromPrefs() async {
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

/// Only does saving and deleting list of messags from prefs. The user is responsible for mananging the state in the UI (i.e. knowing when to call setState())
class ChatMessageSaveUtil {
  static void initSharedPreferences(
      String uniqueKey, List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    // necessary key check or else console throws an error
    if (prefs.containsKey(uniqueKey)) {
      loadListOfMessages(uniqueKey);
    }
  }

  static Future<List<String>?> loadListOfMessages(String uniqueKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(uniqueKey)) {
      return null;
    }
    return prefs.getStringList(uniqueKey);
  }

  static void saveListOfMessages(
      String uniqueKey, List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> spList = messages
        .map((MessageModel message) => json.encode(message.toMap()))
        .toList();

    prefs.setStringList(uniqueKey, spList);
  }

  /// clears all messages between you and the other user
  static void clearMessages(
      String uniqueKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(uniqueKey)) {
      prefs.remove(uniqueKey);
    }

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

class Utils {
  // gets file path from provided url
  static Future<String> downloadFile(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final response = await http.get(Uri.parse(url));
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}








// class FirebaseMLApi {
//   static Future<String> recogniseText(File imageFile) async {
//     if (imageFile == null) {
//       return 'No selected image';
//     } else {
//       final visionImage = FirebaseVisionImage.fromFile(imageFile);
//       final textRecognizer = FirebaseVision.instance.textRecognizer();
//       try {
//         final visionText = await textRecognizer.processImage(visionImage);
//         await textRecognizer.close();

//         final text = extractText(visionText);
//         return text.isEmpty ? 'No text found in the image' : text;
//       } catch (error) {
//         return error.toString();
//       }
//     }
//   }

//   static extractText(VisionText visionText) {
//     String text = '';

//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
//         for (TextElement word in line.elements) {
//           text = text + word.text + ' ';
//         }
//         text = text + '\n';
//       }
//     }

//     return text;
//   }
// }
