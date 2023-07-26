import 'package:book_club/Designs/image_button.dart';
import 'package:flutter/material.dart';

ImageButton(VoidCallback onPressed, String image, String title,
        BuildContext context) =>
    ElevatedButton(
      onPressed: onPressed,
      child: imageButtonDesign(image, title, context),
      style: ButtonStyle(elevation: MaterialStateProperty.all(5)),
    );