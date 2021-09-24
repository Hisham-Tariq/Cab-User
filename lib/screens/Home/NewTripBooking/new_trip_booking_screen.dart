import 'dart:async';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin, pi, sin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:driving_app_its/screens/Home/home_drawer.dart';
import '../../../controller/controller.dart';
import 'package:driving_app_its/models/models.dart';
import 'Widgets/middle_screen_icon.dart';
import '../NewTripBooking/set_location.dart';
import 'package:driving_app_its/widgets/Debouncer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils.dart';
import 'booking_state.dart';
import 'trip_state_widgets.dart';
import 'widgets.dart';

class Rider {
  Rider({required this.riderId, required this.distance});

  double distance;
  String riderId;
}

class NewTripBookingScreen extends StatefulWidget {
  const NewTripBookingScreen({Key? key}) : super(key: key);

  @override
  _NewTripBookingScreenState createState() => _NewTripBookingScreenState();
}

class _NewTripBookingScreenState extends State<NewTripBookingScreen> {
  Map<String, Marker> availableRidersLocation = {};
  // static late final _initialPosition;

  bool isStartedRequestingRider = false;
  Timer? nearestRiderTimer;

  late RequestNearbyRider _requestNearbyRider;
  String? _selectedVehicle;

  var tripController = Get.find<NewTripBookingController>();

  var currentCameraPosDebouncer = Debouncer(miliseconds: 400);

  final scaf = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
  }

  _saveDeviceToken() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  Future<bool> onRiderAcceptTrip(tripId, riderId) async {
    var controller = BookedTripController();
    var userData = await getCurrentUserData();
    var riderData = await getRiderData(riderId);
    print('Trip Distance: ${tripController.tripDirections!.totalDistance}');
    var t = RegExp(r'[0-9]*\.[0-9]*')
        .firstMatch(tripController.tripDirections!.totalDistance)!
        .group(0);
    print('Trip Distance in double: $t');
    var distance = double.parse(t!);
    controller.bookedTrip = BookedTripModel(
      userId: userData.id,
      userName: '${userData['firstName']} ${userData['lastName']}',
      userPhone: userData['phoneNumber'],
      userPickupLocation: tripController.pickupLatLng as LatLng,
      userDestinationLocation: tripController.destinationLatLng as LatLng,
      riderId: riderId,
      riderName: '${riderData['firstName']} ${riderData['lastName']}',
      riderPhone: riderData['phoneNumber'],
      tripPrice: 500,
      tripDistance: distance,
      vehicleType: _selectedVehicle as String,
    );
    return controller.create(tripId);
  }

  Future<bool> doesTripIdExist(id) async {
    return (await FirebaseFirestore.instance
            .collection('inProcessingTrips')
            .doc(id)
            .get())
        .exists;
  }

  findNearbyRiders() async {
    isStartedRequestingRider = false;
    String tripId;
    do {
      tripId = getRandomString(30);
    } while (await doesTripIdExist(tripId));
    _requestNearbyRider = RequestNearbyRider(tripId, onRiderAcceptTrip);
    print('Rider');
    await FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .set({
      'lat': tripController.pickupLatLng!.latitude.toString(),
      'lng': tripController.pickupLatLng!.longitude.toString(),
      'vehicle': _selectedVehicle,
    });
    _loadingDialog('Searching Riders');
    var timer = Timer(const Duration(seconds: 15), () {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (_requestNearbyRider._availableRiders.length < 1) {
        Get.snackbar('Riders', 'No rider availabel right now try again later');
      }
    });
    availableRidersLocation = {};
    FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('availableRiders')
        .snapshots()
        .listen((event) {
      print('New Riders Found: ${event.docChanges.length}');
      event.docChanges.forEach((rider) {
        var position =
            LatLng(rider.doc.data()!['lat'], rider.doc.data()!['lng']);
        var marker = Marker(
          markerId: MarkerId(getRandomString(10)),
          infoWindow: const InfoWindow(title: 'Rider'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: position,
        );

        availableRidersLocation.addAll({rider.doc.id: marker});
        _requestNearbyRider.addRider(
          rider.doc.id,
          haversineDistance(tripController.pickupLatLng!, position),
        );
      });
      setState(() {
        if (!isStartedRequestingRider &&
            _requestNearbyRider._availableRiders.length > 0) {
          isStartedRequestingRider = true;
          timer.cancel();
          _requestNearbyRider.start();
        }
        print('Available Riders are: ${availableRidersLocation.length}');
      });
    });
  }

  double haversineDistance(LatLng loc1, LatLng loc2) {
    var R = 3958.8; // Radius of the Earth in miles
    var rlat1 = loc1.latitude * (pi / 180); // Convert degrees to radians
    var rlat2 = loc2.latitude * (pi / 180); // Convert degrees to radians
    var difflat = rlat2 - rlat1; // Radian difference (latitudes)
    var difflon = (loc2.longitude - loc1.longitude) *
        (pi / 180); // Radian difference (longitudes)

    var d = 2 *
        R *
        asin(sqrt(sin(difflat / 2) * sin(difflat / 2) +
            cos(rlat1) * cos(rlat2) * sin(difflon / 2) * sin(difflon / 2)));
    return d;
  }

  Future<DocumentSnapshot> getCurrentUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Future<DocumentSnapshot> getRiderData(String riderId) async {
    return await FirebaseFirestore.instance
        .collection('rider')
        .doc(riderId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaf,
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      body: GetBuilder<NewTripBookingController>(builder: (logic) {
        if (logic.currentLatLng == null) {
          return const Center(
            child: SpinKitFadingCircle(color: Colors.green),
          );
        } else {
          return SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Google Map
                GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition:
                      logic.initialCameraPosition as CameraPosition,
                  onMapCreated: (controller) =>
                      logic.googleMapController = controller,
                  markers: {
                    logic.markers['pickup'] as Marker,
                    if (logic.markers['destination'] != null)
                      logic.markers['destination'] as Marker,
                    if (availableRidersLocation.isNotEmpty)
                      ...availableRidersLocation.values.toSet(),
                  },
                  polylines: {
                    if (logic.tripDirections != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: logic.tripDirections!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  onCameraMove: (position) {
                    if (logic.currentBookingState == BookingState.pickup ||
                        logic.currentBookingState == BookingState.destination) {
                      currentCameraPosDebouncer.run(() {
                        logic.currentCameraLatLng = LatLng(
                          position.target.latitude,
                          position.target.longitude,
                        );
                      });
                    }
                  },
                ),
                // Middle Circle
                const Positioned(child: MiddleScreenLocationIcon()),
                // Bottom Container

                if (logic.currentBookingState == BookingState.idle)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 15.0,
                        ),
                        onPressed: () {
                          scaf.currentState!.openDrawer();
                        },
                      ),
                    ),
                  ),
                if (logic.currentBookingState == BookingState.idle)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: TripAtIdleState(
                      onSchedule: () {
                        setState(() {
                          logic.changeBookingState(BookingState.pickup);
                        });
                      },
                    ),
                  ),
                AnimatedPositioned(
                  top: logic.currentBookingState == BookingState.pickup
                      ? 0
                      : Get.height,
                  child: SetLocation(
                    title: 'Pickup',
                    onBack: () {
                      logic.changeBookingState(BookingState.idle);
                    },
                    onContinue: () {
                      if (logic.isPickupLocationIsValid()) {
                        setState(() {
                          logic.currentBookingState = BookingState.destination;
                        });
                      } else {
                        Get.snackbar(
                          'Pickup Location',
                          'Please chose a valid pickup location',
                        );
                      }
                    },
                    onLocationSelectedByPlace:
                        logic.pickupLocationSelectedByPlace,
                    onLocationSelectedByMap: logic.pickupLocationByMap,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                AnimatedPositioned(
                  top: logic.currentBookingState == BookingState.destination
                      ? 0
                      : Get.height,
                  child: SetLocation(
                    onBack: () {
                      logic.changeBookingState(BookingState.pickup);
                    },
                    title: 'Destination',
                    onContinue: () {
                      if (logic.isDestinationLocationIsValid()) {
                        setState(() {
                          logic.changeBookingState(BookingState.vehicle);
                        });
                      } else {
                        Get.snackbar(
                          'Pickup Location',
                          'Please chose a valid pickup location',
                        );
                      }
                    },
                    onLocationSelectedByPlace:
                        logic.destinationLocationSelectedByPlace,
                    onLocationSelectedByMap: logic.destinationLocationByMap,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                if (logic.currentBookingState == BookingState.vehicle)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ChoseVehicle(
                      onBack: () {
                        setState(() {
                          logic.changeBookingState(BookingState.destination);
                        });
                      },
                      onVehicleSelected: (String vehicle) {
                        setState(() {
                          _selectedVehicle = vehicle;
                          logic.changeBookingState(BookingState.rider);
                          findNearbyRiders();
                        });
                      },
                    ),
                  ),
                if (logic.currentBookingState == BookingState.rider)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: HomeBackButton(
                      onTap: () {
                        setState(() {
                          logic.changeBookingState(BookingState.vehicle);
                        });
                      },
                    ),
                  ),
                if (logic.currentBookingState == BookingState.done)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BookingDone(
                      onBack: () {
                        setState(() {
                          logic.changeBookingState(BookingState.rider);
                        });
                      },
                      tripInfo: {
                        'distance': logic.tripDirections!.totalDistance,
                        'duration': logic.tripDirections!.totalDuration,
                        'destination': logic.destinationAddress as String,
                        'pickup': logic.pickupAddress as String,
                      },
                    ),
                  ),
              ],
            ),
          );
        }
      }),
    );
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
  var _availableRiders =
      PriorityQueue<Rider>((a, b) => a.distance.compareTo(b.distance));

  Rider? _currentNearestRider;
  bool _isRequestingStarted = false;
  // Subscription for listening to RidersResponse
  // weather the answer is 'Yes' or 'No'
  late StreamSubscription<dynamic> _responseListener;

  void addRider(id, distance) =>
      _availableRiders.add(Rider(riderId: id, distance: distance));

  // return the current nearest rider if exist
  Rider? get currentNearestRider => _currentNearestRider;

  // it will remove the nearest rider from the priority list
  // and save it in the currentNearestRider also return's it
  Rider get _removeNearest {
    _currentNearestRider = _availableRiders.removeFirst();
    return _currentNearestRider as Rider;
  }

  _initEmptyRiderResponse(String riderId) async {
    return await FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('ridersResponse')
        .doc(riderId)
        .set({
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }

  _sendRequestToRider(String riderId) {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('requestTheRiderAboutNewTrip');
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
      Get.snackbar('Ride', 'Rider Successfully accepted the trip');
      //  Rider have accepted the ride
      if (await onRiderAcceptTrip(tripId, riderId)) {
        printInfo(info: 'Successfully Added booking');
      }
    } else {
      //  Rider have rejected the ride
      //TODO: In Future Add penalty to the rejected rider
      start();
    }
  }

  void start() async {
    if (!_isRequestingStarted) {
      _loadingDialog('Finding Nearest Rider Available');
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
      Get.snackbar('Rider', 'No Rider is available right now');
      //  Remove the extra data from the Firestore
    }
  }
}

_loadingDialog(title) {
  Get.dialog(
    Dialog(
      child: Container(
        height: 200,
        width: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
