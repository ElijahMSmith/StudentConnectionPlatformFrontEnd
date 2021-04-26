import 'dart:convert';
import 'package:flutter/material.dart';
import 'ContactCard.dart';
import 'models/account.dart';
import 'package:http/http.dart' as http;
import 'dm.dart';

Account _activeUser;
// Map<String, dynamic> matchedUser;

class ContactsPage extends StatefulWidget {
  ContactsPage(Account activeUser) {
    _activeUser = activeUser;
    print(_activeUser.matchedUsers);

    // get list of matched user ids from active user. Then make a get request
    // for each of those user ids to receive the account object
    // once the list of maps is obtained, we can convert that list into a list of account objects
    // for the dms list

    // for (String id in _activeUser.matchIDs)
    // {

    // }

    // http.get(Uri.parse("https://t3-dev.rruiz.dev/api/users/"), headers: {
    //   "Content-Type": "application/json"
    // }).then((resp) => {
    //   parsedBody = jsonDecode(resp.body),
    //   for (int i = 0; i < parsedBody.length; i++)
    //   {
    //     // If the id of this particular user is contained in the matches of the active user, ignore it
    //     // If the active user IS this user, ignore it
    //     // Otherwise, add it to the card stack
    //     if (!_activeUser.matchIDs.contains(parsedBody[i]["id"]) &&
    //         !(_activeUser.userID == parsedBody[i]["id"]))
    //       allUsers.add(Account.fromUserRequest(parsedBody[i]))
    //   }
    // });
  }

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    List<Account> userMatches = _activeUser.matchedUsers;

// dummy03 Dumdum1!
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
                "${userMatches.length} contacts",
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
            itemCount: userMatches.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(userMatches[index].userID),
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
                            "Are you sure you want to unmatch this person?"),
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
                child: InkWell(
                  onTap: ()
                  {
                    // go to dm's page
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => DM(activeUser: _activeUser, otherUser: userMatches[index])));
                  },
                  child: ContactCard(
                    contact: userMatches[index],
                  ),
                ),
              );
            }));
  }
}
