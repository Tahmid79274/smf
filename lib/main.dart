import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smf/screens/navigation/home_screen.dart';
import 'package:smf/utils/functionalities/shared_prefs_manager.dart';
import 'screens/auth/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/functionalities/functions.dart';


const firebaseConfig = {
  // Required for Firebase Realtime Database
  'databaseURL': 'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/', // Replace with your project ID
  // ... other Firebase services configuration options (optional)
};

bool isLoggedIn = false;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); // For Flutter versions below 2.8
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('Before initialization:${GlobalVar.basePath}');
      GlobalVar.basePath = user.email!.replaceAll('.', '_');
      print('Before initialization:${GlobalVar.basePath}');
      print('User is signed in! and the user is ${user.displayName}');
    }
  });
  // isLoggedIn = await SharedPrefsManager.getSplashStatus();
  // GlobalVar.basePath = await SharedPrefsManager.getUID();
  // print('UserID:${GlobalVar.basePath}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: GlobalVar.basePath!=''?HomeScreen():WelcomeScreen(),
      );
  }
}
