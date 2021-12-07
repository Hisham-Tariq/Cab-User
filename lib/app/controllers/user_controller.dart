import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserModel user = UserModel();
  final _userDataReference = FirebaseFirestore.instance.collection('users');

  String? get currentUserUID => FirebaseAuth.instance.currentUser!.uid;



  get isUserNotLoggedIn => FirebaseAuth.instance.currentUser == null;

  get userPhoneNumber => FirebaseAuth.instance.currentUser!.phoneNumber;

  StreamSubscription<DocumentSnapshot>? _userChangingListener;

  Future<bool> createUser() async {
    if (user.firstName == null) return false;

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var userData = user.toJsonToCreateUser();
    try {
      await _userDataReference.doc(currentUserId).set(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  _listenToUserChanges() {
    _userChangingListener = _userDataReference.doc(currentUserUID).snapshots().listen((event) {
      user = UserModel.fromJson(event.data(), event.id);
    });
    update();
  }

  Future<bool> readCurrentUser() async {
    try {
      if (currentUserUID != null) {
        var userData = await _userDataReference.doc(currentUserUID).get();
        print(userData.exists);
        print('sdfsdfdsf');
        user = UserModel.fromJson(userData.data(), userData.id);
        print('User\'s Eligibility is ${user.eligible}');
        _listenToUserChanges();
      }
      return true;
    } catch (e) {
      print('Error: in readCurrentUser\n $e');
      return false;
    }
  }

  readUser(id) {}
  readAllUsers() {}

  String? get currentUserPhoneNumber => FirebaseAuth.instance.currentUser!.phoneNumber;

  Future<dynamic> userWithPhoneNumberIsExist(String phoneNumber) async {
    try {
      var _user = await _userDataReference.where('phoneNumber', isEqualTo: phoneNumber).get();
      return _user.docs.isNotEmpty;
    } catch (e) {
      print('Error: IN userWithPhoneNumberExist\n$e');
      return true;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _userChangingListener!.cancel();
  }
}
