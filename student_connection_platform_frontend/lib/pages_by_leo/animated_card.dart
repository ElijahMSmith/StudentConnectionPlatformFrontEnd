import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

// typedef void DragStart(DragStartDetails dragDetails);

enum SwipeDirection { left, right }

// take in one user for displaying
class AnimatedCard extends StatefulWidget
{
  final User user;

  AnimatedCard(this.user);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}


class _AnimatedCardState extends State<AnimatedCard> with TickerProviderStateMixin
{
  // initialize controllers
  AnimationController swipeRightController, swipeLeftController;
  Animation<double> slideRight, rotateRight, slideLeft, rotateLeft;
  SwipeDirection dir;
  double width, startDragDetails;

  @override
  void didChangeDependencies()
  {
    width = MediaQuery.of(context).size.width;
    // todo nice to have: try to only remove the card from the stack once the user has removed his/her finger from the screen when on drag and that the drag has been far enough to the right or left of the screen

    // initialize controllers
    swipeRightController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
      )
      // ..forward()
      ..addStatusListener((AnimationStatus status)
      {
        // print(swipeRightController.value);
        if (status == AnimationStatus.completed)
        {
          Provider.of<Users>(context, listen: false)
            .deleteFromStack(widget.user.id);
          print(Provider.of<Users>(context, listen: false).users.toString());
        }
    });

    swipeLeftController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
      )
      // ..forward()
      ..addStatusListener((AnimationStatus status)
      {
        // print(swipeRightController.value);
        if (status == AnimationStatus.completed)
        {
          Provider.of<Users>(context, listen: false)
            .deleteFromStack(widget.user.id);
          print(Provider.of<Users>(context, listen: false).users.toString());
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

  @override
  void initState()
  {
    super.initState();

  }

    @override
  void dispose()
  {
    swipeRightController.dispose();
    swipeLeftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Transform.rotate(
          angle: dir == SwipeDirection.right? rotateRight.value : rotateLeft.value,
          child: Container(
        child: Center(
          child: GestureDetector(
            onHorizontalDragStart: (DragStartDetails dragDetails)
            {
              // record this information to understand which direction
              // the user is swiping. If the coordinates in dragupdate - startdragdetails > 0,
              // that means the user is swiping right. Otherwise if less than 0, the user
              // is swiping left.
              startDragDetails = dragDetails.localPosition.dx;
              print('swipe started');
            },
            onHorizontalDragUpdate: (DragUpdateDetails dragDetails)
            {
              // detect whether the user is swiping right or left
              // based on the coordinates relative to startdragdetails
              if (dragDetails.localPosition.dx - startDragDetails > 0)
              {
                dir = SwipeDirection.right;
                swipeRightController.forward();
              }
              else
              {
                dir = SwipeDirection.left;
                swipeLeftController.forward();
              }

              print(dragDetails.localPosition);
            },
            onHorizontalDragEnd: (DragEndDetails dragDetails)
            {
              print('swipe ended');
            },

            child: InkWell(
              onTap: ()
              {
                // todo segue to the user's preview page (not yours, but whoever shows up on top of the stack of cards)

              },
              child: Container(
                key: Key(widget.user.id.toString()),
                padding: EdgeInsets.all(8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 270,
                        child: Hero(
                          tag: widget.user.id,
                          child: ClipRRect(
                            child: Image.asset(
                              widget.user.imgUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
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
                          widget.user.name,
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.user.intro,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                // todo maybe change to media query height & width and do some division for reponsive UI???
                height: 400,
                width: 400,
                transform: dir == SwipeDirection.right
                ? Matrix4.translationValues(slideRight.value, 0, 0)
                : Matrix4.translationValues(slideLeft.value, 0, 0),
              ),
            ),
          ),
        )
      ),
    );
  }
}

