import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'chat_page.dart';
import 'shared_preferences_services.dart';
import 'package:flutter/material.dart';

class GoogleSignInServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final preferenceService = SharedPreferencesServices();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      String? tokenID = await userCredential.user?.getIdToken();
      if (tokenID != null) {
        preferenceService.saveToken(tokenID);
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChatPage.id,
          (route) => false,
        );
      }
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
