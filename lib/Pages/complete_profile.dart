import 'dart:developer';

import 'package:book_club/Components/box_border_button.dart';
import 'package:book_club/Components/heading_text.dart';
import 'package:book_club/Components/primary_text_field.dart';
import 'package:book_club/Components/title_text.dart';
import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/homepage.dart';
import 'package:book_club/Painters/outer_painter.dart';
import 'package:book_club/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    log("Complete Profile Page Init State");

    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel value, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: OuterPainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12,
                        ),
                        child: TitleText(context: context),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                        child: HeadingText(
                          text: "Profile",
                          key: ValueKey(1),
                        ),
                      ),
                      PrimaryTextField(
                          context: context,
                          labelText: "Enter Name",
                          textEditingController: nameController),
                      BoxBorderButton(
                        title: "Update",
                        onPressed: updateUserFunction,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  updateUserFunction() async {
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }
    userModel!.name = nameController.text;

    UIHelper.loadingDialog("Updating Profile", context);

    UserFirebase userFirebase = UserFirebase();

    await userFirebase.updateUserProfile().then(
      (value) {
        _closeDialog();
        if (value == FirebaseResult.error || value == FirebaseResult.fail) {
          Fluttertoast.showToast(msg: "Error updating profile");
          return;
        }
      },
    );
  }

  _closeDialog() {
    Navigator.of(context).pop();
  }

  navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
