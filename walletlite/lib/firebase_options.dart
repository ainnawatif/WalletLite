import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// To get these values:
/// 1. Go to Firebase Console: https://console.firebase.google.com/
/// 2. Select your project (or create a new one)
/// 3. Go to Project Settings (gear icon)
/// 4. Under "Your apps", find your Android/iOS app
/// 5. Copy the required values from google-services.json or GoogleService-Info.plist
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',  // From Firebase Console - Project Settings > Web App
    appId: '1:737995419164:web:YOUR_WEB_APP_ID',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    authDomain: 'walletlite-c22d7.firebaseapp.com',
    databaseURL: 'https://walletlite-c22d7.firebaseio.com',
    storageBucket: 'walletlite-c22d7.appspot.com',
    measurementId: 'G-YOUR_MEASUREMENT_ID',  // From Firebase Console > Web App settings
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',  // From google-services.json or Firebase Console
    appId: '1:737995419164:android:cfeecde20b44c3bfcf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    databaseURL: 'https://walletlite-c22d7.firebaseio.com',
    storageBucket: 'walletlite-c22d7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_iOS_API_KEY',  // From GoogleService-Info.plist or Firebase Console
    appId: '1:737995419164:ios:YOUR_iOS_APP_ID',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    databaseURL: 'https://walletlite-c22d7.firebaseio.com',
    storageBucket: 'walletlite-c22d7.appspot.com',
    iosBundleId: 'com.example.walletlite',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_macOS_API_KEY',  // From GoogleService-Info.plist or Firebase Console
    appId: '1:737995419164:macos:YOUR_macOS_APP_ID',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    databaseURL: 'https://walletlite-c22d7.firebaseio.com',
    storageBucket: 'walletlite-c22d7.appspot.com',
    iosBundleId: 'com.example.walletlite',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',  // From Firebase Console > Web App settings
    appId: '1:737995419164:windows:YOUR_WINDOWS_APP_ID',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    authDomain: 'walletlite-c22d7.firebaseapp.com',
    databaseURL: 'https://walletlite-c22d7.firebaseio.com',
    storageBucket: 'walletlite-c22d7.appspot.com',
  );
}

