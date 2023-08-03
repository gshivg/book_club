import 'dart:developer';

import 'package:book_club/Firebase/user.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/club.dart';
import 'package:book_club/Pages/club_page.dart';
import 'package:book_club/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchClubPageListTile extends StatefulWidget {
  const SearchClubPageListTile({
    super.key,
    required this.clubModel,
    this.triggerAnimationOverlay,
  });

  final ClubModel clubModel;
  final VoidCallback? triggerAnimationOverlay;

  @override
  State<SearchClubPageListTile> createState() => _SearchClubPageListTileState();
}

class _SearchClubPageListTileState extends State<SearchClubPageListTile> {
  late bool isMember;

  @override
  void initState() {
    super.initState();
    isMember = widget.clubModel.membersIDs.contains(userModel!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        trailing: isMember
            ? const Text("Joined")
            : TextButton(
                onPressed: joinClub,
                child: const Text("Join"),
              ),
        title: Text(
          widget.clubModel.name!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          widget.clubModel.topic!,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                fontFamily: "Quicksand",
              ),
        ),
        onTap: navigatetoClubPage,
      ),
    );
  }

  void joinClub() async {
    UIHelper.loadingDialog("Joining Club", context);
    try {
      await UserFirebase().joinClub(widget.clubModel.uid!);
      _closeDialog();
      widget.triggerAnimationOverlay!();
      navigatetoClubPage();
    } catch (e) {
      log(e.toString());
      _closeDialog();
      Fluttertoast.showToast(msg: "Some error occured.");
    }
  }

  void navigatetoClubPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubPage(
          clubModel: widget.clubModel,
        ),
      ),
    );
  }

  _closeDialog() {
    Navigator.pop(context);
  }
}
