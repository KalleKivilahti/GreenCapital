import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  bool isDarkMode = true;
  bool notificationsEnabled = false;
  int stepGoal = 10000;
  bool isMetric = true;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void setStepGoal(int goal) {
    stepGoal = goal;
    notifyListeners();
  }

  void setMetricUnits(bool value) {
    isMetric = value;
    notifyListeners();
  }
}
