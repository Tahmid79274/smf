import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/navigation/navigation_screen.dart';


const firebaseConfig = {
  // Required for Firebase Realtime Database
  'databaseURL': 'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/', // Replace with your project ID
  // ... other Firebase services configuration options (optional)
};

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); // For Flutter versions below 2.8
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: const NavigationScreen(),
      );
  }
}
