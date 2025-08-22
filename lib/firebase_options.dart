// Placeholder Firebase options for development.
// This file will be auto-generated and overwritten by `flutterfire configure`.
// It's safe to keep this stub so the app compiles before Firebase setup.

// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'stub',
        appId: 'stub',
        messagingSenderId: 'stub',
        projectId: 'stub',
        storageBucket: 'stub',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'stub',
          appId: 'stub',
          messagingSenderId: 'stub',
          projectId: 'stub',
          storageBucket: 'stub',
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'stub',
          appId: 'stub',
          messagingSenderId: 'stub',
          projectId: 'stub',
          iosClientId: 'stub',
          iosBundleId: 'stub',
          storageBucket: 'stub',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'stub',
          appId: 'stub',
          messagingSenderId: 'stub',
          projectId: 'stub',
          storageBucket: 'stub',
        );
      default:
        return const FirebaseOptions(
          apiKey: 'stub',
          appId: 'stub',
          messagingSenderId: 'stub',
          projectId: 'stub',
          storageBucket: 'stub',
        );
    }
  }
}

