import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const String routeId = 'profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final aboutMe = [
    'Greetings! I am currently a Computer Science graduate student attending ',
    'The University of Central Florida. My productive spare-time ',
    'hobbies include full-stack development on web, mobile, and game applications. ',
    'I am fascinated by what machine learning can do for the society; ',
    'as a result, I am trying to get a more in-depth understanding of the application of machine learning, ',
    'and such a desire has motivated me to continue my education in graduate school. ',
    'Eventually, I would have a better understanding of the machine learning algorithms '
        'behind the scenes as I incorporate such applications & concepts into my personal projects, ',
    'and leverage such skills to contribute in the software idustry.'
  ];

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

  Container bioSection({
    Widget body = const Text('bio text'),
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
  }) {
    return Container(
      child: Padding(padding: padding, child: body),
    );
  }

  StringBuffer aboutMeBuffer = StringBuffer();

  PickedFile imageFile;
  // image picker instance
  final ImagePicker picker = ImagePicker();

  void takePhoto(ImageSource source) async {
    // gets users taken photo
    // this has to be awaited because we don't know when the user will capture
    // the photo
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    fillBufferFromList(aboutMeBuffer, aboutMe);
  }

  @override
  Widget build(BuildContext context) {
    TextFormField textfield(
        {@required IconData icon,
        @required String label,
        @required String helper,
        int maxLines = 1}) {
      return TextFormField(
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
        ),
      );
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

    Stack imageProfile() {
      return Stack(
        children: [
          CircleAvatar(
              backgroundImage: imageFile == null
                  ? AssetImage('assets/baby_yoda.jpg')
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
                      RaisedButton(
                          onPressed: () {}, child: Text('Preview Profile'))
                    ],
                  ),
                ),

                textfield(
                    icon: Icons.person,
                    label: 'Name',
                    helper: 'Name can\'t be empty'),
                SizedBox(height: 30),
                textfield(
                    icon: Icons.person,
                    label: 'Date of Birth',
                    helper: 'mm/dd/yyyy'),
                SizedBox(height: 30),
                textfield(
                    icon: Icons.work,
                    label: 'Profession',
                    helper: 'Software developer'),
                SizedBox(height: 30),
                textfield(
                    icon: Icons.school,
                    label: 'Major',
                    helper: 'computer science'),
                SizedBox(height: 30),
                textfield(
                    icon: Icons.book,
                    label: 'About',
                    helper: 'About me',
                    maxLines: 5),
                SizedBox(height: 30),

                // bio text
                // Container(
                //     child: bioSection(
                //         body: SelectableText(aboutMeBuffer.toString())
                //   )
                // ),
                // log out button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                    RaisedButton(
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
    );
  }
}
