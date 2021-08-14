import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../utils.dart';
import 'TripStateWidgets.dart';
import 'widgets.dart';
import 'dart:math' show cos, sqrt, asin, pi, sin;

//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Make AppStyle Consisten                                  ✘
// TODO:        Fetch User's Current Location                            ✘
// TODO:        Show Error (Location Service Not Enabled)                ✘
// TODO:        Show Error (Location Permission Not given)               ✘
// TODO:        Learn Position Stream From GeoLocator Pub.dev            ✘
// TODO:        Fetch Current user Data                                  ✘

class Rider {
  String riderId;
  double distance;

  Rider({required this.riderId, required this.distance});
}

// keep track of at what stage of the Trip is.
enum BookingState { idle, locationByPlace, locationByMap, vehicle, rider, done }
// Check weather the user is setting pickup or destination.
enum LocationEditorType { pickup, destination }
// Check weather the user want a Rikshaw, Bike or Car

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // static late final _initialPosition;
  BookingState currentBookingState = BookingState.idle;
  LocationEditorType currentLocationType = LocationEditorType.pickup;

  Position? _currentPosition;
  late LatLng _currentCameraCoordinates;
  Debouncer currentCameraPosDebouncer = Debouncer(miliseconds: 200);

  late GoogleMapController _googleMapController;
  late Marker _pickupMarker;
  late String _pickupAddress;
  late LatLng _pickupLocation;

  Marker? _destinationMarker;
  String? _destinationAddress;
  LatLng? _destinationLocation;

  late AnimationController _placeAnimationController;
  late AnimationController _mapAnimationController;

  Directions? _tripDirections;

  bool isScheduling = false;
  bool isStartedRequestingRider = false;

  Map<String, Marker> availableRidersLocation = {};

  late RequestNearbyRider _requestNearbyRider;

  Timer? nearestRiderTimer;

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    _getCurrentPosition().then((position) {
      this._currentPosition = position;
      _currentCameraCoordinates = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(position.latitude, position.longitude)
          .then((address) {
        this.setState(() {
          _pickupLocation = _currentCameraCoordinates;
          _pickupAddress = address!;
          _addPickupMarker(_pickupLocation as LatLng);
        });
      });
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _placeAnimationController.dispose();
    super.dispose();
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // FirebaseUser user = await _auth.currentUser();

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _currentPosition == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  // Google Map
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 11.5,
                    ),
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    markers: {
                      _pickupMarker,
                      if (_destinationMarker != null)
                        _destinationMarker as Marker,
                      if (availableRidersLocation.length != 0)
                        ...availableRidersLocation.values.toSet(),
                    },
                    polylines: {
                      if (_tripDirections != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          points: _tripDirections!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    onCameraMove: (position) {
                      if (currentBookingState == BookingState.locationByMap)
                        currentCameraPosDebouncer.run(() {
                          this.setState(() {
                            _currentCameraCoordinates = LatLng(
                              position.target.latitude,
                              position.target.longitude,
                            );
                          });
                        });
                    },
                    onCameraIdle: () {},
                    // onLongPress: _addMarker,
                  ),
                  // Middle Circle
                  Positioned(
                    child: Icon(
                      Icons.location_on,
                      size: 30.0,
                      color: AppColors.primary,
                    ),
                  ),
                  // Bottom Container
                  if (currentBookingState == BookingState.idle)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: TripAtIdleState(
                        onSchedule: () {
                          this.setState(() {
                            this.currentBookingState =
                                BookingState.locationByPlace;
                            this.isScheduling = true;
                          });
                        },
                      ),
                    ),
                  if (this.isScheduling &&
                      currentBookingState == BookingState.locationByPlace)
                    FadeIn(
                      duration: Duration(milliseconds: 200),
                      controller: (controller) {
                        _placeAnimationController = controller;
                      },
                      child: LocationByPlace(
                        pickupAddress: this._pickupAddress,
                        pickupLocation: _pickupLocation,
                        onBack: () {
                          _placeAnimationController.reverse().then((value) {
                            this.setState(() {
                              this.isScheduling = false;
                              this.currentBookingState = BookingState.idle;
                            });
                          });
                        },
                        onLocationByMap: () {
                          _placeAnimationController.reverse().then((value) {
                            this.setState(() {
                              this.currentBookingState =
                                  BookingState.locationByMap;
                            });
                          });
                        },
                        onDestinationSelected: (Place place) async {
                          this._destinationLocation = place.location;
                          this._destinationAddress = place.address;
                          _addDestinationMarker(place.location);

                          final directions = await DirectionsController()
                              .getDirections(
                                  origin: _pickupMarker.position,
                                  destination: _destinationMarker!.position);
                          _tripDirections = directions;

                          // this._destinationMarker
                        },
                        onPickupSelected: (Place place) async {
                          this._pickupLocation = place.location;
                          this._pickupAddress = place.address;
                          _addPickupMarker(place.location);
                          if (_destinationMarker != null) {
                            final directions = await DirectionsController()
                                .getDirections(
                                    origin: _pickupMarker.position,
                                    destination: _destinationMarker!.position);
                            _tripDirections = directions;
                          }
                        },
                        destinationLocation: this._destinationLocation,
                        destinationAddress: this._destinationAddress,
                        onContinue: _onDoneSelectingAddress,
                      ),
                    ),
                  if (currentBookingState == BookingState.locationByMap)
                    FadeIn(
                      duration: Duration(milliseconds: 200),
                      controller: (controller) {
                        _mapAnimationController = controller;
                      },
                      child: LocationByMap(
                        onBack: () {
                          _mapAnimationController.reverse().then((value) {
                            this.setState(() {
                              currentBookingState =
                                  BookingState.locationByPlace;
                            });
                          });
                        },
                        pickupAddress: this._pickupAddress,
                        pickupLocation: _pickupLocation,
                        destinationAddress: this._destinationAddress,
                        destinationLocation: this._destinationLocation,
                        onPickupSelected: () {
                          if (currentLocationType !=
                              LocationEditorType.pickup) {
                            this.setState(() {
                              currentLocationType = LocationEditorType.pickup;
                            });
                          }
                        },
                        onDestinationSelected: () {
                          if (currentLocationType !=
                              LocationEditorType.destination) {
                            this.setState(() {
                              currentLocationType =
                                  LocationEditorType.destination;
                            });
                          }
                        },
                        onContinue: _onDoneSelectingAddress,
                        onConfirmLocation: () async {
                          final lat = _currentCameraCoordinates.latitude;
                          final lng = _currentCameraCoordinates.longitude;
                          if (currentLocationType ==
                              LocationEditorType.destination) {
                            this._destinationLocation = LatLng(lat, lng);
                            this._destinationAddress =
                                await _getAddressFromLatLng(lat, lng);
                            this._addDestinationMarker(
                                this._destinationLocation!);
                          } else {
                            this._pickupLocation = LatLng(lat, lng);
                            this._pickupAddress =
                                await _getAddressFromLatLng(lat, lng) as String;
                            this._addPickupMarker(this._pickupLocation);
                          }
                          if (_destinationMarker != null) {
                            final directions = await DirectionsController()
                                .getDirections(
                                    origin: _pickupMarker.position,
                                    destination: _destinationMarker!.position);
                            _tripDirections = directions;
                          }
                          this.setState(() {});
                        },
                      ),
                    ),
                  if (currentBookingState == BookingState.vehicle)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ChoseVehicle(
                        onBack: () {
                          this.setState(() {
                            currentBookingState = BookingState.locationByPlace;
                          });
                        },
                        onVehicleSelected: () {
                          this.setState(() {
                            currentBookingState = BookingState.rider;
                            findNearbyRiders();
                          });
                        },
                      ),
                    ),
                  if (currentBookingState == BookingState.rider)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: HomeBackButton(onTap: () {
                        this.setState(() {
                          currentBookingState = BookingState.vehicle;
                        });
                      }),
                    ),
                  if (currentBookingState == BookingState.done)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BookingDone(
                        onBack: () {
                          this.setState(() {
                            currentBookingState = BookingState.rider;
                          });
                        },
                        tripInfo: {
                          'distance': this._tripDirections!.totalDistance,
                          'duration': this._tripDirections!.totalDuration,
                          'destination': this._destinationAddress as String,
                          'pickup': this._pickupAddress,
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  _onDoneSelectingAddress() {
    if (_destinationMarker == null) {
      Get.snackbar('Destination', 'Pickup & Destination address is required');
      return;
    }
    this.setState(() {
      currentBookingState = BookingState.vehicle;
    });
  }

  Future<String?> _getAddressFromLatLng(lat, lng) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(lat, lng);
      Placemark place = p[0];
      print(place.toJson());
      return "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.snackbar('Location Service',
          'Device Location services is not enabled. Enable the services to use the app.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location Permission',
            'Location Permission is denied. App need Location to work. Give the app Location permission');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _addPickupMarker(LatLng pos) async {
    _pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      infoWindow: const InfoWindow(title: 'pickup'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      position: pos,
    );
  }

  void _addDestinationMarker(LatLng pos) async {
    this._destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pos,
    );
  }

  findNearbyRiders() async {
    var id = getRandomString(20);
    _requestNearbyRider = RequestNearbyRider(id);
    print('Rider');
    await FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(id)
        .set({
      'lat': _pickupLocation.latitude.toString(),
      'lng': _pickupLocation.longitude.toString(),
    });
    availableRidersLocation = {};
    FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(id)
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
          haversineDistance(_pickupLocation, position),
        );
      });
      this.setState(() {
        if (!this.isStartedRequestingRider &&
            _requestNearbyRider._availableRiders.length > 0) {
          this.isStartedRequestingRider = true;
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
}

class RequestNearbyRider {
  bool isRequestingStarted = false;
  var _availableRiders =
      PriorityQueue<Rider>((a, b) => a.distance.compareTo(b.distance));
  Rider? _currentNearestRider;
  String tripId;
  late Timer timer;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _responseListener;

  RequestNearbyRider(this.tripId);

  void addRider(id, distance) =>
      this._availableRiders.add(Rider(riderId: id, distance: distance));

  Rider? get currentNearestRider => _currentNearestRider;

  Rider get _removeNearest {
    _currentNearestRider = this._availableRiders.removeFirst();
    return _currentNearestRider as Rider;
  }

  removeListener() {
    _responseListener.cancel();
  }

  _requestTheNearestRider() {
    if (_availableRiders.length > 0) {
      String riderId = this._removeNearest.riderId;
      FirebaseFirestore.instance
          .collection('inProcessingTrips')
          .doc(tripId)
          .collection('ridersResponse')
          .doc(riderId)
          .set({
        'requestedAt': FieldValue.serverTimestamp(),
      });
      HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('requestTheRiderAboutNewTrip');
      callable.call(<String, dynamic>{
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'riderId': riderId,
        'tripId': tripId,
      });
      _responseListener = FirebaseFirestore.instance
          .collection('inProcessingTrips')
          .doc(tripId)
          .collection('ridersResponse')
          .doc(riderId)
          .snapshots()
          .listen((event) {
        if (event.data()!.containsKey('response')) {
          removeListener();
        }
      });
    } else {
      isRequestingStarted = false;
    }
  }

  void start() async {
    String riderId = this._removeNearest.riderId;
    await FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('ridersResponse')
        .doc(riderId)
        .set({
      'requestedAt': FieldValue.serverTimestamp(),
    });
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('requestTheRiderAboutNewTrip');
    callable.call(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'riderId': riderId,
      'tripId': tripId,
    });
    FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(tripId)
        .collection('ridersResponse')
        .doc(riderId)
        .snapshots()
        .listen((event) {
      print(event.data());
      print(event.metadata);
    });
  }

  // void start([int? seconds]) {
  //   isRequestingStarted = true;
  //   _requestTheNearestRider();
  //   timer = Timer.periodic(Duration(seconds: seconds ?? 20), (tim) {
  //     if (!this.isRequestingStarted)
  //       timer.cancel();
  //     else {
  //       this._requestTheNearestRider();
  //     }
  //   });
  // }
}

// Steps
// 1 -> Idle
// 2 -> Chose Location
//    2.1 -> By Nearby Place(Place Name)
//    2.2 -> or By Using Map
// 3. Chose Vehicle
