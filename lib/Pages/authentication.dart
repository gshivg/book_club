import 'dart:developer';

import 'package:book_club/Components/animated_icon_text_field.dart';
import 'package:book_club/Components/heading_text.dart';
import 'package:book_club/Components/box_border_button.dart';
import 'package:book_club/Components/options_box_border_button.dart';
import 'package:book_club/Components/title_text.dart';
import 'package:book_club/Helpers/fiirebase_helper.dart';
import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/homepage.dart';
import 'package:book_club/Painters/outer_painter.dart';
import 'package:book_club/Shared/saved_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  static final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final Key _k1 = GlobalKey();
  final Key _k2 = GlobalKey();
  final Key _k3 = GlobalKey();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCNFController;

  bool signinScreenShown = true;
  bool showAnimations = false;

  late List<Widget> formComponentsList;
  late Widget confirmPasswordComponent;

  void reFocus() async {
    GestureBinding.instance.handlePointerEvent(
      const PointerDownEvent(
        position: Offset(0, 0),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 10));
    GestureBinding.instance.handlePointerEvent(
      const PointerUpEvent(
        position: Offset(0, 0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    log("Authentication Page Init State");

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordCNFController = TextEditingController();

    formComponentsList = [
      AnimatedIconTextField(
        key: _k1,
        context: context,
        icon1: Icons.email_outlined,
        icon2: Icons.email_rounded,
        labelText: "Enter Email",
        textEditingController: _emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      AnimatedIconTextField(
        key: _k2,
        context: context,
        icon1: Icons.lock_open_outlined,
        icon2: Icons.lock_outline,
        labelText: "Enter Password",
        textEditingController: _passwordController,
        isPassword: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];

    confirmPasswordComponent = AnimatedIconTextField(
      key: _k3,
      context: context,
      icon1: Icons.lock_open_outlined,
      icon2: Icons.lock_outline,
      labelText: "Confirm Password",
      textEditingController: _passwordCNFController,
      isPassword: true,
      keyboardType: TextInputType.visiblePassword,
    );

    SavedUserSharedPreferences().getUser().then(
      (value) {
        if (value != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCNFController.dispose();
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          switchInCurve: Curves.easeInExpo,
                          switchOutCurve: Curves.easeOutExpo,
                          child: signinScreenShown
                              ? const HeadingText(
                                  text: "Sign In",
                                  key: ValueKey(1),
                                )
                              : const HeadingText(
                                  text: "Sign Up",
                                  key: ValueKey(2),
                                ),
                        ),
                      ),
                      AnimatedList(
                        key: listKey,
                        initialItemCount: 2,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: animation,
                            child: formComponentsList[index],
                          );
                        },
                        shrinkWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OptionsBoxBorderButton(
                              onPressed1: signInFunction,
                              onPressed2: signUpFunction,
                              title1: "Sign In",
                              title2: "Sign Up",
                              condition: signinScreenShown,
                            ),
                            BoxBorderButton(
                              onPressed: googleAuthFunction,
                              title: "Google",
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        switchInCurve: Curves.easeInExpo,
                        switchOutCurve: Curves.easeOutExpo,
                        child:
                            signinScreenShown ? signUpOption() : signInOption(),
                      ),
                      const SizedBox(height: 1),
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

  void signInFunction() async {
    UserFirebase userFirebase = UserFirebase();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }

    UIHelper.loadingDialog("Signing In...", context);

    await userFirebase
        .signInUser(_emailController.text, _passwordController.text)
        .then(
      (value) {
        if (value == FirebaseResult.fail || value == FirebaseResult.error) {
          _closeDialog();
          return;
        }
        navigateToHomeScreen();
      },
    );
  }

  signUpFunction() async {
    UserFirebase userFirebase = UserFirebase();

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordCNFController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }

    if (_passwordController.text != _passwordCNFController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    UIHelper.loadingDialog("Signing Up...", context);

    await userFirebase
        .createUser(_emailController.text, _passwordController.text)
        .then(
      (value) {
        if (value == FirebaseResult.fail || value == FirebaseResult.error) {
          _closeDialog();
          Fluttertoast.showToast(msg: "Some error has occured");
          return;
        }

        userFirebase.createUserProfile();

        _closeDialog();

        navigateToHomeScreen();
      },
    );
  }

  _closeDialog() {
    Navigator.of(context).pop();
  }

  navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void googleAuthFunction() {
    Fluttertoast.showToast(msg: "Google Auth");
  }

  Widget signUpOption() => Row(
        key: UniqueKey(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              _emailController.clear();
              _passwordController.clear();
              _passwordCNFController.clear();
              setState(() {
                signinScreenShown = false;
                formComponentsList.add(confirmPasswordComponent);
                listKey.currentState!.insertItem(
                  2,
                  duration: const Duration(milliseconds: 500),
                );
              });
              reFocus();
            },
            child: Text(
              'Sign Up',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      );

  Widget signInOption() => Row(
        key: UniqueKey(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () {
              _emailController.clear();
              _passwordController.clear();
              _passwordCNFController.clear();
              setState(() {
                signinScreenShown = true;
                formComponentsList.remove(confirmPasswordComponent);
                listKey.currentState!.removeItem(
                  formComponentsList.length,
                  (context, animation) => SizeTransition(
                    key: UniqueKey(),
                    sizeFactor: animation,
                    child: confirmPasswordComponent,
                  ),
                  duration: const Duration(milliseconds: 500),
                );
              });
              reFocus();
            },
            child: Text(
              'Sign In',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      );
}
