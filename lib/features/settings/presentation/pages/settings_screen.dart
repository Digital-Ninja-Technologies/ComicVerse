import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          SwitchListTile(
              value: true,
              onChanged: null,
              title: Text('Cached images'),
              subtitle: Text('Keep covers and pages available locally')),
          SwitchListTile(
              value: true,
              onChanged: null,
              title: Text('Push notifications'),
              subtitle: Text('Firebase Cloud Messaging chapter alerts')),
          ListTile(
              leading: Icon(Icons.palette_outlined),
              title: Text('Theme'),
              subtitle: Text('Follows system light and dark mode')),
          ListTile(
              leading: Icon(Icons.security_rounded),
              title: Text('Security'),
              subtitle: Text('Firebase Auth guards and secure local tokens')),
        ],
      ),
    );
  }
}
