import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: const Center(
        child: Text(
          'Rewards Details',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
