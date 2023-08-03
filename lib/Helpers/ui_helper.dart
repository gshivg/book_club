import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class UIHelper {
  static void loadingDialog(String message, BuildContext context) {
    AlertDialog dialog = AlertDialog(
      content: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            loadingAnimation(context),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontFamily: "Quicksand",
                  ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => dialog,
      barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
    );
  }

  static Widget loader(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width * 0.06,
      child: const RiveAnimation.asset(
        "assets/rive/loading.riv",
        fit: BoxFit.scaleDown,
      ),
    );
  }

  static Widget loadingAnimation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(400),
      ),
      height: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width * 0.12,
      child: const RiveAnimation.asset(
        "assets/rive/loading.riv",
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
