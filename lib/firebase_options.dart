// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAo0I_U_tprxLTmwTyUvUyl81MGz5lrj8c',
    appId: '1:445595029659:web:ac9801cdae7a7bea93b63e',
    messagingSenderId: '445595029659',
    projectId: 'meesho-dice-9bfa9',
    authDomain: 'meesho-dice-9bfa9.firebaseapp.com',
    storageBucket: 'meesho-dice-9bfa9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBULXJ7eFITOFfwOQYM0eDdp9-WaAU799o',
    appId: '1:445595029659:android:eaca0cfb735a13b093b63e',
    messagingSenderId: '445595029659',
    projectId: 'meesho-dice-9bfa9',
    storageBucket: 'meesho-dice-9bfa9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFDCcYmUBITMFT8k5BEzjLfHmd7Aqm-bk',
    appId: '1:445595029659:ios:21da0901064c7fed93b63e',
    messagingSenderId: '445595029659',
    projectId: 'meesho-dice-9bfa9',
    storageBucket: 'meesho-dice-9bfa9.appspot.com',
    iosBundleId: 'com.example.meeshoDice',
  );
}
