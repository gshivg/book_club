import 'dart:developer';

import 'package:book_club/Components/app_bar.dart';
import 'package:book_club/Components/box_border_button.dart';
import 'package:book_club/Components/title_text.dart';
import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/authentication.dart';
import 'package:book_club/Pages/complete_profile.dart';
import 'package:book_club/Painters/inner_painter.dart';
import 'package:book_club/Shared/saved_user.dart';
import 'package:book_club/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    log("Home Page Init State");
    checkCompleteProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel value, child) {
        return Scaffold(
          appBar: HiddenAppBar(),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: InnerPainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12,
                        ),
                        child: TitleText(context: context),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(400),
                        ),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.height * 0.15,
                        child: const RiveAnimation.asset(
                          "assets/rive/loading.riv",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Text(
                        "Home Page Temporary Screen",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 20,
                          fontFamily: "Lugrasimo",
                        ),
                      ),
                      BoxBorderButton(
                        title: "Sign Out",
                        onPressed: signOutFunction,
                      ),
                      SizedBox(),
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

  checkCompleteProfile() async {
    SavedUserSharedPreferences().getUser().then((value) {
      log(value);
      if (value == "") {
        navigateToCompleteProfilePage();
        return;
      }
      UserFirebase().getUserByUID(value!).then((_) {
        if (userModel!.name == null) {
          navigateToCompleteProfilePage();
        }
      });
    });
  }

  signOutFunction() {
    UIHelper.loadingDialog("Signin Out...", context);

    UserFirebase().signOutUser().then(
      (value) {
        _closeDialog();

        if (value == FirebaseResult.success) {
          navigateToAuthenticationPage();
        } else {
          Fluttertoast.showToast(
            msg: "Some error has occured",
          );
        }
      },
    );
  }

  _closeDialog() {
    Navigator.of(context).pop();
  }

  navigateToAuthenticationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthenticationPage(),
      ),
    );
  }

  navigateToCompleteProfilePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CompleteProfilePage(),
      ),
    );
  }
}
