import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const darkMode = "darkMode";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkMode, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkMode) ?? false;
  }
}
