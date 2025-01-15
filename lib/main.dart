import 'package:flutter/material.dart';
import 'package:chat_wave/chat_page.dart';
import 'package:chat_wave/splash_page.dart';
import 'package:chat_wave/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.id,
      routes: {
        ChatPage.id: (context) => ChatPage(),
        SplashPage.id: (context) => SplashPage(),
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}
