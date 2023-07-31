import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
            fontFamily: "Lugrasimo",
          ),
        ),
      ),
    );
  }
}
