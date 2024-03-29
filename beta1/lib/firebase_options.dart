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
    apiKey: 'AIzaSyCfnSu-P6kT9hFeK620qOlUFX2rGluYJ3s',
    appId: '1:381771283279:web:caccedbb5c02d68fb1e33a',
    messagingSenderId: '381771283279',
    projectId: 'autovolley-85d29',
    authDomain: 'autovolley-85d29.firebaseapp.com',
    databaseURL: 'https://autovolley-85d29-default-rtdb.firebaseio.com',
    storageBucket: 'autovolley-85d29.appspot.com',
    measurementId: 'G-KJKLX77P61',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7LR1UxHslOMlYyNi2Kb4ZDuQgUW18dxc',
    appId: '1:381771283279:android:6ff0d083c0698f1cb1e33a',
    messagingSenderId: '381771283279',
    projectId: 'autovolley-85d29',
    databaseURL: 'https://autovolley-85d29-default-rtdb.firebaseio.com',
    storageBucket: 'autovolley-85d29.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByDSi2WNx1R7b_I3FSpNHdbiX05BtXNZg',
    appId: '1:381771283279:ios:edbac5ca0e566d53b1e33a',
    messagingSenderId: '381771283279',
    projectId: 'autovolley-85d29',
    databaseURL: 'https://autovolley-85d29-default-rtdb.firebaseio.com',
    storageBucket: 'autovolley-85d29.appspot.com',
    iosClientId: '381771283279-k0eeere05ke91lhqisn93kg0rhaucrnv.apps.googleusercontent.com',
    iosBundleId: 'com.example.beta1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByDSi2WNx1R7b_I3FSpNHdbiX05BtXNZg',
    appId: '1:381771283279:ios:edbac5ca0e566d53b1e33a',
    messagingSenderId: '381771283279',
    projectId: 'autovolley-85d29',
    databaseURL: 'https://autovolley-85d29-default-rtdb.firebaseio.com',
    storageBucket: 'autovolley-85d29.appspot.com',
    iosClientId: '381771283279-k0eeere05ke91lhqisn93kg0rhaucrnv.apps.googleusercontent.com',
    iosBundleId: 'com.example.beta1',
  );
}
