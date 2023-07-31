import 'dart:developer';

import 'package:book_club/Firebase/club.dart';
import 'package:book_club/Helpers/fiirebase_helper.dart';
import 'package:book_club/Shared/saved_user.dart';
import 'package:book_club/main.dart';

import 'package:book_club/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase {
  final String firestoreCollectionName = 'users';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final SavedUserSharedPreferences savedUserSharedPreferences =
      SavedUserSharedPreferences();

  createUser(String email, String password) async {
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      log(userModel!.id!);
      savedUserSharedPreferences.setUser(userModel!.id!);
      return FirebaseResult.success;
    } on FirebaseAuthException catch (e) {
      log("createUser $e");
      switch (e.code) {
        case 'email-already-in-use':
          Fluttertoast.showToast(
            msg: 'Email is already linked with another account.',
          );
          break;
        case 'invalid-email':
          Fluttertoast.showToast(
            msg: 'Email is invalid.',
          );
          break;
        case 'operation-not-allowed':
          Fluttertoast.showToast(
            msg: 'Internal error has occured.',
          );
          break;
        case 'weak-password':
          Fluttertoast.showToast(
            msg: 'Password is too weak.',
          );
          break;
        default:
          Fluttertoast.showToast(
            msg: 'Some error has eccured',
          );
      }
      return FirebaseResult.fail;
    } catch (e) {
      log("createUser $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  signInUser(String email, String password) async {
    try {
      UserCredential? userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getUserByUID(userCredential.user!.uid);
      log(userModel!.id!);
      savedUserSharedPreferences.setUser(userModel!.id!);
      return FirebaseResult.success;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      switch (e.code) {
        case 'invalid-email':
          Fluttertoast.showToast(
            msg: 'Email is invalid.',
          );
          break;
        case 'user-disabled':
          Fluttertoast.showToast(
            msg: 'User is disabled.',
          );
          break;
        case 'user-not-found':
          Fluttertoast.showToast(
            msg: 'User not found.',
          );
          break;
        case 'wrong-password':
          Fluttertoast.showToast(
            msg: 'Wrong password.',
          );
          break;
        default:
          Fluttertoast.showToast(
            msg: 'Some error has eccured',
          );
      }
      return FirebaseResult.fail;
    } catch (e) {
      log("signInUser $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  createUserProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(userModel!.id)
          .set(userModel!.toMap());
      return FirebaseResult.success;
    } catch (e) {
      log("createUserProfile $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  getUser() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(userModel!.id)
          .get();
      userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      log("143");
      savedUserSharedPreferences.setUser(userModel!.id!);
      return FirebaseResult.success;
    } catch (e) {
      log("getUser $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  getUserByUID(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        userModel =
            UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
        savedUserSharedPreferences.setUser(userModel!.id!);
        log(userModel!.toMap().toString());
      });
      return FirebaseResult.success;
    } catch (e) {
      log("getUserByUID $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  updateUserProfile() async {
    try {
      userModel!.updatedAt = DateTime.now();
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(userModel!.id)
          .update(userModel!.toMap());
      return FirebaseResult.success;
    } catch (e) {
      log("updateUserProfile $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  signOutUser() async {
    try {
      await auth.signOut();
      savedUserSharedPreferences.removeUser();
      return FirebaseResult.success;
    } catch (e) {
      log("signOutUser $e");
      Fluttertoast.showToast(
        msg: 'Some error has eccured',
      );
      return FirebaseResult.error;
    }
  }

  joinClub(String clubId) async {
    try {
      await FirebaseFirestore.instance
          .collection(ClubFirebase().firestoreCollectionName)
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
}
