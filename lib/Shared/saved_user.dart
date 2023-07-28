// ignore_for_file: constant_identifier_names

// Imported Dependencies
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SavedUserSharedPreferences {
  static const PREF_KEY = "savedUserPreference";

  void setUser(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PREF_KEY, uid);
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PREF_KEY);
  }

  void removeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(PREF_KEY);
  }
}
