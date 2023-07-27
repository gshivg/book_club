// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

AppBar HiddenAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    ),
  );
}
