import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';

import '../data/models/booked_trip_model/booked_trip_model.dart';

class BookedTripController {
  var tripsRef = FirebaseFirestore.instance.collection('BookedTrips');
  var riderRef = FirebaseFirestore.instance.collection('ride');
  var userRef = FirebaseFirestore.instance.collection('users');
  BookedTripModel? bookedTrip;



  Future<bool> doesTripIdExist(id) async =>
      (await tripsRef.doc(id).get()).exists;

  Future<bool> create(tripId) async {
    try {
      // do {
      //   tripId = getRandomString(30);
      // } while (await this.doesTripIdExist(tripId));
      await tripsRef.doc(tripId).set(bookedTrip!.toJson());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(bookedTrip!.userId)
          .update({
        'eligible': false,
        'currentBooking': tripId,
      });
      await FirebaseFirestore.instance
          .collection('rider')
          .doc(bookedTrip!.riderId)
          .update({
        'eligible': false,
        'currentBooking': tripId,
      });
      return true;
    } catch (e) {
      printError(info: 'Error: $e');
      return false;
    }
  }
}
