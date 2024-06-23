import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepv2/settings_model.dart';
import 'pages/home.dart';
import 'pages/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Green Fit',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 141, 237, 164),
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 141, 237, 164),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
          routes: {
            '/homePage': (context) => const HomePage(),
            '/settings': (context) => const SettingsPage(),
          },
        );
      },
    );
  }
}
