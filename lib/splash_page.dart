import 'package:flutter/material.dart';
import 'package:chat_wave/checking_token_session.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splash_page';

  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final CheckingTokenSession _tokenSession = CheckingTokenSession();
  @override
  void initState() {
    super.initState();
    _tokenSession.checkUserAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/googlebard.png'),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'from',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 50,
              ),
              height: 45,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/googleword.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
