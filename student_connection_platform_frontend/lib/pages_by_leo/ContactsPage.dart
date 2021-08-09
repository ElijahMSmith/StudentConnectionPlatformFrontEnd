import 'package:flutter/material.dart';
import 'ContactCard.dart';
import 'models/account.dart';
import 'dm.dart';
import 'package:http/http.dart' as http;

Account _activeUser;

class ContactsPage extends StatefulWidget {
  ContactsPage(Account activeUser) {
    _activeUser = activeUser;
    // print(_activeUser.matchedUsers);
  }

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    List<Account> userMatches = _activeUser.matchedUsers;
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pick a match to chat with",
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
                              onPressed: () {
                                // TODO delete from list and add back to match making stack
                                // TODO remove contact from active user's matched users list

                                // TODO updated

                                // TODO remove contact from match url in the backend as well

                                _activeUser
                                    .deleteMatchWith(userMatches[index])
                                    .then((http.Response value) {
                                  if (value.statusCode == 200) {
                                    print(
                                        "matched user successfully deleted from active user's list");
                                  }
                                  else{
                                    print(
                                        "");
                                        // matched user successfully deleted from active user's list
                                  }
                                });

                                // if current user unmatched with the selected matched user,
                                // then the current user should disappear from the selected matched user's // contact list as well,
                                userMatches[index]
                                    .deleteMatchWith(_activeUser)
                                    .then((http.Response value) {
                                      if (value.statusCode == 200) {
                                    print(
                                        "active user successfully deleted from matched user's list");
                                  }
                                  else{
                                    print(
                                        "active user unsuccessfully deleted from matched user's list");
                                  }
                                    });

                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Delete")),
                        ],
                      );
                    },
                  );
                },
                // show a red background as the item is swiped away
                background: Container(
                  color: Colors.red,
                ),
                child: InkWell(
                  onTap: () {
                    // Connect to a WebSocket server
                    // don't pass the websocket channel down this widget. Instead, declare and initialze
                    // it inside.
                    // go to dm's page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DM(
                                  activeUser: _activeUser,
                                  otherUser: userMatches[index],
                                )));
                  },
                  child: ContactCard(
                    contact: userMatches[index],
                  ),
                ),
              );
            }));
  }
}
