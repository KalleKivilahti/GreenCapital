import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'settings.dart';
import 'profile.dart';
import 'step_count_service.dart';
import 'points.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showIcons = false;
  int _points = 0;
  List<int> _weeklySteps = List.filled(7, 0);
  var _stepsToday = 0;

  final StepCountService _stepCountService = StepCountService();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadPoints();
    _loadWeeklySteps();
    _loadStepsToday();
  }

Future<void> _checkPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.activityRecognition,
    Permission.sensors,
  ].request();

  // Check if permissions are granted
  bool isActivityRecognitionGranted = statuses[Permission.activityRecognition]?.isGranted ?? false;
  bool isSensorsGranted = statuses[Permission.sensors]?.isGranted ?? false;

  if (isActivityRecognitionGranted && isSensorsGranted) {
    // Permissions granted
    _updateStepsAndPoints();
  } else {
    // Handle permission denial
    _showPermissionDeniedDialog();
  }
}

void _showPermissionDeniedDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permissions Denied'),
      content: const Text(
          'This app requires permissions to access activity and sensors to count steps. Please enable them in settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('totalPoints') ?? 0;
    });
  }

  Future<void> _loadWeeklySteps() async {
    List<int> steps = await _stepCountService.getWeeklySteps();
    setState(() {
      _weeklySteps = steps;
    });
  }

  Future<void> _loadStepsToday() async {
    int stepsToday = await _stepCountService.fetchStepsToday();
    setState(() {
      _stepsToday = stepsToday;
    });
  }

  Future<void> _addStepsForDebug(int steps) async {
    int currentSteps = await _stepCountService.fetchStepsToday();
    await _stepCountService.saveTodaySteps(currentSteps + steps);
    await _updateStepsAndPoints();
  }

  Future<void> _updateStepsAndPoints() async {
    int stepsToday = await _stepCountService.fetchStepsToday();
    await _stepCountService.updateWeeklyStepsAndPoints(stepsToday);
    _loadPoints();
    _loadWeeklySteps();
    _loadStepsToday();
  }

  void _toggleIcons() {
    setState(() {
      _showIcons = !_showIcons;
    });
  }

  void _onPointsTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PointsPage()),
    );
  }

  void _onSettingsTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _onProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Green Fit',
          style: TextStyle(
            color: Color.fromARGB(255, 141, 237, 164),
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _toggleIcons,
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 50,
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 141, 237, 164),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.dashboard_customize_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 10.0,
            left: 0,
            right: 0,
            child: Text(
              'Steps today',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.07,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 31, 30, 35)
                        : const Color.fromARGB(255, 222, 230, 239),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 141, 237, 164),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_stepsToday steps',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 141, 237, 164),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  height: screenHeight * 0.65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 31, 30, 35)
                        : const Color.fromARGB(255, 222, 230, 239),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 141, 237, 164),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Steps per day',
                        style: TextStyle(
                          color: Color.fromARGB(255, 141, 237, 164),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: _generateBarData(),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const style = TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      );
                                      Widget text;
                                      switch (value.toInt()) {
                                        case 0:
                                          text = const Text('Mon', style: style);
                                          break;
                                        case 1:
                                          text = const Text('Tue', style: style);
                                          break;
                                        case 2:
                                          text = const Text('Wed', style: style);
                                          break;
                                        case 3:
                                          text = const Text('Thu', style: style);
                                          break;
                                        case 4:
                                          text = const Text('Fri', style: style);
                                          break;
                                        case 5:
                                          text = const Text('Sat', style: style);
                                          break;
                                        case 6:
                                          text = const Text('Sun', style: style);
                                          break;
                                        default:
                                          text = const Text('', style: style);
                                          break;
                                      }
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: text,
                                      );
                                    },
                                    reservedSize: 20,
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.68,
            right: screenWidth * 0.035,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onPointsTap,
                  child: _buildAnimatedSmallIcon(Icons.currency_exchange, 3),
                ),
                GestureDetector(
                  onTap: _onProfileTap,
                  child: _buildAnimatedSmallIcon(Icons.person, 1),
                ),
                GestureDetector(
                  onTap: _onSettingsTap,
                  child: _buildAnimatedSmallIcon(Icons.settings, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSmallIcon(IconData icon, int index) {
    return AnimatedOpacity(
      opacity: _showIcons ? 1.0 : 0.0,
      duration: Duration(milliseconds: 100 + (index * 100)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 141, 237, 164),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  List<BarChartGroupData> _generateBarData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _weeklySteps[index].toDouble(),
            color: const Color.fromARGB(255, 141, 237, 164),
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }

  Color _colorForBar(int index) {
    if (index % 2 == 0) {
      return const Color.fromARGB(255, 141, 237, 164);
    } else {
      return const Color.fromARGB(255, 61, 165, 244);
    }
  }
}
