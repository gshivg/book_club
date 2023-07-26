
import 'package:flutter/material.dart';

textButton1Design(String title, BuildContext context) => Container(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );