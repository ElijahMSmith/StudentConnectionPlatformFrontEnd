import 'package:flutter/material.dart';
import 'models/account.dart';

class ContactCard extends StatelessWidget
{
  final Account contact;
  const ContactCard({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      leading: Container(
        width: 50,
        height: 53,
        child: Stack(
          children: [
            Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: AssetImage("assets/images/emptyProfileImage.png"),
                    fit: BoxFit.fill,
                  ),
                )),
                Positioned(
                    bottom: 4,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 11,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
          ],
        ),
      ),
      title: Text(
        contact.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      // subtitle: Text(
      //   contact.status,
      //   style: TextStyle(
      //     fontSize: 13,
      //   ),
      // ),
    );
  }
}
