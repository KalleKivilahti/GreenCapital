import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepv2/pages/home.dart';
import 'settings_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsModel()..loadSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poetsen',
            colorSchemeSeed: const Color.fromARGB(255, 76, 107, 175),
            brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

