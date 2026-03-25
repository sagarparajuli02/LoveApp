import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Mobile-only GoogleSignIn instance
  final GoogleSignIn? _googleSignIn = kIsWeb ? null : GoogleSignIn.instance;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // ==== Web Flow ====
      try {
        // Use Firebase Auth popup for web
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _firebaseAuth.signInWithPopup(googleProvider);
      } catch (e) {
        print('Web sign-in error: $e');
        return null;
      }
    } else {
      // ==== Mobile (iOS/Android) Flow ====
      try {
        final gUser = await _googleSignIn!.authenticate();

        final gAuth = gUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: gAuth.idToken,
        );

        return await _firebaseAuth.signInWithCredential(credential);
      } catch (e) {
        print('Mobile sign-in error: $e');
        return null;
      }
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn?.signOut();
    }
    await _firebaseAuth.signOut();
  }
}
