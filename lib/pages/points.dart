import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({super.key});

  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int _points = 0;
  final List<RewardOption> _rewardOptions = [
    RewardOption(
        title: 'Option 1', points: 50, description: 'Description of Option 1'),
    RewardOption(
        title: 'Option 2', points: 75, description: 'Description of Option 2'),
    RewardOption(
        title: 'Option 3', points: 100, description: 'Description of Option 3'),
    RewardOption(
        title: 'Option 4', points: 125, description: 'Description of Option 4'),
    RewardOption(
        title: 'Option 5', points: 150, description: 'Description of Option 5'),
    RewardOption(
        title: 'Option 6', points: 175, description: 'Description of Option 6'),
    RewardOption(
        title: 'Option 7', points: 200, description: 'Description of Option 7'),
    RewardOption(
        title: 'Option 8', points: 225, description: 'Description of Option 8'),
    RewardOption(
        title: 'Option 9', points: 250, description: 'Description of Option 9'),
    RewardOption(
        title: 'Option 10', points: 275, description: 'Description of Option 10'),
    RewardOption(
        title: 'Option 11', points: 300, description: 'Description of Option 11'),
    RewardOption(
        title: 'Option 12', points: 325, description: 'Description of Option 12'),
    RewardOption(
        title: 'Option 13', points: 350, description: 'Description of Option 13'),
    RewardOption(
        title: 'Option 14', points: 375, description: 'Description of Option 14'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> _redeemPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentPoints = prefs.getInt('points') ?? 0;
    if (currentPoints >= points) {
      currentPoints -= points;
      prefs.setInt('points', currentPoints);
      setState(() {
        _points = currentPoints;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Points redeemed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient points to redeem this option.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have $_points points',
                style: const TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _rewardOptions
                    .map((option) => GestureDetector(
                          onTap: () => _redeemPoints(option.points),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness == Brightness.dark
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  option.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  option.description,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${option.points} points',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RewardOption {
  final String title;
  final int points;
  final String description;

  RewardOption({
    required this.title,
    required this.points,
    required this.description,
  });
}
