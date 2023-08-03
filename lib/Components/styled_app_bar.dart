import 'package:flutter/material.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyledAppBar({
    super.key,
    this.preferredSize = const Size.fromHeight(50),
    required this.buttontitle,
    required this.buttonFunction,
    required this.title,
  });

  @override
  final Size preferredSize;

  final String title;
  final String buttontitle;
  final VoidCallback buttonFunction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 20,
          fontFamily: "Quicksand",
        ),
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: buttonFunction,
          child: Text(
            buttontitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
