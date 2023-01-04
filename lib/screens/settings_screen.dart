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
  void initialThemeMode() async {
    appTheme.isDarkTheme = await preference.getTheme();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    initialThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text("Edit profle"),
            onTap: () {
              context.push('/editProfile');
            },
          ),
          SwitchListTile(
              secondary: Icon(Icons.dark_mode_outlined),
              title: Text("Dark mode"),
              value: appTheme.isDarkTheme,
              onChanged: (value) {
                setState(() {
                  appTheme.toggleTheme();
                  preference.setDarkTheme(value);
                });
              })
        ],
      ),
    );
  }
}
