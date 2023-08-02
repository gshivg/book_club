import 'package:book_club/main.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
    required this.signOutFunction,
  });

  final Function signOutFunction;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff16697A),
            ),
            child: Text(
              userModel!.name!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Sign Out"),
            onTap: () => widget.signOutFunction(),
          ),
        ],
      ),
    );
  }
}
