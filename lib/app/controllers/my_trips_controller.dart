import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/models/booked_trip_model/booked_trip_model.dart';

class MyTripsController extends GetxController {
  var bookedTripsReference = FirebaseFirestore.instance
      .collection("BookedTrips")
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  late StreamSubscription<QuerySnapshot> _userTripsListener;

  List<BookedTripModel> trips = [];

  @override
  onInit() {
    super.onInit();
    _listenToUserTrips();
  }

  _listenToUserTrips() async {
    _userTripsListener = bookedTripsReference.snapshots().listen((event) {
      trips.clear();
      print("event.docs.length: ${event.docs.length}");
      for (var element in event.docs) {
        trips.add(BookedTripModel.fromDocument(element));
      }
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();
    _userTripsListener.cancel();
  }
}
