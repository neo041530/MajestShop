// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCTN_xuKAp9D6mQhlOSnV8lwQQcNcORSWo',
    appId: '1:450945608724:web:07252f82ac6fb9030e4b01',
    messagingSenderId: '450945608724',
    projectId: 'majestyshop-eb1a7',
    authDomain: 'majestyshop-eb1a7.firebaseapp.com',
    storageBucket: 'majestyshop-eb1a7.appspot.com',
    measurementId: 'G-02NNHRYFR0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrBX5F3s6OxI5CSAgpZO9FPsS7GHBTYSQ',
    appId: '1:450945608724:android:f84a20e5a780702b0e4b01',
    messagingSenderId: '450945608724',
    projectId: 'majestyshop-eb1a7',
    storageBucket: 'majestyshop-eb1a7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFUNOJ5_gj5mgpG5DeNsW_1AdepHxPcYw',
    appId: '1:450945608724:ios:f8493370028011f70e4b01',
    messagingSenderId: '450945608724',
    projectId: 'majestyshop-eb1a7',
    storageBucket: 'majestyshop-eb1a7.appspot.com',
    iosClientId: '450945608724-gm3e5gf6m010pgpe8ftm4jj407um2v4b.apps.googleusercontent.com',
    iosBundleId: 'neo.neoproject.majestyshop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFUNOJ5_gj5mgpG5DeNsW_1AdepHxPcYw',
    appId: '1:450945608724:ios:f8493370028011f70e4b01',
    messagingSenderId: '450945608724',
    projectId: 'majestyshop-eb1a7',
    storageBucket: 'majestyshop-eb1a7.appspot.com',
    iosClientId: '450945608724-gm3e5gf6m010pgpe8ftm4jj407um2v4b.apps.googleusercontent.com',
    iosBundleId: 'neo.neoproject.majestyshop',
  );
}
