import 'package:flutter/material.dart';
import 'package:flutter_bilibili/constants/constatns.dart';
import 'package:vt_utils/vt_utils.dart';

class ThemeProvider with ChangeNotifier {
  var _themeMode = ThemeMode.system;
  ThemeProvider() {
    final themeValue = SpUtil.getString(Constants.spThemeValue);
    if (themeValue == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeValue == 'dart') {
      _themeMode = ThemeMode.dark;
    }
  }

  ThemeMode get themeMode => _themeMode;

  String get themeModeValue {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode themeMode) {
    if (themeMode == _themeMode) {
      return;
    }

    _themeMode = themeMode;
    SpUtil.putString(Constants.spThemeValue, _themeMode.toString());
    notifyListeners();
  }
}
