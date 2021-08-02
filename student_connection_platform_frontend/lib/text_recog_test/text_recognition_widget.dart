// import 'dart:io';

// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:student_connection_platform_frontend/text_recog_test/text_area_widget.dart';

// import '../Utility.dart';
// import 'controls_widget.dart';

// class TextRecognitionWidget extends StatefulWidget {
//   const TextRecognitionWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
// }

// class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
//   String text = '';
//   File image;

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Column(
//           children: [
//             Expanded(child: buildImage()),
//             const SizedBox(height: 16),
//             ControlsWidget(
//               onClickedPickImage: pickImage,
//               onClickedScanText: scanText,
//               onClickedClear: clear,
//             ),
//             const SizedBox(height: 16),
//             TextAreaWidget(
//               text: text,
//               onClickedCopy: copyToClipboard,
//             ),
//           ],
//         ),
//       );

//   Widget buildImage() => Container(
//         child: image != null
//             ? Image.file(image)
//             : Icon(Icons.photo, size: 80, color: Colors.black),
//       );

//   Future pickImage() async {
//     final file = await ImagePicker().getImage(source: ImageSource.gallery);
//     setImage(File(file.path));
//   }

//   Future scanText() async {
//     showDialog(
//         context: context,
//         builder: (_) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         });

//     final text = await FirebaseMLApi.recogniseText(image);
//     setText(text);

//     Navigator.of(context).pop();
//   }

//   void clear() {
//     setImage(null);
//     setText('');
//   }

//   void copyToClipboard() {
//     if (text.trim() != '') {
//       FlutterClipboard.copy(text);
//     }
//   }

//   void setImage(File newImage) {
//     setState(() {
//       image = newImage;
//     });
//   }

//   void setText(String newText) {
//     setState(() {
//       text = newText;
//     });
//   }
// }
