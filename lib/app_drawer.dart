import 'package:chat_wave/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_wave/history_response_dialogBox.dart';
import 'package:chat_wave/shared_preferences_services.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  final SharedPreferencesServices prefServices = SharedPreferencesServices();
  final fireStore = FirebaseFirestore.instance;

  final promptList = [];
  final promptResponseList = [];

  ///this function is used for to delete the data from the fireStore using documentID
  ///which are created by default in the fireStore for every item
  _deletePrompt(String documentID) {
    fireStore
        .collection('promptResponseContent')
        .doc(
          documentID,
        )
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff212121),
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.white70,
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white70,
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: fireStore
                    .collection('promptResponseContent')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return const Center(
                      child: Text(
                        'something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshots.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.grey.shade800,
                      ),
                    );
                  }

                  final documents = snapshots.data?.docs ?? [];

                  final promptList = documents
                      .map((docs) => docs['prompt'].toString())
                      .toList();
                  final promptResponseList = documents
                      .map((docs) => docs['response'].toString())
                      .toList();

                  return Container(
                    height: MediaQuery.of(context).size.height / 2 + 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      itemCount: 2 + documents.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: DrawerListViewStaticItems(
                                prefixIcon: Icons.auto_awesome_outlined,
                                itsTitle: 'ChatWAVE'),
                          );
                        } else if (index == 1) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: DrawerListViewStaticItems(
                                prefixIcon: Icons.search_rounded,
                                itsTitle: 'Explore Gemini'),
                          );
                        } else if (index - 2 < promptList.length) {
                          final doc = snapshots.data!.docs[index - 2];
                          final documentID = doc.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.messenger_outline_sharp,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ShowResponseDialog(
                                                  prompt: promptList[index - 2],
                                                  response: promptResponseList[
                                                      index - 2],
                                                );
                                              });
                                        },
                                        child: Text(
                                          promptList[index - 2],
                                          style: const TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 16,
                                            color: Colors.white70,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _deletePrompt(documentID);
                                        setState(() {
                                          promptList.removeAt(index - 2);
                                        });
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  );
                }),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DrawerBottomItems(
                      icon: Icons.keyboard_double_arrow_up_rounded,
                      title: 'Get gemini 1.5 Flash and more',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () => showDialog(
                          context: context,
                          builder: (
                            BuildContext context,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 37,
                                bottom: 40,
                              ),
                              child: Dialog(
                                alignment: Alignment.bottomLeft,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  height: 270,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'mudasir456@gmail.com',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey.shade800,
                                        indent: 8,
                                        endIndent: 8,
                                      ),
                                      const ProfileAndSettings(
                                        icon: Icons.perm_identity,
                                        title: 'My AI Tools',
                                        color: Colors.white70,
                                      ),
                                      const ProfileAndSettings(
                                        icon:
                                            Icons.dashboard_customize_outlined,
                                        title: 'Customize Gemini',
                                        color: Colors.white70,
                                      ),
                                      const ProfileAndSettings(
                                        icon: Icons.help_outline_rounded,
                                        title: 'Help & FAQ',
                                        color: Colors.white70,
                                      ),
                                      const ProfileAndSettings(
                                        icon: Icons.settings_outlined,
                                        title: 'Settings',
                                        color: Colors.white70,
                                      ),
                                      Divider(
                                        color: Colors.grey.shade800,
                                        indent: 8,
                                        endIndent: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          prefServices.logOut();

                                          Navigator.pushReplacement(
                                            // Navigate to the login page
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
                                          );
                                        },
                                        child: ProfileAndSettings(
                                          icon: Icons.logout,
                                          title: 'Log out',
                                          color: Colors.red.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      child: const DrawerBottomItems(
                        icon: Icons.person,
                        title: 'Muhammad Mudasir Khan',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAndSettings extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const ProfileAndSettings({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 19,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerBottomItems extends StatelessWidget {
  final IconData icon;
  final String title;
  const DrawerBottomItems({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white10,
      ),
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade800,
                  )),
              child: Icon(
                icon,
                color: Colors.white70,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListViewStaticItems extends StatelessWidget {
  const DrawerListViewStaticItems({
    super.key,
    required this.prefixIcon,
    required this.itsTitle,
  });

  final IconData prefixIcon;
  final String itsTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade700,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            prefixIcon,
            size: 17,
            color: Colors.white70,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          itsTitle,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
