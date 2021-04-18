import 'package:flutter/material.dart';

import 'ButtonCard.dart';
import 'ContactCard.dart';
import 'models/ChatModel.dart';
import 'package:uuid/uuid.dart';
import '../account.dart';

Account _userAccount;

class SelectContact extends StatefulWidget {
  SelectContact(Account userAccount) {
    _userAccount = userAccount;
  }

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(name: "Dev Stack", id: 0, status: "A full stack developer"),
      ChatModel(name: "Balram", id: 1, status: "Flutter Developer..........."),
      ChatModel(name: "Saket", id: 2, status: "Web developer..."),
      ChatModel(name: "Bhanu Dev", id: 3, status: "App developer...."),
      ChatModel(name: "Collins", id: 4, status: "React developer.."),
      ChatModel(name: "Kishor", id: 5, status: "Full Stack Web"),
      ChatModel(name: "Testing1", id: 6, status: "Example work"),
      ChatModel(name: "Testing2", id: 7, status: "Sharing is caring"),
      ChatModel(name: "Divyanshu", id: 8, status: "....."),
      ChatModel(name: "Helper", id: 9, status: "Love you Mom Dad"),
      ChatModel(name: "Tester", id: 10, status: "I find the bugs"),
    ];
    bool didDelete = false;

    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${contacts.length} contacts",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(contacts[index].id),
                // onDismissed: (direction)
                // {
                //   setState(() {
                //     contacts.removeAt(index);
                //   });
                // },
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Confirmation"),
                        content: const Text(
                            "Are you sure you want to delete this item?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete")),
                        ],
                      );
                    },
                  );

                  // switch (direction)
                  // {
                  //   case DismissDirection.startToEnd:
                  //   case DismissDirection.endToStart:
                  //     await showDialog(
                  //       context: context,
                  //       builder: (BuildContext context)
                  //       {
                  //         return AlertDialog(
                  //           content: Text("Are you sure you want to delete this contact? :("),
                  //           actions: [
                  //             TextButton(child: Text('No'), onPressed: ()
                  //             {
                  //               Navigator.of(context).pop(false);
                  //               // because of async and await, this print statement will only
                  //               // execute once the alert dialog above is closed by the user
                  //               print('alert dialog closed');
                  //               setState(() {
                  //                 didDelete = false;
                  //               });
                  //             }),
                  //             TextButton(child: Text('Yes'), onPressed: ()
                  //             {
                  //               ChatModel deletedModel = contacts[index];
                  //               // deletes the user tapped
                  //               setState(()
                  //               {
                  //                 // contacts.removeAt(index);
                  //                 didDelete = true;
                  //               });
                  //               Navigator.of(context).pop(true);
                  //               // Then show a snackbar.
                  //               ScaffoldMessenger.of(context)
                  //               .showSnackBar(SnackBar(content: Text("you unmatched with ${deletedModel.name}")));
                  //             }),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //     return didDelete;
                  //   default:
                  //     return false;
                  // }
                },
                // show a red background as the item is swiped away
                background: Container(
                  color: Colors.red,
                ),
                child: ContactCard(
                  contact: contacts[index],
                ),
              );
            }));
  }
}
