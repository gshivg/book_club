

import 'package:flutter/material.dart';

displayLabel(String labelText, IconData iconData) => Row(
      children: [
        Icon(iconData),
        const SizedBox(width: 10),
        Text(labelText),
      ],
    );