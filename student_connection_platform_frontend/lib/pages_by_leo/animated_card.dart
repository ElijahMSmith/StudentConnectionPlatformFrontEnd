import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/models/matchmaker_stack.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/preview_match_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'match_maker.dart';
import 'models/account.dart';

// typedef void DragStart(DragStartDetails dragDetails);

enum SwipeDirection { left, right }

// take in one user for displaying
class AnimatedCard extends StatefulWidget {
  final Account randomUser;
  final Account activeUser;
  final MatchMaker host;

  AnimatedCard(this.randomUser, this.activeUser, this.host);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  // initialize controllers
  AnimationController swipeRightController, swipeLeftController;
  Animation<double> slideRight, rotateRight, slideLeft, rotateLeft;
  SwipeDirection dir;
  double width, startDragDetails;

  void removeCardOnceFinished() {
    Provider.of<MatchMakerStack>(context, listen: false)
        .pop(widget.randomUser.userID);

    widget.host.removeMatchedUser(widget.randomUser);
  }

  Future<void> showMatchMessage(bool fullMatch) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fullMatch ? "It's a full match!" : "Partially matched!"),
          content: SingleChildScrollView(
            child: ListBody(
                children: fullMatch
                    ?
                    // Username is already in use
                    <Widget>[
                        Text('You both wanted to match with each other!\n'),
                        Text(
                            'Head over to the DMs page to start a conversation, or continue searching for other matches.'),
                      ]
                    :

                    // Other error when submitting username for validation
                    <Widget>[
                        Text(
                            'You matched with this user, but they haven\'t matched with you yet!\n'),
                        Text(
                            'If they also choose to match with you, they will appear in your DMs next time you visit that page.'),
                        Text(
                            'For now, you may continue searching for matches!'),
                      ]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    // TODO nice to have: try to only remove the card from the stack once the user has removed his/her finger from the screen when on drag and that the drag has been far enough to the right or left of the screen

    // initialize controllers
    swipeRightController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )
      // ..forward()
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          // User swiped right, meaning they want to match with them
          // Pop that card off the stack, send partial match to server and get response
          // If just a partial match, don't change anything. Just show a dialog.
          // If a full match, add that user's UID/Account to their matches and open DM's page
          // Show full match dialog

          Map<String, dynamic> matchResponse = {};

          widget.activeUser
              .createMatchWith(widget.randomUser)
              .then((response) => {
                    if (response.statusCode == 200)
                      {
                        print(response.body),
                        matchResponse = jsonDecode(response.body),
                        if (matchResponse["message"] == "User liked!")
                          {
                            // First person to accept, add to their matches and show dialog
                            showMatchMessage(false)
                          }
                        else
                          {
                            // Second person to accept, show full match dialog and add to matches
                            showMatchMessage(true)
                          },

                        // populate active user
                        widget.activeUser.matchIDs
                            .add(widget.randomUser.userID),
                        widget.activeUser.matchedUsers.add(widget.randomUser),
                        removeCardOnceFinished()
                      }
                    else
                      {
                        // There was an error
                        print(response.body),
                        Fluttertoast.showToast(
                            msg: "Couldn't accept match!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0)
                      }
                  });
        }
      });

    swipeLeftController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )
      // ..forward()
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          // User swiped left - not a match, ignore the result.
          // Just take the user off the stack of cards and move to next one
          Provider.of<MatchMakerStack>(context, listen: false)
              .pop(widget.randomUser.userID);

          widget.host.removeMatchedUser(widget.randomUser);
        }
      });

    final curvedAnimationR = CurvedAnimation(
      parent: swipeRightController,
      curve: Curves.easeOut,
    );

    final curvedAnimationL = CurvedAnimation(
      parent: swipeLeftController,
      curve: Curves.easeOut,
    );
//------------- Right ----------------------
    slideRight = Tween<double>(
      begin: 0,
      end: width,
    ).animate(curvedAnimationR)
      ..addListener(() {
        setState(() {});
      });

    rotateRight = Tween<double>(
      begin: 0,
      end: -0.3,
    ).animate(curvedAnimationR)
      ..addListener(() {
        setState(() {});
      });

//------------- Left ----------------------
    slideLeft = Tween<double>(
      begin: 0,
      end: -width,
    ).animate(curvedAnimationL)
      ..addListener(() {
        setState(() {});
      });

    rotateLeft = Tween<double>(
      begin: 0,
      end: 0.3,
    ).animate(curvedAnimationL)
      ..addListener(() {
        setState(() {});
      });

    super.didChangeDependencies();
  }

  List<dynamic> previewInfo = [];

  @override
  void initState() {
    super.initState();
    //TODO: Eventually refactor this to include ALL the user's information
    previewInfo
      ..add(widget.randomUser.name)
      ..add(widget.randomUser.username)
      ..add(widget.randomUser.age)
      ..add(widget.randomUser.job)
      ..add(widget.randomUser.major)
      ..add(widget.randomUser.bio);
  }

  @override
  void dispose() {
    swipeRightController.dispose();
    swipeLeftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: dir == SwipeDirection.right ? rotateRight.value : rotateLeft.value,
      child: Container(
          child: Center(
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails dragDetails) {
            // record this information to understand which direction
            // the user is swiping. If the coordinates in dragupdate - startdragdetails > 0,
            // that means the user is swiping right. Otherwise if less than 0, the user
            // is swiping left.
            startDragDetails = dragDetails.localPosition.dx;
            print('swipe started');
          },
          onHorizontalDragUpdate: (DragUpdateDetails dragDetails) {
            // detect whether the user is swiping right or left
            // based on the coordinates relative to startdragdetails
            if (dragDetails.localPosition.dx - startDragDetails > 0) {
              dir = SwipeDirection.right;
              swipeRightController.forward();
            } else {
              dir = SwipeDirection.left;
              swipeLeftController.forward();
            }

            print(dragDetails.localPosition);
          },
          onHorizontalDragEnd: (DragEndDetails dragDetails) {
            print('swipe ended');
          },
          child: InkWell(
            onTap: () {
              // Segue to the user's preview page (whoever is on top of the stack)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewMatchProfile(
                    contents: previewInfo,
                    image: widget.randomUser.profilePicture ??
                        widget.randomUser.defaultPicture,
                  ),
                ),
              );
            },
            child: Container(
              key: Key(widget.randomUser.userID.toString()),
              padding: EdgeInsets.all(8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Hero(
                          tag: widget.randomUser.userID,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image(
                              image: widget.randomUser.profilePicture != null
                                  ? FileImage(widget.randomUser.profilePicture)
                                  : widget.randomUser.defaultPicture,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.randomUser.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.randomUser.bio,
                        style: TextStyle(fontSize: 20),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              transform: dir == SwipeDirection.right
                  ? Matrix4.translationValues(slideRight.value, 0, 0)
                  : Matrix4.translationValues(slideLeft.value, 0, 0),
            ),
          ),
        ),
      )),
    );
  }
}
