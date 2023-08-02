import 'dart:developer';

import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/club.dart';
import 'package:book_club/Pages/homepage.dart';
import 'package:book_club/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClubPageDrawer extends StatefulWidget {
  const ClubPageDrawer({
    super.key,
    required this.clubModel,
  });

  final ClubModel clubModel;

  @override
  State<ClubPageDrawer> createState() => _ClubPageDrawerState();
}

class _ClubPageDrawerState extends State<ClubPageDrawer> {
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
            title: const Text("Leave Club"),
            onTap: () async {
              UIHelper.loadingDialog("Leaving Club", context);

              if (widget.clubModel.ownerID == userModel!.id!) {
                Fluttertoast.showToast(
                    msg: "You are the owner of this club, you cannot leave");
                return;
              }

              try {
                await UserFirebase().leaveClub(widget.clubModel.uid!);
                _closeDialog();
                navigatetoHomePage();
                Fluttertoast.showToast(msg: "Club left successfully");
              } catch (e) {
                log("Drawer Leave Club $e");
                _closeDialog();
                Fluttertoast.showToast(msg: "Error leaving club");
              }
            },
          ),
        ],
      ),
    );
  }

  _closeDialog() {
    Navigator.of(context).pop();
  }

  navigatetoHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
