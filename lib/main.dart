import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_service/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re:fill',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
