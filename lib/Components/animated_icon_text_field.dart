import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

class AnimatedIconTextField extends StatefulWidget {
  const AnimatedIconTextField({
    super.key,
    required this.context,
    required this.icon1,
    required this.icon2,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.labelText,
    required this.textEditingController,
    this.onChanged,
  });

  final TextEditingController textEditingController;
  final BuildContext context;
  final String labelText;
  final IconData icon1;
  final IconData icon2;
  final bool isPassword;
  final TextInputType keyboardType;

  final VoidCallback? onChanged;
  @override
  State<AnimatedIconTextField> createState() => _AnimatedIconTextFieldState();
}

class _AnimatedIconTextFieldState extends State<AnimatedIconTextField>
    with TickerProviderStateMixin {
  late AnimateIconController prefixAnimationController;
  late AnimateIconController suffixAnimationController;

  late bool submitted;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    prefixAnimationController = AnimateIconController();
    suffixAnimationController = AnimateIconController();
    submitted = false;
    passwordVisible = widget.isPassword;
  }

  bool onEndIconPress(BuildContext context) {
    return true;
  }

  bool onStartIconPress(BuildContext context) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        onTap: () {
          prefixAnimationController.animateToEnd();
        },
        onTapOutside: (event) {
          if (widget.textEditingController.text.isNotEmpty) {
            submitted = true;
          } else {
            submitted = false;
            prefixAnimationController.animateToStart();
          }
          if (submitted) {
          } else {
            prefixAnimationController.animateToStart();
          }
          FocusScope.of(context).unfocus();
        },
        onSubmitted: (value) {
          if (widget.textEditingController.text.isNotEmpty) {
            submitted = true;
          } else {
            submitted = false;
            prefixAnimationController.animateToStart();
          }
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          if (widget.textEditingController.text.isNotEmpty) {
            submitted = true;
          } else {
            if (!FocusScope.of(widget.context).hasFocus) {
              submitted = false;
              prefixAnimationController.animateToStart();
            }
          }
          if (widget.onChanged != null) {
            widget.onChanged!();
          }
        },
        obscureText: passwordVisible,
        decoration: InputDecoration(
          prefixIcon: AnimateIcons(
            startIcon: widget.icon1,
            endIcon: widget.icon2,
            size: 25,
            controller: prefixAnimationController,
            onStartIconPress: () => onStartIconPress(context),
            onEndIconPress: () => onEndIconPress(context),
            startIconColor: Theme.of(context).colorScheme.onSurface,
            duration: const Duration(milliseconds: 500),
            clockwise: false,
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            fontFamily: "Quicksand",
          ),
          suffixIcon: widget.isPassword
              ? AnimateIcons(
                  startIcon: Icons.visibility_outlined,
                  endIcon: Icons.visibility_off_outlined,
                  startIconColor: Theme.of(context).colorScheme.onSurface,
                  endIconColor: Theme.of(context).colorScheme.onSurface,
                  size: 25,
                  duration: const Duration(milliseconds: 200),
                  controller: suffixAnimationController,
                  onStartIconPress: () {
                    setState(() {
                      passwordVisible = false;
                    });
                    return true;
                  },
                  onEndIconPress: () {
                    setState(() {
                      passwordVisible = true;
                    });
                    return true;
                  },
                )
              : null,
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
          focusedErrorBorder: OutlineInputBorder(
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
