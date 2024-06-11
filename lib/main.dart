import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stepv2/pages/home.dart';
import 'package:provider/provider.dart';
import 'settings_model.dart';
import 'google_fit_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBq7IAjP6i4P-_eR72p3q6bFbzQ3_4hPxU',
      appId: '1:174525905693:android:3176b46cad9c909258bff4',
      messagingSenderId: '174525905693',
      projectId: 'green-fit-42406',
      authDomain: 'green-fit-42406.firebaseapp.com',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        Provider(create: (_) => GoogleFitService()), 
      ],
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
          title: 'Flutter Firebase Auth Demo',
          debugShowCheckedModeBanner: false,
          theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    _fetchAndLogSteps();
  }

  Future<void> _checkCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithPopup(googleProvider);

      setState(() {
        _user = userCredential.user;
      });

      if (_user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _user = null;
      });
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _fetchAndLogSteps() async {
    GoogleFitService googleFitService = Provider.of<GoogleFitService>(context, listen: false);
    int steps = await googleFitService.getSteps();
    print('Steps today: $steps');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Auth Demo'),
      ),
      body: Center(
        child: _user == null
            ? ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Sign In with Google'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Signed in as:'),
                  Text(_user!.displayName ?? 'Unknown'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}


