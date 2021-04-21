import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/preview_profile.dart';
import 'models/account.dart';

Account _userAccount;

class ProfilePage extends StatefulWidget
{
  static const String routeID = '/ProfilePage';

  ProfilePage(Account userAccount) {
    _userAccount = userAccount;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
{
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
  String nameError;
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

  void datePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    controllers[1].text = date.toString().substring(0, 10);
  }

  String validator(String nameField) {
    if (nameField.isEmpty || nameField == null) {
      nameError = 'Please enter your name';
      return nameError;
    }
    nameError = null;
    setState(() {});
    return nameError;
  }

  @override
  void initState() {
    super.initState();

    // list comprehension for dart language
    // if you've used python, you probably are
    // very familiar with this
    // 5 separate text editing controllers, one for each text field
    controllers = [for (int i = 0; i < 5; ++i) TextEditingController()];
    // controllers.forEach((element) {print(element);});

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
      Function datePicker,
      Function validator,
      String accountInfo,
    })
    {

      controller.text = accountInfo;

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
                  ? AssetImage('assets/images/baby_yoda.jpg')
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
                                        ? AssetImage(
                                            'assets/images/baby_yoda.jpg')
                                        : FileImage(
                                            File(imageFile.path),
                                          ),
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
                      helper: 'Name can\'t be empty',
                      controller: controllers[0],
                      errorText: nameError,
                      validator: validator,
                      accountInfo: _userAccount.name
                      ),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.person,
                      label: 'Date of Birth',
                      showCursor: true,
                      readOnly: true,
                      helper: 'mm/dd/yyyy',
                      controller: controllers[1],
                      datePicker: datePicker,
                      accountInfo: _userAccount.dateOfBirth),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.work,
                      label: 'Profession',
                      helper: 'Software developer',
                      controller: controllers[2],
                      accountInfo: _userAccount.job),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.school,
                      label: 'Major',
                      helper: 'computer science',
                      controller: controllers[3],
                      accountInfo: _userAccount.major),
                  SizedBox(height: 30),
                  textfield(
                      icon: Icons.book,
                      label: 'About',
                      helper: 'About me',
                      controller: controllers[4],
                      maxLines: 5,
                      accountInfo: _userAccount.bio),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      controllers.forEach((element) => print(element?.text));
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
                        onPressed: () => print('log out'),
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
