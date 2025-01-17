import 'package:chat_wave/chat_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPreferencesServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<String?> register(context, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? tokenID = await userCredential.user?.getIdToken();
      if (tokenID != null) {
        saveToken(tokenID);
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChatPage.id,
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('This is the registration error!');
        print(e.toString());
      }
    }
    return null;
  }

  Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_token', token);
  }

  Future<void> logOut() async {
    final pref = await SharedPreferences.getInstance();
    _auth.signOut();
    _googleSignIn.signOut();
    await pref.remove('auth_token');
  }

  Future<bool> isUserLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey('auth_token') || _auth.currentUser != null;
  }
}
