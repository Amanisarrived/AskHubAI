import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool _isDarkmode = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                Text(
                  "Hi Aman 👋",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
              child: Switch(inactiveThumbColor: Colors.white,

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
              showDialog(barrierDismissible: false,
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
                        onPressed: () {},
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
        ],
      ),
    );
  }
}
