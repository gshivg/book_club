// ignore_for_file: constant_identifier_names

// Imported Dependencies
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSharedPreferences {
  static const PREF_KEY = "themePreference";

  void setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_KEY, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY) ?? false;
  }

  void removeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(PREF_KEY);
  }
}
