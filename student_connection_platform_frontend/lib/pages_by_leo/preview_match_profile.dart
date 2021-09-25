import 'package:flutter/material.dart';

class PreviewMatchProfile extends StatelessWidget {
  // contents will be from the profile page
  final List<dynamic> contents;
  final ImageProvider image;

  PreviewMatchProfile({required this.contents, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            previewHeader(image),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Name', contents[0]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Username', contents[1]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Age', contents[2].toString()),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Profession', contents[3]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Major', contents[4]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Bio', contents[5]),
          ],
        ),
      ),
    );
  }

  Widget previewHeader(ImageProvider image) {
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
            contents[5],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget previewBody(String label, String value) {
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
