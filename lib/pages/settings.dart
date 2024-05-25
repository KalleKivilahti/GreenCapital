import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepv2/settings_model.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsModel>(
        builder: (context, settings, child) {
          return ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: settings.isDarkMode,
                onChanged: (bool value) {
                  settings.toggleDarkMode();
                },
              ),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: settings.notificationsEnabled,
                onChanged: (bool value) {
                  settings.setNotificationsEnabled(value);
                },
              ),
              ListTile(
                title: const Text('Daily Step Goal'),
                subtitle: Text(settings.stepGoal.toString()),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  int? newGoal = await _editStepGoal(context, settings.stepGoal);
                  if (newGoal != null) {
                    settings.setStepGoal(newGoal);
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Use Metric Units'),
                value: settings.isMetric,
                onChanged: (bool value) {
                  settings.setMetricUnits(value);
                },
              ),
              const ListTile(
                title: Text('App Version'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Send Feedback'),
                trailing: const Icon(Icons.feedback),
                onTap: () {
                  // Navigate to feedback page or open mail client
                },
              ),
              ListTile(
                title: const Text('About'),
                trailing: const Icon(Icons.info),
                onTap: () {
                  // Show about dialog or navigate to about page
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<int?> _editStepGoal(BuildContext context, int currentGoal) async {
    TextEditingController controller = TextEditingController(text: currentGoal.toString());
    return await showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Step Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter step goal',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(controller.text));
              },
            ),
          ],
        );
      },
    );
  }
}
