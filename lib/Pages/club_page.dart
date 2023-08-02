import 'package:book_club/Components/club_page_drawer.dart';
import 'package:book_club/Components/styled_app_bar.dart';
import 'package:book_club/Designs/standard_page_edge_insets.dart';
import 'package:book_club/Models/club.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key, required this.clubModel});

  final ClubModel clubModel;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, builder) {
        return Scaffold(
          appBar: StyledAppBar(
            buttontitle: 'Post',
            buttonFunction: addnewPost,
            title: widget.clubModel.name!,
          ),
          extendBodyBehindAppBar: true,
          drawer: ClubPageDrawer(clubModel: widget.clubModel),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: standarPageEdgeInsets().copyWith(
                  top: MediaQuery.of(context).padding.top +
                      AppBar().preferredSize.height,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.clubModel.name!),
                    Text(widget.clubModel.topic!),
                    Text(widget.clubModel.description!),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addnewPost() {
    Fluttertoast.showToast(msg: "Functionality to add new Post");
  }
}
