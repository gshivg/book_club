import 'package:book_club/Components/display_label.dart';
import 'package:flutter/material.dart';

primaryTextField(
  TextEditingController textEditingController,
  BuildContext context,
  String labelText,
  IconData icon, {
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          label: displayLabel(labelText, icon),
        ),
        obscuringCharacter: '*',
        obscureText: isPassword,
        controller: textEditingController,
        keyboardType: keyboardType,
      ),
    );
