import 'package:flutter/material.dart';

class IntialUI extends StatelessWidget {
  const IntialUI({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 15,
            top: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
                SizedBox(
                  height: 136,
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'images/gemini-logo.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 110,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.style_outlined,
                          color: Colors.cyanAccent,
                          size: 19,
                        ),
                        Spacer(),
                        Text(
                          'Create a Renaissance-style painting',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LandScapeContainer(
                      containerIcon: Icons.flight_takeoff_outlined,
                      iconColor: Colors.amberAccent,
                      content: 'Plan a relaxing day',
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    LandScapeContainer(
                        containerIcon: Icons.edit_note_outlined,
                        iconColor: Colors.purple.shade200,
                        content: 'Content calender for Tik Tok')
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LandScapeContainer extends StatelessWidget {
  LandScapeContainer({
    required this.containerIcon,
    required this.content,
    required this.iconColor,
  });
  final String content;
  final IconData containerIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade700,
          width: 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              containerIcon,
              color: iconColor,
              size: 19,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              content,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
