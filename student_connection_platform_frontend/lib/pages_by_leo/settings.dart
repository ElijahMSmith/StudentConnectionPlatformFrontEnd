import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: ListView(
        children: [
          Switch.adaptive(
              value: themeProvider.isDarkTheme,
              onChanged: (value) {
                final localThemeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                localThemeProvider.toggleTheme(value);
              }),
        ],
      ),
    );
  }
}
