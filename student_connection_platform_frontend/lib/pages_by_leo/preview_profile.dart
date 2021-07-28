import 'package:flutter/material.dart';
import './models/account.dart';
import 'models/account.dart';

class PreviewProfile extends StatelessWidget {
  // contents will be from the profile page
  final List<String> contents;
  final Widget profilePic;
  final Account userAccount;

  PreviewProfile(
      {@required this.contents,
      @required this.profilePic,
      @required this.userAccount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            previewHeader(this.profilePic),
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
            previewBody('Age', contents[2]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Major', contents[3]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('School', contents[4]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Bio', contents[5]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Profession', contents[6]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('City', contents[7]),
            Divider(
              thickness: 0.8,
            ),
            previewBody('Country', contents[8]),
            Divider(
              thickness: 0.8,
            ),
            // TODO: Find another way to display interests here
          ],
        ),
      ),
    );
  }

  Widget previewHeader(Widget profilePic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profilePic,
          Text(
            userAccount.username,
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
