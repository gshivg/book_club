// This file contains the ThemeSharedPreferences class which is used to store the theme preference in shared preferences.

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
}
