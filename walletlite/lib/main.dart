import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';
import 'auth/splash_page.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'WalletLite',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFEFF6FB),
      ),
      //home: const HomePage(),
      home: const SplashPage(),
    );
  }
}
