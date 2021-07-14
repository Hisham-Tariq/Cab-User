import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

class UserController extends GetxController {
  UserModel _user = UserModel();
  final _userDataReference = FirebaseFirestore.instance.collection('users');

  UserModel getUser() => _user;
  setUser(UserModel user) {
    _user = user;
  }

  Future<bool> createUser() async {
    if (_user.firstName == null) return false;

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var userData = _user.toJsonToCreateUser();
    try {
      await _userDataReference.doc(currentUserId).set(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  readCurrentUser() {}
  readUser(id) {}
  readAllUsers() {}
}
