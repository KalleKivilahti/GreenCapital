import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'settings_model.dart';
import 'google_fit_service.dart';
import 'pages/home.dart'; 
import 'package:google_sign_in/google_sign_in.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Green Fit Login',
          debugShowCheckedModeBanner: false,
          theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const MyHomePage(),
          routes: {
            '/home': (context) => const MyHomePage(),
            '/homePage': (context) => const HomePage(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
  }

  Future<void> _checkCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        setState(() {
          _user = userCredential.user;
        });
        if (_user != null) {
          await _checkAndPromptConsent(googleSignIn);
          Navigator.of(context).pushReplacementNamed('/homePage');
        }
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

  Future<void> _signInLater() async {
    Navigator.of(context).pushReplacementNamed('/homePage');
  }

  Future<void> _checkAndPromptConsent(GoogleSignIn googleSignIn) async {
    final bool hasPermissions = await googleSignIn.requestScopes(['https://www.googleapis.com/auth/fitness.activity.read']);
    if (hasPermissions) {
      print('User has granted consent for Google Fit data access.');
      // Proceed with fetching fitness data
      // For simplicity, we'll just print a message here
      print('Fetching fitness data...');
    } else {
      print('User has not granted consent for Google Fit data access.');
      // Prompt the user to grant consent
      // You can use packages like url_launcher to open the consent page in a browser
      // For simplicity, we'll just print a message here
      print('Prompting user to grant consent...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Fit Login'),
      ),
      body: Center(
        child: _user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: const Text('Sign In with Google'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _signInLater,
                    child: const Text('Sign In Later'),
                  ),
                ],
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
