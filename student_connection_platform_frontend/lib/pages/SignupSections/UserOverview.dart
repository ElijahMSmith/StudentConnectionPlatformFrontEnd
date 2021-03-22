import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String _appName;

class UserOverview extends StatefulWidget {
  UserOverview(String appName) {
    _appName = appName;
  }

  @override
  _UserOverviewState createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = "";
  bool _takenUsername = false;

  String _bio = "";
  File _profilePicturePath;
  AssetImage _choosePictureAsset =
      AssetImage('assets/images/choosePicture.png');
  FileImage _profileImage;

  // Works on mobile. On web it opens the prompt, but doesn't actually load the selected image
  // Not building for web yet, so I'm not going to work on fixing that yet.
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilePicturePath = File(pickedFile.path);
        _profileImage = FileImage(_profilePicturePath);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Username, profile picture, short bio

      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: _profileImage ?? _choosePictureAsset,
                        fit: BoxFit.fill,
                        width: 100,
                        height: 100,
                      ),
                    )),
                SizedBox(width: 15),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Choose Profile Picture'),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 194, 155, 1),
                        textStyle:
                            TextStyle(fontSize: 12, color: Colors.white)),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              width: 400,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('  Create Your Username!  ',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 3)
                        return 'Usernames must be at least 3 characters';

                      //Validate against existing usernames, return failure if username already exists
                      //_takenUsername

                      //TODO: Check against database for existing usernames
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 20,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'This doesn\'t have to be your real name.'),
                    onChanged: (value) {
                      _username = value;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('  Tell everyone a bit about yourself!  ',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 40)
                        return 'Please include at least 40 characters in your bio.';

                      //TODO: Check against database for existing usernames
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 200,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        filled: true,
                        hintText:
                            'Write anything you want! What makes you who you are?'),
                    onChanged: (value) {
                      _bio = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
