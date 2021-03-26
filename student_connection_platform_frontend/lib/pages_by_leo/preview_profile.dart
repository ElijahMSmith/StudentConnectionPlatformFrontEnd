import 'package:flutter/material.dart';

class PreviewProfile extends StatelessWidget
{
  // contents will be from the profile page
  final List<String> contents;
  final ImageProvider image;

  PreviewProfile({@required this.contents, @required this.image});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
              child: ListView(
                children: [
                  previewHeader(image),
                  Divider(thickness: 0.8,),
                  previewBody('Name', contents[0]),
                  Divider(thickness: 0.8,),
                  previewBody('Date of Birth', contents[1]),
                  Divider(thickness: 0.8,),
                  previewBody('Profession', contents[2]),
                  Divider(thickness: 0.8,),
                  previewBody('Major', contents[3]),
                  Divider(thickness: 0.8,),
                  previewBody('About', contents[4]),
                ],
              ),
      ),
    );
  }


  Widget previewHeader(ImageProvider image)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: image,
            radius: 50,
          ),

          // todo
          // should pass in a string here from when the user creates a username
          // upon registration
          Text(
            'Username_goes_here',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget previewBody(String label, String value)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(value)
        ],
      ),
    );
  }
}




