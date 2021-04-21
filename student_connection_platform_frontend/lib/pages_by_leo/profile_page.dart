import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/preview_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../account.dart';

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

  PickedFile imageFile;
  // image picker instance
  final ImagePicker picker = ImagePicker();
  List<TextEditingController> controllers;
  String majorError;
  String bioError;
  var formKey = GlobalKey<FormState>();

  void takePhoto(ImageSource source) async {
    // gets users taken photo
    // this has to be awaited because we don't know when the user will capture
    // the photo
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
  }

  String majorValidator(String majorField) {
    if (majorField.isEmpty || majorField == null) {
      majorError = 'Your major cannot be empty';
      return majorError;
    }
    majorError = null;
    setState(() {});
    return majorError;
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
    // fillBufferFromList(aboutMeBuffer, aboutMe);

    // list comprehension for dart language
    // if you've used python, you probably are
    // very familiar with this
    // 5 separate text editing controllers, one for each text field
    controllers = [for (int i = 0; i < 5; ++i) TextEditingController()];
    // controllers.forEach((element) {print(element);});

    controllers[0].text = _userAccount.name;
    controllers[1].text = _userAccount.username;
    controllers[2].text = _userAccount.job;
    controllers[3].text = _userAccount.major;
    controllers[4].text = _userAccount.bio;

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
    Widget textfield(
        {@required IconData icon,
        @required String label,
        @required String helper,
        String errorText,
        int maxLines = 1,
        bool showCursor = false,
        bool readOnly = false,
        TextEditingController controller,
        Function datePicker,
        Function validator}) {
      return TextFormField(
        controller: controller,
        showCursor: showCursor,
        readOnly: readOnly,
        validator: validator,
        onTap: datePicker,
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
          // hintText: 'John Doe',
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
                FlatButton.icon(
                  onPressed: () {
                    // taken from the camera
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
                FlatButton.icon(
                  onPressed: () {
                    // taken from the camera gallery
                    takePhoto(ImageSource.gallery);
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

    Widget imageProfile() {
      return Stack(
        children: [
          CircleAvatar(
              backgroundImage: imageFile == null
                  ? AssetImage('assets/images/choosePicture.png')
                  : FileImage(File(imageFile.path)),
              radius: 40),
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
                                print(
                                    'Please make sure all fields are valid before previewing');
                                return;
                              }

                              setState(() {});

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewProfile(
                                    contents: [
                                      for (int i = 0; i < 5; ++i)
                                        controllers[i].text
                                    ],
                                    image: imageFile == null
                                        ? _userAccount.defaultPicture
                                        : FileImage(
                                            File(imageFile.path),
                                          ),
                                    userAccount: _userAccount,
                                  ),
                                ),
                              );
                            },
                            child: Text('Preview Profile'))
                      ],
                    ),
                  ),

                  textfield(
                      icon: Icons.person,
                      label: 'Name',
                      helper: 'This is not changeable',
                      controller: controllers[0],
                      readOnly: true),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.person_outline,
                      label: 'Username',
                      helper: 'This is not changeable',
                      readOnly: true,
                      controller: controllers[1]),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.work,
                      label: 'Profession',
                      helper: 'Leave this blank if you don\'t have one',
                      controller: controllers[2]),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.school,
                      label: 'Major',
                      helper: 'Required',
                      validator: majorValidator,
                      controller: controllers[3]),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.book,
                      label: 'Personal Bio',
                      helper: 'A summary of you that others will read',
                      validator: bioValidator,
                      controller: controllers[4],
                      maxLines: 5),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      controllers.forEach((element) => print(element?.text));
                      _userAccount.name = controllers[0].text;

                      // Username (controllers[1]) doesn't change

                      _userAccount.job = controllers[2].text;
                      _userAccount.major = controllers[3].text;
                      _userAccount.bio = controllers[4].text;

                      // TODO: Other fields for other profile sections

                      // RESUBMIT ACCOUNT WITH CHANGES TO SERVER
                      _userAccount.submitAccountChanges().then((response) {
                        print(response.body.toString());
                        if (response.statusCode == 200) {
                          // Username available
                          Fluttertoast.showToast(
                              msg: "Your updated profile has been saved!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white,
                              timeInSecForIosWeb: 2,
                              fontSize: 12.0);
                        } else {
                          // Other error
                          Fluttertoast.showToast(
                              msg: "Couldn't save changes, try again later!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              timeInSecForIosWeb: 2,
                              fontSize: 12.0);
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
                          // todo settings page
                        },
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.pop(
                              context) // Returns to login page (theoretically, TODO testing)
                        },
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
