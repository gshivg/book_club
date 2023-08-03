import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:book_club/Components/homepage_club_list_tile.dart';
import 'package:book_club/Components/primary_app_bar.dart';
import 'package:book_club/Components/primary_drawer.dart';
import 'package:book_club/Firebase/club.dart';
import 'package:book_club/Helpers/fiirebase_helper.dart';
import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/club.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/authentication.dart';
import 'package:book_club/Pages/complete_profile.dart';
import 'package:book_club/Pages/search_clubs.dart';
import 'package:book_club/Shared/saved_user.dart';
import 'package:book_club/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RiveAnimationController riveAnimationController;

  late bool userModelReady = false;

  @override
  void initState() {
    super.initState();
    log("Home Page Init State");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkCompleteProfile();
      setState(() {});
    });

    riveAnimationController = SimpleAnimation("idle");

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (userModel == null) {
        log("model not ready");
        return;
      }
      if (userModel!.name == null) {
        log("name not ready");
        return;
      }
      if (userModel!.phone == null) {
        log("phone not ready");
        return;
      }
      log("model ready");
      userModelReady = true;
      timer.cancel();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel value, child) {
        return Scaffold(
          appBar: const PrimaryAppBar(),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: userModelReady
                    ? StreamBuilder(
                        stream: ClubFirebase().getClubs(userModel!.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.active) {
                            return Center(
                              child: UIHelper.loader(context),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data == null ||
                              (snapshot.data as QuerySnapshot).docs.isEmpty) {
                            return noClubsJoined();
                          }
                          QuerySnapshot querySnapshot =
                              snapshot.data as QuerySnapshot;
                          List<ClubModel> clubModels = [];
                          for (var element in querySnapshot.docs) {
                            clubModels.add(
                              ClubModel.fromMap(
                                  element.data() as Map<String, dynamic>),
                            );
                          }
                          return ListView.builder(
                            itemCount: clubModels.length,
                            itemBuilder: (context, index) {
                              return HomepageClubListTile(
                                clubModel: clubModels[index],
                              );
                            },
                          );
                        },
                      )
                    : UIHelper.loader(context),
              ),
            ),
          ),
          drawer: MyDrawer(
            signOutFunction: signOutFunction,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: floatingActionButtonFunction,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget noClubsJoined() {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // alignment: Alignment.center,
        children: [
          // const Spacer(),
          SizedBox.square(
            dimension: MediaQuery.of(context).size.height * 0.45,
            child: RiveAnimation.asset(
              "assets/rive/loading-2.riv",
              artboard: "loading",
              animations: const ["loading"],
              fit: BoxFit.cover,
              controllers: [
                riveAnimationController,
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            child: DefaultTextStyle(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontFamily: "Quicksand",
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  RotateAnimatedText(
                    "You haven't joined any clubs",
                    textAlign: TextAlign.center,
                    duration: const Duration(milliseconds: 4000),
                  ),
                  RotateAnimatedText(
                    "Join a club to explore the app",
                    textAlign: TextAlign.center,
                    duration: const Duration(milliseconds: 4000),
                  ),
                  RotateAnimatedText(
                    "Press the + button to join a club",
                    textAlign: TextAlign.center,
                    duration: const Duration(milliseconds: 4000),
                  ),
                ],
                pause: Duration.zero,
                isRepeatingAnimation: true,
                repeatForever: true,
                onTap: () => log("Text Tapped"),
              ),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }

  void floatingActionButtonFunction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SearchClubsPage();
        },
      ),
    ).then((value) => setState(() {}));
  }

  checkCompleteProfile() async {
    SavedUserSharedPreferences().getUser().then(
      (value) {
        log(value);
        if (value == "") {
          navigateToCompleteProfilePage();
        } else {
          UserFirebase().getUserByUID(value!).then(
            (_) {
              if (checkIncompleteProfile()) {
                navigateToCompleteProfilePage();
              }
            },
          );
        }
      },
    );
  }

  bool checkIncompleteProfile() {
    if (userModel == null) {
      return true;
    } else if (userModel!.name == null) {
      return true;
    } else if (userModel!.phone == null) {
      return true;
    }
    return false;
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
