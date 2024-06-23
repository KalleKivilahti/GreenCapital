import 'package:shared_preferences/shared_preferences.dart';

class StepCountService {
  Future<int> fetchStepsToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('steps_today') ?? 0;
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

  Future<void> updateWeeklyStepsAndPoints(int todaySteps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current weekly steps
    List<int> weeklySteps = List<int>.generate(7, (index) => prefs.getInt('day_$index') ?? 0);

    // Update points
    int points = prefs.getInt('points') ?? 0;
    points += todaySteps; // Assume 1 step = 1 point, adjust if needed
    await prefs.setInt('points', points);

    // Shift the steps to the left and add today's steps as the last entry
    for (int i = 0; i < 6; i++) {
      weeklySteps[i] = weeklySteps[i + 1];
    }
    weeklySteps[6] = todaySteps;

    // Save the updated weekly steps back to SharedPreferences
    await saveWeeklySteps(weeklySteps);

    // Clear today's steps
    await prefs.remove('steps_today');
  }

  // Debug method to manually add steps and print the state
  Future<void> debugAddSteps(int steps) async {
    // Save today's steps
    await saveTodaySteps(steps);
    
    // Update weekly steps and points
    await updateWeeklyStepsAndPoints(steps);
    
    // Fetch the updated weekly steps and points
    int todaySteps = await fetchStepsToday();
    List<int> weeklySteps = await getWeeklySteps();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt('points') ?? 0;
    
    // Print the current state for debugging
    print('Today\'s Steps: $todaySteps');
    print('Weekly Steps: $weeklySteps');
    print('Total Points: $points');
  }
}
