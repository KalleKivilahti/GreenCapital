// step_count_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StepCountService {
  Future<int> fetchStepsToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('stepsToday') ?? 0;
  }
}

  Future<List<int>> getWeeklySteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return List<int>.generate(7, (index) => prefs.getInt('day_$index') ?? 0);
  }

  Future<void> saveTodaySteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps_today', steps);
  }

  Future<void> saveWeeklySteps(List<int> steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < steps.length; i++) {
      await prefs.setInt('day_$i', steps[i]);
    }
  }
