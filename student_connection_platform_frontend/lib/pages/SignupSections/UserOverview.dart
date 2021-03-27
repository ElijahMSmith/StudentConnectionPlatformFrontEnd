import 'package:student_connection_platform_frontend/account.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Account _newAccount;

class UserOverview extends StatefulWidget {
  static String routeID = "/UserOverview";

  UserOverview(Account account) {
    _newAccount = account;
  }

  @override
  _UserOverviewState createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AssetImage _choosePictureAsset =
      AssetImage('assets/images/choosePicture.png');
  final picker = ImagePicker();
  PickedFile _imageFile;

  Future getImage(ImageSource source) async {
    _imageFile = await picker.getImage(source: source);
    if (_imageFile != null)
      _cropImage();
    else
      _newAccount.validProfilePicture = false;
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Color.fromRGBO(0, 194, 155, 1),
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
        aspectRatioLockEnabled: true,
      ),
    );
    if (croppedFile != null) {
      setState(() {
        _newAccount.profilePicture = croppedFile;
        _newAccount.validProfilePicture = true;
      });
    } else {
      print('No image selected.');
      _newAccount.validProfilePicture = false;
    }
  }

  // will be triggered as a bottomSheet once the profile image is tapped
  Container bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text('Choose profile photo', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: FlatButton.icon(
                  onPressed: () {
                    // taken from the camera
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
              ),
              Expanded(
                flex: 5,
                child: FlatButton.icon(
                  onPressed: () {
                    // taken from the camera gallery
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                        image: _newAccount.profilePicture != null
                            ? FileImage(_newAccount.profilePicture)
                            : _choosePictureAsset,
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
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) => bottomSheet());
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
                    initialValue: _newAccount.username,
                    validator: (value) {
                      if (value.isEmpty || value.length < 3)
                        return 'Usernames must be at least 3 characters';

                      //TODO: Check against database for existing usernames
                      _newAccount.validUsername = true;
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 20,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'This doesn\'t have to be your real name.'),
                    onChanged: (value) {
                      _newAccount.username = value;
                      _newAccount.validUsername = false;
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
                    initialValue: _newAccount.bio,
                    validator: (value) {
                      if (value.isEmpty || value.length < 40)
                        return 'Please include at least 40 characters in your bio.';

                      _newAccount.validBio = true;
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 140,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        filled: true,
                        hintText:
                            'Write anything you want! What makes you who you are?'),
                    onChanged: (value) {
                      _newAccount.validBio = false;
                      _newAccount.bio = value;
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
