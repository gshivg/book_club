import 'package:flutter/material.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.preferredSize = const Size.fromHeight(50),
  });

  @override
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
              Icons.menu,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(100),
      //   child: Divider(
      //     color: Theme.of(context).colorScheme.primary,
      //     thickness: 1,
      //   ),
      // ),
    );
  }
}
