import 'package:flutter/material.dart';

class HiddenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HiddenAppBar({
    super.key,
    this.preferredSize = const Size.fromHeight(50),
  });

  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
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
    ;
  }
}
