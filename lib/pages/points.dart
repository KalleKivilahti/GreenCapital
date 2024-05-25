import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({super.key});

  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int _points = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points'),
      ),
      body: Center(
        child: Text(
          'You have $_points points',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
