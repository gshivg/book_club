import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.context});
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Text(
            "SBG",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize:
                  Theme.of(context).textTheme.displayLarge!.fontSize! * 1.7,
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Positioned(
            top: Theme.of(context).textTheme.displayLarge!.fontSize! * 1.83,
            child: Text(
              "Shiv's Book Gallery",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize:
                    Theme.of(context).textTheme.titleLarge!.fontSize! * 0.9,
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
