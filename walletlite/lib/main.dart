import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('\n' + '='*50);
  print('🚀 Starting Firebase Initialization...');
  print('='*50);
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✓ Firebase initialized successfully!');
    print('✓ Firestore is ready to use');
    print('='*50 + '\n');
  } catch (e) {
    print('✗ Firebase initialization failed!');
    print('Error: $e');
    print('❌ Make sure you updated firebase_options.dart with real credentials!');
    print('='*50 + '\n');
  }
  
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
        useMaterial3: true,

        // 1. Define the Main Color Scheme
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F4D6B)),

        // 2. GLOBAL BUTTON STYLE (Blue Background, White Text)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F4D6B), 
            foregroundColor: Colors.white,           
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: const Size(double.infinity, 50), 
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

