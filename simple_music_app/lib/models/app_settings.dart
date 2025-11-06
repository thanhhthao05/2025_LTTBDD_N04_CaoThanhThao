import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  bool _darkMode = false;
  Locale _locale = const Locale('vi');

  bool get darkMode => _darkMode;
  Locale get locale => _locale;

  void setDarkMode(bool v) {
    if (_darkMode == v) return;
    _darkMode = v;
    notifyListeners();
  }

  void setLocale(Locale l) {
    if (_locale == l) return;
    _locale = l;
    notifyListeners();
  }
}
