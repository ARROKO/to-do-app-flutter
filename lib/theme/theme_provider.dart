import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;
  
  ThemeProvider({bool? isDarkMode}){
    _themeData = (isDarkMode == true && isDarkMode != null) ? darkMode : lightMode;
  }
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setBool('isDarkMode', true);
    } else {
      themeData = lightMode;
      prefs.setBool('isDarkMode', false);
    }
  }

  void greyModeTheme() async {
    themeData = mode1;
  }
  void lightTheme() async {
    themeData = lightMode;
  }
  void darkTheme() async {
    themeData = darkMode;
  }
}