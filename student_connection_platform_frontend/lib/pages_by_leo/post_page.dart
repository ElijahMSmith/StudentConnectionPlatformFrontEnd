import 'package:flutter/material.dart';
import '../constants.dart';

// TODO probably should use a state management package as opposed to a stateful widget

class PostPage extends StatefulWidget
{
  static const String routeId = 'post_page';

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
{

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text('This is the post page'),
            ),
          ),
      ),
    );
  }
}
