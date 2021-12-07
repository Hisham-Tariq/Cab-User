class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? currentBooking;
  bool? eligible;
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.currentBooking,
    this.eligible,
  });

  String get fullName => firstName! + " " + lastName!;

  UserModel.fromJson(Map<String, dynamic>? userDetail, this.id) {
    firstName = userDetail!['firstName'];
    lastName = userDetail['lastName'];
    email = userDetail['email'];
    phoneNumber = userDetail['phoneNumber'];
    if (userDetail.containsKey('eligible')) {
      eligible = userDetail['eligible'];
    }
    if (userDetail.containsKey('currentBooking')) {
      currentBooking = userDetail['currentBooking'];
    }
  }

  Map<String, dynamic> toJsonToCreateUser() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'eligible': true,
      };
}
