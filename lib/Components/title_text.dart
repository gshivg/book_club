import 'package:book_club/Designs/title_text.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.context});
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Text(
        "Shiv's Book Gallery",
        style: TitleTextSyle(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
