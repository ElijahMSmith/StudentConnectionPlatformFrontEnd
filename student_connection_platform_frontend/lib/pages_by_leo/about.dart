
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
                      child: SelectableText(
                        'Add creators here'
                      )
                    ),
                    Container(
                      child: SelectableText(
                        'Add Link to a video demo here'
                      )
                    ),
                    // bio text
                    Container(
                      child: SelectableText(
                        'Add Mission statement here'
                      )
                    ),
                    Container(
                      child: SelectableText(
                        'Add Overview of functionality here'
                      )
                    ),
                    Container(
                      child: SelectableText(
                        'Add Github repo link if we go open source here'
                      )
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

