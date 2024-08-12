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

  void toggleTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setBool('isDarkMode', true);
    } else {
      themeData = lightMode;
      prefs.setBool('isDarkMode', false);
    }

    switch (theme) {
      case 'isDarkMode':
        
        break;
      case 'isLightMode':

        break;
      case 'isGreyMode':

        break;

      default:
      
    }

  }

  void greyModeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeData = mode1;
    prefs.setString('selectedTheme', 'greyMode');
  }

  void lightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeData = lightMode;
    prefs.setString('selectedTheme', 'lightMode');
  }

  void darkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeData = darkMode;
    prefs.setString('selectedTheme', 'darkMode');
  }
}