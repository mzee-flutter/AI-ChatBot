import 'package:chat_wave/shared_preferences_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'login_page.dart';

class CheckingTokenSession {
  final pref_services = SharedPreferencesServices();

  Future<void> checkUserAuthentication(context) async {
    pref_services.isUserLoggedIn().then((isLogIn) async {
      if (context.mounted) {
        if (isLogIn) {
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushNamedAndRemoveUntil(
            context,
            ChatPage.id,
            (route) => false,
          );
        } else {
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (route) => false,
          );
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
        print('Error during Authentication!!');
      }
    });
  }
}
