import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? selectedThemeOption = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Theme'),
          ),
          RadioListTile(
            title: Text('Light'),
            value: 'Light',
            groupValue: selectedThemeOption,
            onChanged: (value) {
              setState(() {
                selectedThemeOption = value as String?;
                _changeTheme();
              });
            },
          ),
          RadioListTile(
            title: Text('Dark'),
            value: 'Dark',
            groupValue: selectedThemeOption,
            onChanged: (value) {
              setState(() {
                selectedThemeOption = value as String?;
                _changeTheme();
              });
            },
          ),
        ],
      ),
    );
  }

  void _changeTheme() {
    if (selectedThemeOption == 'Light') {
      // Set light theme
      // Example: ThemeData.light()
      // Replace with your desired light theme configuration
    } else if (selectedThemeOption == 'Dark') {
      // Set dark theme
      // Example: ThemeData.dark()
      // Replace with your desired dark theme configuration
    }
  }
}