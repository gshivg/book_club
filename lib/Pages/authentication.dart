// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:book_club/Components/animated_icon_text_field.dart';
import 'package:book_club/Components/animated_text_button.dart';
import 'package:book_club/Components/heading_text.dart';
import 'package:book_club/Components/text_button.dart';
import 'package:book_club/Components/title_text.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Painters/curve_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<AnimatedListState> listKey = GlobalKey();
  // ignore: unused_field
  static final _formKey = GlobalKey<FormState>();

  final Key _k1 = GlobalKey();
  final Key _k2 = GlobalKey();
  final Key _k3 = GlobalKey();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCNFController;

  bool signinScreenShown = true;
  bool showAnimations = false;

  Widget announcementText = HeadingText(
    text: "Sign In",
    key: ValueKey(1),
  );

  late List<Widget> screenComponentsList;
  late Widget confirmPasswordComponent;
  void reFocus() async {
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(
        position: Offset(0, 0),
      ),
    );
    await Future.delayed(Duration(milliseconds: 10));
    GestureBinding.instance.handlePointerEvent(
      PointerUpEvent(
        position: Offset(0, 0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordCNFController = TextEditingController();
    screenComponentsList = [
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
          // appBar: HiddenAppBar(),
          body: SingleChildScrollView(
            child: SizedBox(
              // color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: CurvePainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.12),
                        child: TitleText(context: context),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          switchInCurve: Curves.easeInExpo,
                          switchOutCurve: Curves.easeOutExpo,
                          child: announcementText,
                        ),
                      ),
                      AnimatedList(
                        key: listKey,
                        initialItemCount: 2,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: animation,
                            child: screenComponentsList[index],
                          );
                        },
                        shrinkWrap: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OptionsBoxBorderButton(
                            onPressed1: signInFunction,
                            onPressed2: signUpFunction,
                            title1: "Sign In",
                            title2: "Sign Up",
                            condition: signinScreenShown,
                          ),
                          BoxBorderButton(
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: "Sign In With Google",
                              );
                            },
                            title: "Google",
                          ),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
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
                      SizedBox(height: 1),
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

  void signInFunction() {
    Fluttertoast.showToast(msg: "Sign In");
  }

  void signUpFunction() {
    Fluttertoast.showToast(msg: "Sign Up");
  }

  signUpOption() => Row(
        key: UniqueKey(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              _emailController.clear();
              _passwordController.clear();
              _passwordCNFController.clear();
              log("message in");
              setState(() {
                signinScreenShown = false;
                announcementText = HeadingText(
                  text: "Sign Up",
                  key: UniqueKey(),
                );
                screenComponentsList.add(confirmPasswordComponent);
                listKey.currentState!.insertItem(
                  2,
                  duration: Duration(milliseconds: 500),
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

  signInOption() => Row(
        key: UniqueKey(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Already have an account?"),
          TextButton(
            onPressed: () {
              _emailController.clear();
              _passwordController.clear();
              _passwordCNFController.clear();
              log("message up");
              setState(() {
                signinScreenShown = true;
                announcementText = HeadingText(
                  text: "Sign In",
                  key: UniqueKey(),
                );
                screenComponentsList.remove(confirmPasswordComponent);
                listKey.currentState!.removeItem(
                  screenComponentsList.length,
                  (context, animation) => SizeTransition(
                    key: UniqueKey(),
                    sizeFactor: animation,
                    child: confirmPasswordComponent,
                  ),
                  duration: Duration(milliseconds: 500),
                );
              });
              reFocus();
            },
            child: Text(
              'Sign In',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      );
}
