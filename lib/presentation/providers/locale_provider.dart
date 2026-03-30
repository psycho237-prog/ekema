import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'fr') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('fr');
    }
    notifyListeners();
  }
}
