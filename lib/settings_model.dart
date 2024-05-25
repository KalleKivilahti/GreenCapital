import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel with ChangeNotifier {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  int _stepGoal = 10000;
  bool _isMetric = true;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  int get stepGoal => _stepGoal;
  bool get isMetric => _isMetric;

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _stepGoal = prefs.getInt('stepGoal') ?? 10000;
    _isMetric = prefs.getBool('isMetric') ?? true;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  Future<void> setStepGoal(int value) async {
    _stepGoal = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepGoal', _stepGoal);
    notifyListeners();
  }

  Future<void> setMetricUnits(bool value) async {
    _isMetric = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMetric', _isMetric);
    notifyListeners();
  }
}
