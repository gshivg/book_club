import 'dart:developer';

import 'package:book_club/Helpers/fiirebase_helper.dart';
import 'package:book_club/Models/club.dart';
import 'package:book_club/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClubFirebase {
  final String firestoreCollectionName = 'clubs';

  createClub(
    String name,
    String description,
    String topic,
  ) async {
    ClubModel clubModel = ClubModel(
      name,
      uuid.v4(),
      description,
      topic,
      userModel!.id,
      [userModel!.id],
      [userModel!.id],
      DateTime.now(),
      DateTime.now(),
    );
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(clubModel.uid)
          .set(clubModel.toMap());
      return FirebaseResult.success;
    } catch (e) {
      log("createClub $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  getClubs(String userId) {
    return FirebaseFirestore.instance
        .collection(firestoreCollectionName)
        .where('ownerID', isEqualTo: userId)
        .snapshots();
  }

  getClub(String clubId) {
    return FirebaseFirestore.instance
        .collection(firestoreCollectionName)
        .doc(clubId)
        .get();
  }

  updateClub(ClubModel clubModel) async {
    try {
      clubModel.updatedAt = DateTime.now();
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(clubModel.uid)
          .update(clubModel.toMap());
      return FirebaseResult.success;
    } catch (e) {
      log("updateClub $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  deleteClub(String clubId) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(clubId)
          .delete();
      return FirebaseResult.success;
    } catch (e) {
      log("deleteClub $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  joinClub(String clubId) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(clubId)
          .update({
        'membersIDs': FieldValue.arrayUnion([userModel!.id])
      });
      return FirebaseResult.success;
    } catch (e) {
      log("joinClub $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  leaveClub(String clubId) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(clubId)
          .update({
        'membersIDs': FieldValue.arrayRemove([userModel!.id])
      });
      return FirebaseResult.success;
    } catch (e) {
      log("leaveClub $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }
}
