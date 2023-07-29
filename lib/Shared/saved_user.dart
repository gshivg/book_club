import 'package:shared_preferences/shared_preferences.dart';

class SavedUserSharedPreferences {
  static const String preferenceKey = "savedUserPreference";

  void setUser(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(preferenceKey, uid);
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(preferenceKey);
  }

  void removeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(preferenceKey);
  }
}
