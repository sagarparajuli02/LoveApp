import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // =========================
  // GOOGLE SIGN IN
  // =========================
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web uses popup
        final GoogleAuthProvider provider = GoogleAuthProvider();
        return await _firebaseAuth.signInWithPopup(provider);
      } else {
        // Mobile flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return null; // User cancelled
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // =========================
  // SIGN OUT
  // =========================
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  }
}
