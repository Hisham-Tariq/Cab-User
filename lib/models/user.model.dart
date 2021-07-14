import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
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
}
