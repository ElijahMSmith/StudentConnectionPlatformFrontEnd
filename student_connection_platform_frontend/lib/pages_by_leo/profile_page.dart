import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/preview_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/settings.dart';
import '../Utility.dart';
import 'models/account.dart';

Account _userAccount;

class ProfilePage extends StatefulWidget {
  static const String routeID = '/ProfilePage';

  ProfilePage(Account userAccount) {
    _userAccount = userAccount;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// initialize the buffer.
  /// Note that this method
  /// clears out any contents
  /// previously inside.
  void fillBufferFromList(StringBuffer b, List<String> l) {
    if (b.isNotEmpty) {
      b.clear();
    }

    b.writeAll(l);
  }

  PickedFile pickedFile;
  Future<PickedFile> willPickFile;
  Image imageFromPrefs;
  // image picker instance
  final ImagePicker imagePicker = ImagePicker();
  List<TextEditingController> controllers;
  String emptyError;
  String bioError;
  var formKey = GlobalKey<FormState>();

  void loadImgFromPrefs() async {
    await SaveUtility.getImageFromPrefs().then((String image) {
      if (image == null) {
        print("image doesn't exist");
        return;
      }
      imageFromPrefs = SaveUtility.getImageFromBase64String(image);
      setState(() {});
    });
    // print('imageFromPrefs is null?: ${imageFromPrefs == null}');
    // print('imageFromPrefs: $imageFromPrefs');
  }

  void pickImageFromGallery(ImageSource source) {
    willPickFile = imagePicker.getImage(source: source);
    setState(() {});
    if (willPickFile != null) {
      print('willPickFile: $willPickFile');
    }
  }

  // gets users taken photo
  // this has to be awaited because we don't know when the user will capture
  // the photo
  void savePhoto(ImageSource source) async {
    final getImage = await imagePicker.getImage(source: source);
    if (getImage == null) {
      print('error picking image');
      return;
    }
    setState(() {
      pickedFile = getImage;
    });
    // save image to prefs
    var didSave = await SaveUtility.saveImageToPreferences(
        SaveUtility.base64String(File(pickedFile.path).readAsBytesSync()));
    print('did save picked image file: $didSave');
  }

  String emptyValidator(String field) {
    if (field == null || field.isEmpty) {
      emptyError = 'Cannot be empty';
      return emptyError;
    }
    emptyError = null;
    setState(() {});
    return emptyError;
  }

  String bioValidator(String bioField) {
    if (bioField.isEmpty || bioField == null || bioField.length < 40) {
      bioError = 'Your bio must be at least 40 characters!';
      return bioError;
    }
    bioError = null;
    setState(() {});
    return bioError;
  }

  @override
  void initState() {
    super.initState();
    loadImgFromPrefs();

    // list comprehension for dart language
    // if you've used python, you probably are
    // very familiar with this
    // 5 separate text editing controllers, one for each text field
    controllers = [for (int i = 0; i < 9; ++i) TextEditingController()];

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    // clean up
    controllers.forEach((controller) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    // before saving and allowing the user
    // to have it in the profile
    Widget textfield({
      @required IconData icon,
      @required String label,
      @required String helper,
      String errorText,
      int maxLines = 1,
      bool showCursor = false,
      bool readOnly = false,
      TextEditingController controller,
      Function validator,
      String accountInfo,
    }) {
      controller.text = accountInfo;

      return TextFormField(
        controller: controller,
        showCursor: showCursor,
        readOnly: readOnly,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          helperText: helper,
          errorText: errorText,
        ),
      );
    }

    // will be triggered as a bottomSheet once the profile image is tapped
    Widget bottomSheet() {
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
                ElevatedButton.icon(
                  label: Text('Camera'),
                  onPressed: () {
                    // taken from the camera
                    // savePhoto(ImageSource.camera);
                    print(
                        'camera temporarily not working for some unknown reason');
                  },
                  icon: Icon(Icons.camera),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // taken from the camera gallery
                    // savePhoto(ImageSource.gallery);
                    pickImageFromGallery(ImageSource.gallery);
                    // imageFromPrefs = null;
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget profilePic({@required double radius}) {
      return FutureBuilder<PickedFile>(
        future: willPickFile,
        builder: (BuildContext context, AsyncSnapshot<PickedFile> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // save image to prefs
            var didSave = SaveUtility.saveImageToPreferences(
                SaveUtility.base64String(
                    File(snapshot.data.path).readAsBytesSync()));
            // debugging
            didSave.then((didSaveValue) {
              if (didSaveValue)
                print('picture successfully swapped');
              else
                print('failed to swap picture');
            });

            return CircleAvatar(
                backgroundImage: (snapshot.data == null)
                    ? AssetImage('assets/images/baby_yoda.jpg')
                    : FileImage(File(snapshot.data.path)),
                radius: radius);
          }

          // get image from last time
          return CircleAvatar(
            backgroundImage: (imageFromPrefs == null)
                ? AssetImage('assets/images/anakin.png')
                : imageFromPrefs.image,
            radius: radius,
          );
        },
      );
    }

    Widget imageProfile() {
      return Stack(
        children: [
          profilePic(radius: 50),
          Positioned(
              bottom: 0.0,
              right: 25.0,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (builder) => bottomSheet());
                },
                child: Icon(Icons.camera_alt, color: Colors.grey, size: 28.0),
              )),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // for picture and text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                    child: Row(
                      children: [
                        imageProfile(),
                        SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            // validate name input before continuing
                            if (!formKey.currentState.validate()) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please make sure all fields are valid before previewing",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }

                            setState(() {});

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewProfile(
                                  userAccount: _userAccount,
                                  contents: [
                                    for (int i = 0; i < 9; ++i)
                                      controllers[i].text
                                  ],
                                  profilePic: profilePic(radius: 70),
                                ),
                              ),
                            );
                          },
                          child: Text('Preview Profile'),
                        ),
                      ],
                    ),
                  ),
                  // Order: Name Username Age Major School Bio Profession City Country
                  textfield(
                      icon: Icons.person,
                      label: 'Name',
                      helper: 'This is not editable',
                      controller: controllers[0],
                      readOnly: true,
                      accountInfo: _userAccount.name),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.person_outline,
                      label: 'Username',
                      helper: 'This is not editable',
                      controller: controllers[1],
                      readOnly: true,
                      accountInfo: _userAccount.username),
                  SizedBox(height: 30),
                  textfield(
                    icon: Icons.calendar_today,
                    label: 'Age',
                    helper: 'This is not editable',
                    controller: controllers[2],
                    readOnly: true,
                    accountInfo: "${_userAccount.age}",
                  ),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.school,
                      label: 'Major',
                      helper:
                          'If you have a minor or more than one major, put it down!',
                      controller: controllers[3],
                      accountInfo: _userAccount.major,
                      validator: emptyValidator),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.school_outlined,
                      label: 'School',
                      helper: 'Your current university',
                      controller: controllers[4],
                      accountInfo: _userAccount.school,
                      validator: emptyValidator),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.book,
                      label: 'Personal Bio',
                      helper: 'What makes you who you are?',
                      controller: controllers[5],
                      maxLines: 5,
                      accountInfo: _userAccount.bio,
                      validator: bioValidator),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.work,
                      label: 'Occupation',
                      helper:
                          'If you don\'t currently have one, leave this blank!',
                      controller: controllers[6],
                      accountInfo: _userAccount.job),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.add_location_alt,
                      label: 'City',
                      helper: 'What city do you live/attend school in?',
                      controller: controllers[7],
                      accountInfo: _userAccount.city,
                      validator: emptyValidator),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.add_location_alt_outlined,
                      label: 'Country',
                      helper: 'What country do you live/attend school in?',
                      controller: controllers[8],
                      accountInfo: _userAccount.country,
                      validator: emptyValidator),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Name, username, and age don't change, update the rest
                      _userAccount.major = controllers[3].text;
                      _userAccount.school = controllers[4].text;
                      _userAccount.bio = controllers[5].text;
                      _userAccount.job = controllers[6].text;
                      _userAccount.city = controllers[7].text;
                      _userAccount.country = controllers[8].text;

                      _userAccount.submitAccountChanges().then((response) => {
                            if (response.statusCode == 200)
                              {
                                Fluttertoast.showToast(
                                    msg: "Changes saved!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                            else
                              {
                                Fluttertoast.showToast(
                                    msg: "Couldn't submit changes!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                          });
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                  ),
                  SizedBox(height: 30),
                  // log out button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Settings(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Log out'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
