import 'package:flutter/material.dart';
import '../account.dart';

// TODO: Was this suppose to be used for something, but isn't?

class CardProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as Account;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: user.userID,
              child: Image.asset('assets/images/maul.png',
                  fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              user.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              user.bio,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
