import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.context});
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Text(
        "Shiv's Book Gallery",
        style: TextStyle(
          fontFamily: "Lugrasimo",
          fontSize: 40,
          color: Theme.of(context).colorScheme.surface,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
