import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'user_controller.dart';

class TripFeedbackController extends GetxController {
  int rideRating = 3;
  int driverRating = 3;
  int appRating = 3;
  var comment = TextEditingController();

  void updateAppRating(double value) => appRating = value.toInt();
  void updateRideRating(double value) => rideRating = value.toInt();
  void updateDriverRating(double value) => driverRating = value.toInt();

  void uploadRating() async {
    var currentBooking = Get.find<UserController>().user.currentBooking;
    await FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(currentBooking)
        .collection('feedback')
        .doc('user')
        .set({
      'appRating': appRating,
      'driverRating': driverRating,
      'rideRating': rideRating,
      'comment': comment.text,
      'filledAt': FieldValue.serverTimestamp(),
    });
    printInfo(info: 'Feedback has been uploaded');
    Get.offAllNamed(AppRoutes.NEW_TRIP_BOOKING);
  }

  closeRating() => Get.offAllNamed(AppRoutes.NEW_TRIP_BOOKING);
}
