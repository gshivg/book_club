import 'dart:developer';

import 'package:book_club/Components/animated_icon_text_field.dart';
import 'package:book_club/Components/searchclubpage_club_list_tile.dart';
import 'package:book_club/Components/styled_app_bar.dart';
import 'package:book_club/Designs/standard_page_edge_insets.dart';
import 'package:book_club/Firebase/club.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Models/club.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/create_club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchClubsPage extends StatefulWidget {
  const SearchClubsPage({super.key});

  @override
  State<SearchClubsPage> createState() => _SearchClubsPageState();
}

class _SearchClubsPageState extends State<SearchClubsPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    log("SearchClubsPage init");
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel value, builder) {
        return Scaffold(
          appBar: StyledAppBar(
            title: "Search Clubs",
            buttontitle: "Create",
            buttonFunction: navigatetoCreatePage,
          ),
          extendBodyBehindAppBar: true,
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
                padding: standarPageEdgeInsets(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    AnimatedIconTextField(
                      context: context,
                      icon1: Icons.search_outlined,
                      icon2: Icons.search,
                      labelText: "Seacrh for a club",
                      textEditingController: searchController,
                      keyboardType: TextInputType.text,
                      onChanged: onChanged,
                    ),
                    searchController.text.isEmpty
                        ? noTextEnteredAlert()
                        : StreamBuilder(
                            stream: ClubFirebase().getClubsByTag(
                                searchController.text.toLowerCase().trim()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.active) {
                                return Center(
                                  child: UIHelper.loader(context),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data == null ||
                                  (snapshot.data as QuerySnapshot)
                                      .docs
                                      .isEmpty) {
                                return noClubsFound();
                              }

                              QuerySnapshot querySnapshot =
                                  snapshot.data as QuerySnapshot;

                              List<ClubModel> clubModels = [];
                              for (var element in querySnapshot.docs) {
                                clubModels.add(
                                  ClubModel.fromMap(
                                    element.data() as Map<String, dynamic>,
                                  ),
                                );
                              }

                              return Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: clubModels.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return SearchClubPageListTile(
                                      clubModel: clubModels[index],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget noTextEnteredAlert() {
    return const Text("Please enter a search term");
  }

  Widget noClubsFound() {
    return const Text("No Clubs Found");
  }

  void onChanged() {
    setState(() {});
  }

  void navigatetoCreatePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateClubPage(),
      ),
    );
  }
}
