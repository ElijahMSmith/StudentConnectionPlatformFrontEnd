
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    Container(
                      // developers
                      child: SelectableText(
                        'Frontend: Leo Zhang, Elijah Smith\nBackend: Ricardo Ruiz'
                      ),
                    ),
                    Container(
                      child: SelectableText(
                        'Add Link to a video demo here'
                      )
                    ),
                    // bio text
                    Container(
                      // slogan
                      child: SelectableText(
                        'StuConn: Better together'
                      )
                    ),
                    Container(
                      child: SelectableText(
                        'Add Overview of functionality here'
                      )
                    ),
                    Container(
                      child: SelectableText(
                        'Add Github repo link if we go open source here (if we do open source it, maybe add our venmos on here in case anyone wants to buy us coffee 😉)'
                      )
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

