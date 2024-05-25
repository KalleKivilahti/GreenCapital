import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rewards.dart';
import 'settings.dart';
import 'profile.dart';
import 'points.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showIcons = false;
  int _stepsToday = 0;
  Stream<StepCount>? _stepCountStream;
  List<int> _weeklySteps = List.filled(7, 0); // Steps holder 

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _loadWeeklySteps();
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _stepsToday = event.steps;
      _updateWeeklySteps();
    });
  }

  void _onStepCountError(error) {
    print("Pedometer Error: $error");
  }

  Future<void> _loadWeeklySteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Pulls from android step count the data
    setState(() {
      _weeklySteps = List<int>.generate(7, (index) => prefs.getInt('day_$index') ?? 0);
    });
  }

  Future<void> _updateWeeklySteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int today = DateTime.now().weekday % 7;
    _weeklySteps[today] = _stepsToday;
    await prefs.setInt('day_$today', _stepsToday);
  }

  void _toggleIcons() {
    setState(() {
      _showIcons = !_showIcons;
    });
  }

  void _onRewardsDealTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RewardsPage()),
    );
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
      MaterialPageRoute(builder: (context) => const ProfilePage())
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return appBar();
  }

  Scaffold appBar() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Green Capital',
          style: TextStyle(
            color: Color.fromARGB(255, 141, 237, 164),
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _toggleIcons,
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 37,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 141, 237, 164),
                borderRadius: BorderRadius.circular(50),
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
            top: 30.0,
            left: 0,
            right: 0,
            child: Text(
              'Steps today',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: 70.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 100, 
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 30),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 30),
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
                      const SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _onRewardsDealTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 141, 237, 164),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Rewards',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
            bottom: 650,
            right: 11,
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
        width: 35,
        height: 35,
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
}
