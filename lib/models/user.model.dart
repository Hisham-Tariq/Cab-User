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

  UserModel.fromJson(Map<String, dynamic>? userDetail, id) {
    this.id = id;
    this.firstName = userDetail!['firstName'];
    this.lastName = userDetail['lastName'];
    this.email = userDetail['email'];
    this.phoneNumber = userDetail['phoneNumber'];
    if (userDetail.containsKey('eligible'))
      this.eligible = userDetail['eligible'];
    if (userDetail.containsKey('currentBooking'))
      this.currentBooking = userDetail['currentBooking'];
  }

  Map<String, dynamic> toJsonToCreateUser() => {
        'firstName': this.firstName,
        'lastName': this.lastName,
        'email': this.email,
        'phoneNumber': this.phoneNumber,
        'eligible': true,
      };
}
