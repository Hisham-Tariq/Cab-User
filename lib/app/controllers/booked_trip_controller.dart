import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/app/models/models.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';

class BookedTripController {
  var tripsRef = FirebaseFirestore.instance.collection('BookedTrips');
  var riderRef = FirebaseFirestore.instance.collection('ride');
  var userRef = FirebaseFirestore.instance.collection('users');
  BookedTripModel? _bookedTrip;

  BookedTripModel? get bookedTrip => _bookedTrip;

  set bookedTrip(BookedTripModel? value) {
    _bookedTrip = value;
  }

  Future<bool> doesTripIdExist(id) async =>
      (await tripsRef.doc(id).get()).exists;

  Future<bool> create(tripId) async {
    try {
      // do {
      //   tripId = getRandomString(30);
      // } while (await this.doesTripIdExist(tripId));
      await tripsRef.doc(tripId).set(_bookedTrip!.toCreateJson());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_bookedTrip!.userId)
          .update({
        'eligible': false,
        'currentBooking': tripId,
      });
      await FirebaseFirestore.instance
          .collection('rider')
          .doc(_bookedTrip!.riderId)
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
