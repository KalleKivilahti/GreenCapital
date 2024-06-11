import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalPoints();
  }

  Future<void> _loadTotalPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalPoints = prefs.getInt('totalPoints') ?? 100;
    });
  }

  Future<void> _saveTotalPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalPoints', points);
  }

  void _redeemReward(int points) {
    setState(() {
      _totalPoints -= points;
    });
    _saveTotalPoints(_totalPoints);
  }

  void _debugIncreasePoints() {
    setState(() {
      _totalPoints += 100;
    });
    _saveTotalPoints(_totalPoints);
  }

  Widget _buildRewardItem(
      BuildContext context, String title, String description, int points) {
    return GestureDetector(
      onTap: () {
        if (_totalPoints >= points) {
          _redeemReward(points);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reward redeemed: $title')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Insufficient points to redeem: $title')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 31, 30, 35)
              : const Color.fromARGB(255, 141, 237, 164),
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
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cost: $points points',
              style: const TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: ListView(
        children: [
          _buildRewardItem(
              context, 'Reward 1', 'Description of Reward 1', 50),
          _buildRewardItem(
              context, 'Reward 2', 'Description of Reward 2', 75),
          _buildRewardItem(
              context, 'Reward 3', 'Description of Reward 3', 100),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Points: $_totalPoints',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 141, 237, 164)
                      : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _debugIncreasePoints,
                icon: const Icon(Icons.add),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RewardsPage(),
  ));
}
