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
    apiKey: 'AIzaSyDMKRfghOhCjjvJ5CYdH0Q0LzdxHNTOJCA',
    appId: '1:737995419164:web:113cc872168f4740cf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    authDomain: 'walletlite-c22d7.firebaseapp.com',
    storageBucket: 'walletlite-c22d7.firebasestorage.app',
    measurementId: 'G-SYYLLYK0QW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdnkBIdFJTNSA9AMbv4fCi-fQkI45bTzM',
    appId: '1:737995419164:android:cfeecde20b44c3bfcf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    storageBucket: 'walletlite-c22d7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZcFpsLaL1wWV_LkuRsLdD8MU6ogUKl6s',
    appId: '1:737995419164:ios:56b41487618d9db4cf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    storageBucket: 'walletlite-c22d7.firebasestorage.app',
    androidClientId: '737995419164-iqgs83k4rcsa18blhvp5vjgujg17ijbt.apps.googleusercontent.com',
    iosClientId: '737995419164-k1rf42svprs2upnlujkpg9i78i7bh65v.apps.googleusercontent.com',
    iosBundleId: 'com.example.walletlite',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZcFpsLaL1wWV_LkuRsLdD8MU6ogUKl6s',
    appId: '1:737995419164:ios:56b41487618d9db4cf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    storageBucket: 'walletlite-c22d7.firebasestorage.app',
    androidClientId: '737995419164-iqgs83k4rcsa18blhvp5vjgujg17ijbt.apps.googleusercontent.com',
    iosClientId: '737995419164-k1rf42svprs2upnlujkpg9i78i7bh65v.apps.googleusercontent.com',
    iosBundleId: 'com.example.walletlite',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDMKRfghOhCjjvJ5CYdH0Q0LzdxHNTOJCA',
    appId: '1:737995419164:web:67c665dbed33985fcf39d9',
    messagingSenderId: '737995419164',
    projectId: 'walletlite-c22d7',
    authDomain: 'walletlite-c22d7.firebaseapp.com',
    storageBucket: 'walletlite-c22d7.firebasestorage.app',
    measurementId: 'G-V71XTVCBZ9',
  );

}
