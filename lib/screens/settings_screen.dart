import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/prefrences/DarkThemePrefrence.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DarkThemePreference preference = DarkThemePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text("Edit profle"),
            onTap: () {
              // context.push('/editProfile');
            },
          ),
          SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text("Dark mode"),
              value: appTheme.isDarkTheme,
              onChanged: (value) {
                setState(() {
                  appTheme.toggleTheme();
                  preference.setDarkTheme(appTheme.isDarkTheme);
                });
              })
        ],
      ),
    );
  }
}
