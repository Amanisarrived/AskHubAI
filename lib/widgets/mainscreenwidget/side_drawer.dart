import 'package:ashub_chatai/repo/provider/chat_provider.dart';
import 'package:ashub_chatai/views/authpageview/login.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repo/provider/auth_provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_name") ?? "User";
  }

  bool _isDarkmode = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFFF6B6B),
                  radius: 31,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset("assets/images/onbording2.png"),
                  ),
                ),
                SizedBox(width: 20),
                FutureBuilder<String>(
                  future: getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Flexible(
                        child: Text(
                          "Hi ${snapshot.data} 👋",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Iconsax.home),
            title: Text("Home"),
            trailing: Icon(Iconsax.arrow_right),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Iconsax.mobile4),
            title: Text("Dark Mode"),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                inactiveThumbColor: Colors.white,

                activeTrackColor: Color(0xFFFF6B6B),
                activeColor: Colors.white,
                value: _isDarkmode,
                onChanged: (val) {
                  setState(() {
                    _isDarkmode = val;
                  });
                },
              ),
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Color(0xFFFFF1F1),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFFF6B6B)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    title: Text("Log Out"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Login()),
                          );
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Color(0xFFFF6B6B)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            leading: Icon(Iconsax.logout),
            title: Text("Log Out"),
            trailing: Icon(Iconsax.arrow_right),
          ),
          ListTile(
            title: Text("New chat"),
            leading: Icon(Iconsax.message4),
            trailing: Icon(Iconsax.arrow_right),
            onTap: () {
              final provider = Provider.of<ChatProvider>(
                context,
                listen: false,
              );
              provider.clearMessages();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
