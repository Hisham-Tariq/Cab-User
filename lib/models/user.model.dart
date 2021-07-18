class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  // UserModel.fromJson(Map<String, dynamic> json) {
  //   this.id = json['id'];
  //   this.name = json['name'];
  // }

  Map<String, dynamic> toJsonToCreateUser() => {
        'firstName': this.firstName,
        'lastName': this.lastName,
        'email': this.email,
        'phoneNumber': this.phoneNumber,
      };
}
