import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserModel _user = UserModel();
  final _userDataReference = FirebaseFirestore.instance.collection('users');

  String? get currentUserUID => FirebaseAuth.instance.currentUser!.uid;

  UserModel get user => _user;
  set user(UserModel user) => _user = user;

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

  _listenToUserChanges() {
    _userDataReference.doc(currentUserUID).snapshots().listen((event) {
      this._user = UserModel.fromJson(event.data(), event.id);
    });
    update();
  }

  Future<bool> readCurrentUser() async {
    try {
      if (currentUserUID != null) {
        var userData = await _userDataReference.doc(currentUserUID).get();
        this._user = UserModel.fromJson(userData.data(), userData.id);
        print('User\'s Eligibility is ${this._user.eligible}');
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

  String? get currentUserPhoneNumber =>
      FirebaseAuth.instance.currentUser!.phoneNumber;

  Future<dynamic> userWithPhoneNumberIsExist(String phoneNumber) async {
    try {
      var _user = await _userDataReference
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return _user.docs.length > 0;
    } catch (e) {
      print('Error: IN userWithPhoneNumberExist\n$e');
      return true;
    }
  }
}
