import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../data/models/booked_trip_model/booked_trip_model.dart';
import 'navigation_controller.dart';
import '../models/models.dart';
import '../ui/global_widgets/global_widgets.dart';
import '../ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';
import '../models/trip_location.model.dart';
import 'booked_trip_controller.dart';
import 'direction_controller.dart';
import 'dart:math' show cos, sqrt, asin, pi, sin;
// keep track of at what stage of the Trip is.

class Rider {
  Rider({required this.riderId, required this.distance});

  double distance;
  String riderId;
}

class NewTripBookingController extends GetxController {
  int tripBookingStep = 0;
  CameraPosition? initialCameraPosition;
  GoogleMapController? googleMapController;
  LatLng? currentCameraLatLng;
  TripLocationModel? pickup;
  TripLocationModel? destination;

  Map<String, dynamic>? prices;
  Directions? tripDirections;

  Map<String, Marker> availableRidersLocation = {};

  bool isStartedRequestingRider = false;
  Timer? nearestRiderTimer;

  late RequestNearbyRider requestNearbyRider;
  String? selectedVehicle;

  var currentCameraPosDebouncer = Debouncer(miliseconds: 400);

  int totalPrice = 0;

  StreamSubscription<QuerySnapshot>? nearbyRidersStream;

  Timer? _noRiderFoundTimer;

  _saveDeviceToken() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance.collection('users').doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  @override
  onInit() async {
    super.onInit();
    _saveDeviceToken();
    var currentPosition = await Geolocator.getCurrentPosition();
    currentCameraLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    initialCameraPosition = CameraPosition(
      target: currentCameraLatLng!,
      zoom: 11.5,
    );
    fetchPrices();
    update();
  }

  fetchPrices() async {
    var rawPrices = await FirebaseFirestore.instance.collection('prices').get();
    prices = rawPrices.docs[0].data();
  }

  double get tripDistance {
    try {
      return double.parse((RegExp(r'[0-9]*\.[0-9]*').firstMatch(tripDirections!.totalDistance)!.group(0)) ?? '0.0');
    } catch (e) {
      return 0.0;
    }
  }

  int get tripDurationInMins {
    var a = RegExp(r'[0-9]*').allMatches(tripDirections!.totalDuration);
    int totalMatches = 0;
    List<int> matches = [];
    a.toList().forEach((element) {
      if (RegExp(r'[0-9]+').hasMatch(element.group(0)!)) {
        totalMatches++;
        matches.add(int.parse(element.group(0)!));
      }
      // element.group(0).printInfo();
    });
    if (totalMatches == 3) {
      return ((matches[0] * 24) * 60) + (matches[1] * 60) + matches[2];
    } else if (totalMatches == 2) {
      return (matches[0] * 60) + matches[1];
    } else {
      return matches[0];
    }
  }

  int get totalTripPrice => (tripDurationInMins * tripDistance).toInt();

  pickupLocationSelectedByPlace(Place place) async {
    if (pickup == null) {
      pickup = TripLocationModel("Pickup", place.location.latitude, place.location.longitude, BitmapDescriptor.hueAzure);
    } else {
      pickup!.updateLatLng(place.location);
    }
    if (isDestinationLocationIsValid) {
      await _fetchTripDirection();
    }
    update();
  }

  destinationLocationSelectedByPlace(Place place) async {
    if (destination == null) {
      destination = TripLocationModel("Destination", place.location.latitude, place.location.longitude, BitmapDescriptor.hueRose);
    } else {
      destination!.updateLatLng(place.location);
    }
    await _fetchTripDirection();
    update();
  }

  pickupLocationByMap() async {
    try {
      if (pickup == null) {
        pickup = TripLocationModel("Pickup", currentCameraLatLng!.latitude, currentCameraLatLng!.longitude, BitmapDescriptor.hueAzure);
      } else {
        pickup!.updateLatLng(currentCameraLatLng!);
      }
      if (isDestinationLocationIsValid) {
        await _fetchTripDirection();
      }
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  destinationLocationByMap() async {
    try {
      if (destination == null) {
        destination = TripLocationModel("Destination", currentCameraLatLng!.latitude, currentCameraLatLng!.longitude, BitmapDescriptor.hueRose);
      } else {
        destination!.updateLatLng(currentCameraLatLng!);
      }
      await _fetchTripDirection();
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool get isPickupLocationIsValid => pickup != null;
  bool get isDestinationLocationIsValid => destination != null;

  _fetchTripDirection() async {
    final directions = await DirectionsController().getDirections(
      origin: pickup!.latlng,
      destination: destination!.latlng,
    );
    tripDirections = directions;
  }

  Future<bool> onRiderAcceptTrip(tripId, riderId) async {
    var bookedTripController = BookedTripController();
    var userData = await getCurrentUserData();
    var riderData = await getRiderData(riderId);

    bookedTripController.bookedTrip = BookedTripModel(
      id: tripId,
      bookedAt: DateTime.now().toString(),
      destinationAddress: destination!.address!,
      pickupAddress: pickup!.address!,
      userId: userData.id,
      userName: '${userData['firstName']} ${userData['lastName']}',
      userPhone: userData['phoneNumber'],
      userPickupLocation: pickup!.latlng,
      userDestinationLocation: destination!.latlng,
      riderId: riderId,
      riderName: '${riderData['firstName']} ${riderData['lastName']}',
      riderPhone: riderData['phoneNumber'],
      tripPrice: totalPrice,
      tripDistance: tripDistance,
      vehicleType: selectedVehicle as String,
    );
    return bookedTripController.create(tripId);
  }

  Future<bool> _doesTripIdExist(id) async {
    return (await FirebaseFirestore.instance.collection('inProcessingTrips').doc(id).get()).exists;
  }

  Future<String> get newTripId async {
    String tripId;
    do {
      tripId = getRandomString(30);
    } while (await _doesTripIdExist(tripId));
    return tripId;
  }

  _createNewTripInstance(String tripId) async {
    await FirebaseFirestore.instance.collection('inProcessingTrips').doc(tripId).set({
      'lat': pickup!.latitude.toString(),
      'lng': pickup!.longitude.toString(),
      'vehicle': selectedVehicle,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Timer get _noRiderTimer => Timer(const Duration(seconds: 15), () {
        if (Get.isDialogOpen!) Get.back();
        if (requestNearbyRider._availableRiders.length < 1) {
          "No Rider is available".printInfo();
          showAppSnackBar(
            'Rider',
            'No Rider is available right now',
            null,
            Icons.person_off,
          );
          nearbyRidersStream!.cancel();
        }
      });

  _initializeNearbyRiderListener(String tripId) {
    _noRiderFoundTimer = _noRiderTimer;

    nearbyRidersStream = FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('availableRiders')
        .snapshots()
        .listen(_onEventOccurInNearbyListener);
  }

  _onNewRiderFound(List<DocumentChange<Map>> riders) {
    for (var rider in riders) {
      var position = LatLng(rider.doc['lat'], rider.doc['lng']);
      var marker = Marker(
        markerId: MarkerId(getRandomString(10)),
        infoWindow: const InfoWindow(title: 'Rider'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: position,
      );

      availableRidersLocation.addAll({rider.doc.id: marker});
      requestNearbyRider.addRider(
        rider.doc.id,
        haversineDistance(pickup!.latlng, position),
      );
      update();
    }
  }

  _onEventOccurInNearbyListener(QuerySnapshot<Map<String, dynamic>> event) {
    print('New Riders Found: ${event.docChanges.length}');
    _onNewRiderFound(event.docChanges);

    if (!isStartedRequestingRider && requestNearbyRider._availableRiders.length > 0) {
      _noRiderFoundTimer!.cancel();
      "Started Requesting the riders".printInfo();
      isStartedRequestingRider = true;
      requestNearbyRider.start();
    }
    print('Available Riders are: ${availableRidersLocation.length}');
  }

  findNearbyRiders() async {
    isStartedRequestingRider = false;

    String tripId = await newTripId;

    requestNearbyRider = RequestNearbyRider(tripId, onRiderAcceptTrip);
    _createNewTripInstance(tripId);

    Get.dialog(const LoadingDialog('Searching Riders'));

    availableRidersLocation = {};
    _initializeNearbyRiderListener(tripId);
  }

  double haversineDistance(LatLng loc1, LatLng loc2) {
    var R = 3958.8; // Radius of the Earth in miles
    var rlat1 = loc1.latitude * (pi / 180); // Convert degrees to radians
    var rlat2 = loc2.latitude * (pi / 180); // Convert degrees to radians
    var difflat = rlat2 - rlat1; // Radian difference (latitudes)
    var difflon = (loc2.longitude - loc1.longitude) * (pi / 180); // Radian difference (longitudes)

    var d = 2 * R * asin(sqrt(sin(difflat / 2) * sin(difflat / 2) + cos(rlat1) * cos(rlat2) * sin(difflon / 2) * sin(difflon / 2)));
    return d;
  }

  Future<DocumentSnapshot> getCurrentUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  Future<DocumentSnapshot> getRiderData(String riderId) async {
    return await FirebaseFirestore.instance.collection('rider').doc(riderId).get();
  }

  @override
  void onClose() {
    super.onClose();
    if (googleMapController != null) {
      googleMapController!.dispose();
    }
  }

  forwardBookingState() {
    tripBookingStep++;
    update();
  }

  backwardBookingState() {
    tripBookingStep--;
    update();
  }

  void resetBookingState() {
    tripBookingStep = 0;
    pickup = null;
    destination = null;
    availableRidersLocation.clear();
    tripDirections = null;
  }

  Future<String?> getAddressFromLatLng(LatLng latlng) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
      Placemark place = p[0];
      return "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      "Error: $e".printInfo();
    }
  }
}

class RequestNearbyRider {
  RequestNearbyRider(this.tripId, this.onRiderAcceptTrip);

  final Function onRiderAcceptTrip;

  // amount of seconds at most the rider is given to make decision
  final int timeOutSeconds = 20;

  Timer? timeOutTimer;

  // A Random id of 20 length
  // to uniquely identify the In Processing trip at both ends
  final String tripId;

  // Priority list of Riders based on nearest to Client
  final _availableRiders = PriorityQueue<Rider>((a, b) => a.distance.compareTo(b.distance));

  Rider? _currentNearestRider;
  bool _isRequestingStarted = false;

  // Subscription for listening to RidersResponse
  // weather the answer is 'Yes' or 'No'
  late StreamSubscription<dynamic> _responseListener;

  void addRider(id, distance) => _availableRiders.add(Rider(riderId: id, distance: distance));

  // return the current nearest rider if exist
  Rider? get currentNearestRider => _currentNearestRider;

  // it will remove the nearest rider from the priority list
  // and save it in the currentNearestRider also return's it
  Rider get _removeNearest {
    _currentNearestRider = _availableRiders.removeFirst();
    return _currentNearestRider as Rider;
  }

  _initEmptyRiderResponse(String riderId) async {
    return await FirebaseFirestore.instance.collection('inProcessingTrips').doc(tripId).collection('ridersResponse').doc(riderId).set({
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }

  _sendRequestToRider(String riderId) {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('requestTheRiderAboutNewTrip');
    callable.call(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'riderId': riderId,
      'tripId': tripId,
      'timeout': timeOutSeconds.toString(),
    }).then((value) {
      print('Returned Value from Server: $value');
    }, onError: (error) {
      print('Error Occurred in HTTP Call $error');
    });

    timeOutTimer = Timer(Duration(seconds: timeOutSeconds + 3), () {
      print('Rider did not respond back After ${timeOutSeconds + 3} seconds');
      _responseListener.cancel();
      start();
    });
  }

  _listenToRiderResponse(String riderId) {
    printInfo(info: 'Start Listening to Rider response');
    _responseListener = FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('ridersResponse')
        .doc(riderId)
        .snapshots()
        .listen((doc) async {
      if (doc.data()!.containsKey('response')) {
        timeOutTimer!.cancel();
        print('Rider responded back with Response = ${doc['response']}');
        _responseListener.cancel();
        _onReceivingResponseFromTheRider(doc, riderId);
      }
    });
  }

  _onReceivingResponseFromTheRider(doc, riderId) async {
    if (doc['response']) {
      if (Get.isDialogOpen as bool) {
        Get.back();
      }
      showAppSnackBar(
        'Ride',
        'Rider Successfully accepted the trip',
        null,
        Icons.check_circle,
      );
      Get.dialog(const LoadingDialog("Booking the Trip"));
      //  Rider have accepted the ride
      if (await onRiderAcceptTrip(tripId, riderId)) {
        printInfo(info: 'Successfully Added booking');
        if (Get.isDialogOpen!) Get.back();
        Get.find<NavigationController>().moveToMyTrips();
      }
    } else {
      //  Rider have rejected the ride
      //TODO: In Future Add penalty to the rejected rider
      start();
    }
  }

  void start() async {
    if (!_isRequestingStarted) {
      if (Get.isDialogOpen!) Get.back();
      Get.dialog(const LoadingDialog('Finding Nearest Rider Available'));
      _isRequestingStarted = true;
      printInfo(info: 'Requesting to Riders have been Started');
    }
    if (_availableRiders.length > 0) {
      printInfo(info: 'Requesting a New Rider for trip');
      // Remove the nearest rider;
      String riderId = _removeNearest.riderId;
      //Create Empty Rider Response in the Firebase
      await _initEmptyRiderResponse(riderId);
      // Send Rider the Request
      _sendRequestToRider(riderId);
      // Listen to Rider Response
      // Scenarios
      // 1. User Response in the first [timeoutSeconds] seconds with 'Yes' or 'No'
      // 2. User won't response in [timeoutSeconds] seconds and which will be considered as 'No'
      _listenToRiderResponse(riderId);
    } else {
      if (Get.isDialogOpen as bool) {
        Get.back();
      }
      showAppSnackBar(
        'Rider',
        'No Rider is available right now',
        null,
        Icons.person_off,
      );
      //  Remove the extra data from the Firestore
    }
  }
}
