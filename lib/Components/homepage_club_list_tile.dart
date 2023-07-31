import 'package:book_club/Models/club.dart';
import 'package:book_club/main.dart';
import 'package:flutter/material.dart';

class HomepageClubListTile extends StatefulWidget {
  const HomepageClubListTile({super.key, required this.clubModel});

  final ClubModel clubModel;
  @override
  State<HomepageClubListTile> createState() => _HomepageClubListTileState();
}

class _HomepageClubListTileState extends State<HomepageClubListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
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
        trailing: Icon(
          widget.clubModel.ownerID == userModel!.id
              ? Icons.star
              : widget.clubModel.adminsIDs.contains(userModel!.id)
                  ? Icons.admin_panel_settings
                  : Icons.card_membership,
          color: Theme.of(context).colorScheme.primary,
          size: 30,
        ),
        title: Text(
          widget.clubModel.name!,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: "Lugrasimo",
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          widget.clubModel.topic!,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                fontFamily: "Lugrasimo",
              ),
        ),
        onTap: () {},
      ),
    );
  }
}
