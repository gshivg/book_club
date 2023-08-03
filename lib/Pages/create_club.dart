import 'dart:developer';

import 'package:book_club/Components/animated_icon_text_field.dart';
import 'package:book_club/Components/box_border_button.dart';
import 'package:book_club/Components/heading_text.dart';
import 'package:book_club/Components/hidden_app_bar.dart';
import 'package:book_club/Components/options_box_border_button.dart';
import 'package:book_club/Components/title_text.dart';
import 'package:book_club/Firebase/club.dart';
import 'package:book_club/Helpers/fiirebase_helper.dart';
import 'package:book_club/Helpers/ui_helper.dart';
import 'package:book_club/Pages/homepage.dart';
import 'package:book_club/Painters/outer_painter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key});

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  static final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final Key _k1 = GlobalKey();
  final Key _k2 = GlobalKey();
  final Key _k3 = GlobalKey();

  bool nextComponentAvailable = true;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _topicController;

  late List<Widget> _formComponentsList;
  late Widget _topicComponent;
  late Widget _desciptionComponent;

  @override
  void initState() {
    super.initState();

    log("Club Create Page Init State");

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _topicController = TextEditingController();

    _formComponentsList = [
      AnimatedIconTextField(
        context: context,
        icon1: Icons.abc_outlined,
        icon2: Icons.abc,
        labelText: "Enter Name",
        textEditingController: _nameController,
        keyboardType: TextInputType.name,
        key: _k1,
      ),
    ];
    _topicComponent = AnimatedIconTextField(
      context: context,
      icon1: Icons.abc_outlined,
      icon2: Icons.abc,
      labelText: "Enter Topic",
      textEditingController: _topicController,
      key: _k2,
    );
    _desciptionComponent = AnimatedIconTextField(
      context: context,
      icon1: Icons.abc_outlined,
      icon2: Icons.abc,
      labelText: "Enter Description",
      textEditingController: _descriptionController,
      key: _k3,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _topicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, _, child) {
        return Scaffold(
          appBar: const HiddenAppBar(backButton: true),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: OuterPainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.087,
                        ),
                        child: TitleText(context: context),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: HeadingText(text: "Create a Club"),
                      ),
                      AnimatedList(
                        key: listKey,
                        initialItemCount: 1,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: animation,
                            child: _formComponentsList[index],
                          );
                        },
                        shrinkWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OptionsBoxBorderButton(
                              onPressed1: showNextFormComponent,
                              onPressed2: submitForm,
                              title1: "Next",
                              title2: "Submit",
                              condition: nextComponentAvailable,
                            ),
                            BoxBorderButton(
                              onPressed: cancelCreate,
                              title: "Clear",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox.shrink(),
                      const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showNextFormComponent() {
    if (_formComponentsList.length == 1) {
      _formComponentsList.add(_topicComponent);
      listKey.currentState!.insertItem(
        1,
        duration: const Duration(milliseconds: 500),
      );
    } else if (_formComponentsList.length == 2) {
      _formComponentsList.add(_desciptionComponent);
      listKey.currentState!.insertItem(
        2,
        duration: const Duration(milliseconds: 500),
      );
      setState(() {
        nextComponentAvailable = false;
      });
    }
  }

  submitForm() async {
    log("Submit Form");

    if (_formComponentsList.length != 3) {
      return;
    }

    if (_nameController.text.isEmpty ||
        _topicController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }

    UIHelper.loadingDialog("Creating Your Club...", context);

    await ClubFirebase()
        .createClub(
      _nameController.text,
      _descriptionController.text,
      _topicController.text,
    )
        .then(
      (value) {
        _closeDialog();
        if (value == FirebaseResult.success) {
          Fluttertoast.showToast(msg: "Club Created Successfully");
        } else {
          Fluttertoast.showToast(msg: "Some error has eccured");
        }
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ),
        );
      },
    );
  }

  cancelCreate() {
    log("Cancel Create");
    _formComponentsList.remove(_desciptionComponent);
    listKey.currentState!.removeItem(
      2,
      (context, animation) => SizeTransition(
        key: UniqueKey(),
        sizeFactor: animation,
        child: _desciptionComponent,
      ),
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 500));
    _formComponentsList.remove(_topicComponent);
    listKey.currentState!.removeItem(
      1,
      (context, animation) => SizeTransition(
        key: UniqueKey(),
        sizeFactor: animation,
        child: _topicComponent,
      ),
      duration: const Duration(milliseconds: 500),
    );
    setState(() {
      nextComponentAvailable = true;
    });
  }

  _closeDialog() {
    Navigator.pop(context);
  }
}
