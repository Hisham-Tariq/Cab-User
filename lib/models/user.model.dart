import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  final _userDataReference = FirebaseFirestore.instance.collection('users');
  UserModel({this.id, this.firstName, this.lastName, this.email});

  // UserModel.fromJson(Map<String, dynamic> json) {
  //   this.id = json['id'];
  //   this.name = json['name'];
  // }

  Map<String, dynamic> toJsonToCreateUser() => {
        'firstName': this.firstName,
        'lastName': this.lastName,
        'email': this.email,
      };

  Future<bool> createUser(String password) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var userData = this.toJsonToCreateUser();
    userData['password'] = password;
    try{
      await _userDataReference.doc(currentUserId).set(userData);
      return true;
    }catch(e){
      return false;
    }
  }

  readCurrentUser() {}
  readUser(id) {}
  readAllUsers() {}
}
