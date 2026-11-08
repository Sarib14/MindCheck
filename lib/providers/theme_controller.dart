
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool isDarkMode = false;

  Future<void> loadTheme() async {
    final preferences = await SharedPreferences.getInstance();

    isDarkMode = preferences.getBool('mindcheck_dark_mode') ?? false;

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    isDarkMode = value;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool('mindcheck_dark_mode', value);

    notifyListeners();
  }
}
