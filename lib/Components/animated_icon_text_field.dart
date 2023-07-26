import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

class AnimatedIconTextField extends StatefulWidget {
  const AnimatedIconTextField(
      {super.key,
      required this.context,
      required this.icon1,
      required this.icon2,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      required this.labelText,
      required this.textEditingController});

  final TextEditingController textEditingController;
  final BuildContext context;
  final String labelText;
  final IconData icon1;
  final IconData icon2;
  final bool isPassword;
  final TextInputType keyboardType;
  @override
  State<AnimatedIconTextField> createState() => _AnimatedIconTextFieldState();
}

class _AnimatedIconTextFieldState extends State<AnimatedIconTextField>
    with SingleTickerProviderStateMixin {
  late AnimateIconController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimateIconController();
  }

  bool onEndIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
        content: Text("onEndIconPress called"),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }

  bool onStartIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
        content: Text("onStartIconPress called"),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: widget.textEditingController,
        onTap: () {
          animationController.animateToEnd();
        },
        onTapOutside: (event) {
          animationController.animateToStart();
          // Unfocus
          FocusScope.of(context).unfocus();
        },
        onSubmitted: (value) {
          animationController.animateToStart();
          // Unfocus
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: AnimateIcons(
            startIcon: widget.icon1,
            endIcon: widget.icon2,
            size: 25,
            controller: animationController,
            onStartIconPress: () => onStartIconPress(context),
            onEndIconPress: () => onEndIconPress(context),
            startIconColor: Theme.of(context).colorScheme.onSurface,
            duration: const Duration(milliseconds: 500),
            clockwise: false,
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            fontFamily: "Lugrasimo",
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
