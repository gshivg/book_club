import 'package:flutter/material.dart';

class HiddenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HiddenAppBar({
    super.key,
    this.preferredSize = const Size.fromHeight(50),
    this.backButton = false,
  });
  final bool backButton;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: backButton
          ? Builder(
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
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
