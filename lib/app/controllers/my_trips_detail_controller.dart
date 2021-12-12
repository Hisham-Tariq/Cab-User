import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/app/data/models/booked_trip_model/booked_trip_model.dart';
import 'package:driving_app_its/app/models/direction.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'direction_controller.dart';

class MyTripsDetailController extends GetxController {
  late BookedTripModel? trip;
  StreamSubscription<DocumentSnapshot>? tripChangesListener;

  Directions? tripDirections;

  GoogleMapController? googleMapController;

  MyTripsDetailController() {}

  @override
  void onInit() {
    super.onInit();
    trip = Get.arguments as BookedTripModel;
    update();
    _fetchTripDirection();
    _listenToTripChanges();
  }

  _listenToTripChanges() {
    tripChangesListener = FirebaseFirestore.instance.collection("BookedTrips").doc(trip!.id).snapshots().listen((event) {
      trip = BookedTripModel.fromDocument(event);
      update();
    });
  }

  _fetchTripDirection() async {
    final directions = await DirectionsController().getDirections(
      origin: trip!.userPickupLocation,
      destination: trip!.userDestinationLocation,
    );
    tripDirections = directions;
    update();
  }
}
