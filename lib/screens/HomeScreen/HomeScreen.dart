import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:timelines/timelines.dart';

import '../../utils.dart';
//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Make AppStyle Consisten                                  ✘
// TODO:        Fetch User's Current Location                            ✘
// TODO:        Show Error (Location Service Not Enabled)                ✘
// TODO:        Show Error (Location Permission Not given)               ✘
// TODO:        Learn Position Stream From GeoLocator Pub.dev            ✘
// TODO:        Fetch Current user Data                                  ✘

// keep track of at what stage of the Trip is.
enum BookingState { idle, locationByPlace, locationByMap, vehicle, rider, done }
// Check weather the user is setting pickup or destination.
enum LocationEditorType { pickup, destination }
// Check weather the user want a Rikshaw, Bike or Car
enum VehicleTypes { rikshaw, bike, car }
// At What stage of Chosing Vehicle is
// 1. Main Type such as Rikshaw, Car, or Bike --> VehicleType
//          or
// 2. Some Specific Vehicle such as in Bikes it could be Seventy --> SpecificVehicle
enum ChoseVehicleState { vehicleType, specificVehicle }

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

  Set<Marker>? availableRidersMarkers;
  List<dynamic>? availableRiders;

  @override
  void initState() {
    super.initState();

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
                      if (availableRidersMarkers != null)
                        ...availableRidersMarkers!,
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
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        height: 200,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _ScheduleTripButton(
                            onSchedule: () {
                              this.setState(() {
                                this.currentBookingState =
                                    BookingState.locationByPlace;
                                this.isScheduling = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  if (this.isScheduling &&
                      currentBookingState == BookingState.locationByPlace)
                    Positioned(
                      child: ElasticIn(
                        duration: Duration(milliseconds: 200),
                        controller: (controller) {
                          _placeAnimationController = controller;
                        },
                        child: _LocationByPlace(
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
                                      destination:
                                          _destinationMarker!.position);
                              _tripDirections = directions;
                            }
                          },
                          destinationLocation: this._destinationLocation,
                          destinationAddress: this._destinationAddress,
                          onContinue: _onDoneSelectingAddress,
                        ),
                      ),
                    ),
                  if (currentBookingState == BookingState.locationByMap)
                    Positioned(
                      child: FadeIn(
                        duration: Duration(milliseconds: 200),
                        controller: (controller) {
                          _mapAnimationController = controller;
                        },
                        child: _LocationByMap(
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
                                  await _getAddressFromLatLng(lat, lng)
                                      as String;
                              this._addPickupMarker(this._pickupLocation);
                            }
                            if (_destinationMarker != null) {
                              final directions = await DirectionsController()
                                  .getDirections(
                                      origin: _pickupMarker.position,
                                      destination:
                                          _destinationMarker!.position);
                              _tripDirections = directions;
                            }
                            this.setState(() {});
                          },
                        ),
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
                      child: _BackButton(onTap: () {
                        this.setState(() {
                          currentBookingState = BookingState.vehicle;
                        });
                      }),
                    ),
                  if (currentBookingState == BookingState.done)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _BookingDone(
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _googleMapController.animateCamera(
        //     _info != null
        //         ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
        //         : CameraUpdate.newCameraPosition(_initialPosition),
        //   ),
        //   child: Icon(Icons.center_focus_strong),
        // ),
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
      // String address = addresses.get(0).getAddressLine(0); // If any additional address line present than only, check with max available address lines by getMaxAddressLineIndex()
      // String city = addresses.get(0).getLocality();
      // String state = addresses.get(0).getAdminArea();
      // String country = addresses.get(0).getCountryName();
      // String postalCode = addresses.get(0).getPostalCode();
      // String knownName = addresses.get(0).getFeatureName();
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
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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
    print('Rider');
    await FirebaseFirestore.instance.collection('needRider').doc(id).set({
      'lat': _pickupLocation.latitude.toString(),
      'lng': _pickupLocation.longitude.toString(),
    });
    FirebaseFirestore.instance
        .collection('availableRiders')
        .doc(id)
        .collection('riders')
        .snapshots()
        .listen((event) {
      availableRiders = event.docs;
      print(event.docChanges.length);
      if (event.docChanges.length > 0) {
        print(event.docChanges.first.doc.data()!['lat']);
      }
      List<Marker> markers = [];
      event.docs.forEach((e) {
        var marker = Marker(
          markerId: MarkerId(getRandomString(10)),
          infoWindow: const InfoWindow(title: 'Rider'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: LatLng(e.data()['lat'], e.data()['lng']),
        );
        markers.add(marker);
      });
      this.setState(() {
        availableRidersMarkers = markers.toSet();
        print(availableRidersMarkers!.length);
      });
    });
  }
}

class _ScheduleTripButton extends StatelessWidget {
  const _ScheduleTripButton({Key? key, required this.onSchedule})
      : super(key: key);
  final Callback onSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO: Task Position
        Text(
          'Good Afternoon Test',
          style: AppTextStyle.heading1,
        ),
        VerticalAppSpacer(),
        GestureDetector(
          onTap: onSchedule,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Where to?',
                    style: AppTextStyle.heading1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Center(
                    child: Text('Schedule', style: AppTextStyle.small),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key, required this.onTap}) : super(key: key);

  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        child: Icon(Icons.arrow_back, color: Colors.white),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
      ),
    );
  }
}

class _LocationByPlace extends StatefulWidget {
  final String pickupAddress;
  final LatLng pickupLocation;
  final String? destinationAddress;
  final LatLng? destinationLocation;
  final Callback onBack;
  final void Function(Place) onDestinationSelected;
  final void Function(Place) onPickupSelected;
  final Callback onContinue;
  final Callback onLocationByMap;

  const _LocationByPlace({
    Key? key,
    required this.onBack,
    required this.onDestinationSelected,
    required this.onPickupSelected,
    this.pickupAddress = '',
    required this.pickupLocation,
    required this.onLocationByMap,
    required this.onContinue,
    this.destinationAddress,
    this.destinationLocation,
  }) : super(key: key);

  @override
  _LocationByPlaceState createState() => _LocationByPlaceState();
}

class _LocationByPlaceState extends State<_LocationByPlace> {
  bool isDestinationSelected = false;
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final searchPlaceDebouncer = Debouncer(miliseconds: 300);
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    this.pickupController.text = widget.pickupAddress;
    this.destinationController.text = widget.destinationAddress ?? '';
  }

  _LocationByPlaceState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            children: [
              // VerticalAppSpacer(space: 24.0),
              Row(
                children: [
                  HorizontalAppSpacer(space: 50),
                  CurrentTimeField(),
                ],
              ),
              VerticalAppSpacer(),
              Row(
                children: [
                  Container(
                    width: 50,
                    child: Column(
                      children: [
                        DotIndicator(color: AppColors.primary),
                        // !isDestinationSelected
                        //     ? DotIndicator(color: AppColors.primary)
                        //     : OutlinedDotIndicator(color: AppColors.primary),
                        SizedBox(
                          height: 60.0,
                          child: isDestinationSelected
                              ? SolidLineConnector(color: AppColors.primary)
                              : DashedLineConnector(color: AppColors.primary),
                        ),
                        isDestinationSelected
                            ? DotIndicator(color: AppColors.primary)
                            : OutlinedDotIndicator(color: AppColors.primary),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _addressTextFields(
                          controller: pickupController,
                          hint: 'From?',
                          onTap: _onFocusOnPickup,
                          onTapOnMap: () {
                            widget.onLocationByMap();
                          },
                        ),
                        VerticalAppSpacer(),
                        _addressTextFields(
                          controller: destinationController,
                          hint: 'Where to?',
                          onTap: _onFocusOnDestination,
                          onTapOnMap: () {
                            widget.onLocationByMap();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VerticalAppSpacer(space: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => _onLocationSelected(index),
                            leading: Container(
                              height: 25,
                              width: 25,
                              child: Icon(
                                Icons.place,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            title: Text(
                              places[index].name,
                              style: AppTextStyle.title,
                            ),
                            horizontalTitleGap: 1.0,
                            subtitle: Text(
                              places[index].address,
                              style: AppTextStyle.subtitle,
                            ),
                          ),
                          Divider(height: 0.5),
                        ],
                      ),
                    );
                  },
                ),
              ),
              VerticalAppSpacer(),
              FullTextButton(onPressed: widget.onContinue, text: 'Continue'),
              VerticalAppSpacer(),
            ],
          ),
          Positioned(
            // left: 0,
            // top: 0,
            child: _BackButton(onTap: widget.onBack),
          ),
        ],
      ),
    );
  }

  TextField _addressTextFields({
    required TextEditingController controller,
    required String hint,
    required Callback onTapOnMap,
    required Callback onTap,
  }) {
    return TextField(
      controller: controller,
      style: AppTextStyle.textField,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onTapOnMap,
          child: Icon(
            Icons.map,
            color: AppColors.primary,
          ),
        ),
        hintText: hint,
      ),
      onTap: onTap,
      onChanged: (value) {
        searchPlaceDebouncer.run(() {
          var placeController = PlaceController();
          placeController
              .getNearbyPlaces(
            userLocation: widget.pickupLocation,
            keyword: value,
          )
              .then((value) {
            this.setState(() {
              this.places = value;
            });
          });
        });
      },
    );
  }

  _onFocusOnPickup() {
    if (this.isDestinationSelected)
      this.setState(() {
        this.isDestinationSelected = false;
      });
  }

  _onFocusOnDestination() {
    if (!this.isDestinationSelected)
      this.setState(() {
        this.isDestinationSelected = true;
      });
  }

  _onLocationSelected(int index) {
    if (this.isDestinationSelected) {
      destinationController.text = places[index].name;
      widget.onDestinationSelected(places[index]);
    } else {
      pickupController.text = places[index].name;
      widget.onPickupSelected(places[index]);
    }
  }
}

class _LocationByMap extends StatelessWidget {
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  final pickupFocus = FocusNode();
  final destFocus = FocusNode();

  final String pickupAddress;
  final LatLng pickupLocation;
  final String? destinationAddress;
  final LatLng? destinationLocation;
  final Callback onDestinationSelected;
  final Callback onPickupSelected;
  final Callback onContinue;
  final Callback onBack;
  final Callback onConfirmLocation;

  _LocationByMap({
    Key? key,
    required this.onBack,
    required this.pickupAddress,
    required this.pickupLocation,
    this.destinationAddress,
    this.destinationLocation,
    required this.onDestinationSelected,
    required this.onPickupSelected,
    required this.onContinue,
    required this.onConfirmLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    destinationController.text = destinationAddress ?? '';
    pickupController.text = pickupAddress;
    return Container(
      // color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Stack(
        children: [
          Positioned(
            // left: 0,
            // top: 0,
            child: _BackButton(onTap: onBack),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 120,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _addressTextFields(
                      controller: pickupController,
                      hint: 'Pickup',
                      onTap: () {
                        pickupFocus.unfocus();
                        onPickupSelected();
                      },
                      focus: pickupFocus),
                  VerticalAppSpacer(),
                  _addressTextFields(
                    controller: destinationController,
                    hint: 'Destination',
                    onTap: () {
                      destFocus.unfocus();
                      onDestinationSelected();
                    },
                    focus: destFocus,
                  ),
                ],
              ),
            ),
          ),
          Align(
            // left: 10,
            // bottom: 10,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppTextButton(
                      onPressed: onConfirmLocation,
                      text: 'Confirm Location',
                    ),
                    AppTextOutlinedButton(
                      onPressed: onContinue,
                      text: 'Continue',
                    ),
                  ],
                ),
                VerticalAppSpacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextField _addressTextFields({
    required TextEditingController controller,
    required String hint,
    required Callback onTap,
    required FocusNode focus,
  }) {
    return TextField(
      controller: controller,
      focusNode: focus,
      style: AppTextStyle.textField,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
      ),
      onTap: onTap,
    );
  }
}

class ChoseVehicle extends StatefulWidget {
  const ChoseVehicle(
      {Key? key, required this.onBack, required this.onVehicleSelected})
      : super(key: key);
  final Function onVehicleSelected;
  final Callback onBack;

  @override
  _ChoseVehicleState createState() => _ChoseVehicleState();
}

class _ChoseVehicleState extends State<ChoseVehicle> {
  ChoseVehicleState vehicleState = ChoseVehicleState.vehicleType;
  VehicleTypes? currentVehicleType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            child: _BackButton(onTap: widget.onBack),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (vehicleState == ChoseVehicleState.specificVehicle)
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                              onTap: () => this.setState(() {
                                this.vehicleState =
                                    ChoseVehicleState.vehicleType;
                              }),
                            ),
                          Expanded(
                            child: Center(
                              child: Text('Chose Vehicle',
                                  style: AppTextStyle.primaryHeading),
                            ),
                          ),
                        ],
                      ),
                      VerticalAppSpacer(space: 16),
                      if (vehicleState == ChoseVehicleState.vehicleType)
                        vehicleTypeWidget(),
                      if (vehicleState == ChoseVehicleState.specificVehicle &&
                          (currentVehicleType == VehicleTypes.bike))
                        onChoseBike(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onChoseBike() {
    return Column(
      children: [
        choseVehicleTile(
          title: 'Yamaha YBR',
          onTap: widget.onVehicleSelected,
          price: 180,
          vehicleSvg: "assets/svg/motor-sports.svg",
        ),
        VerticalAppSpacer(),
        choseVehicleTile(
          title: 'Honda Seventy',
          onTap: widget.onVehicleSelected,
          price: 120,
          vehicleSvg: "assets/svg/motor-sports.svg",
        ),
      ],
    );
  }

  vehicleTypeWidget() {
    return Column(
      children: [
        choseVehicleTypeTile(
            title: 'Rikshaws',
            description: 'New Rikshaws with comfortable seats',
            onTap: () {
              print('sdhjsd');
              this.setState(() {
                this.vehicleState = ChoseVehicleState.specificVehicle;
                currentVehicleType = VehicleTypes.rikshaw;
              });
            },
            vehicleSvg: "assets/svg/rickshaw.svg"),
        VerticalAppSpacer(),
        choseVehicleTypeTile(
          title: 'Bike',
          description: 'Affordable rides, All to yourself',
          onTap: () {
            this.setState(() {
              this.vehicleState = ChoseVehicleState.specificVehicle;
              currentVehicleType = VehicleTypes.bike;
            });
          },
          vehicleSvg: "assets/svg/motor-sports.svg",
        ),
      ],
    );
  }

  choseVehicleTile({title, onTap, price, vehicleSvg}) {
    return InkWell(
      key: UniqueKey(),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: double.infinity,
              padding: EdgeInsets.all(12.0),
              child: SvgPicture.asset(vehicleSvg, height: 32),
            ),
            VerticalDivider(width: 0.0),
            HorizontalAppSpacer(space: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.emphasisText,
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: double.infinity,
              child: Center(
                child: Text(
                  'Rs.$price',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  choseVehicleTypeTile({title, description, onTap, vehicleSvg}) {
    return InkWell(
      key: UniqueKey(),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: double.infinity,
              padding: EdgeInsets.all(12.0),
              // color: Colors.grey.shade400,
              child: SvgPicture.asset(
                vehicleSvg,
              ),
            ),
            VerticalDivider(width: 0.0),
            HorizontalAppSpacer(space: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyle.emphasisText),
                  Text(description, style: AppTextStyle.description),
                ],
              ),
            ),
            Container(
              width: 40,
              height: double.infinity,
              child: Icon(
                Icons.arrow_right,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingDone extends StatelessWidget {
  const _BookingDone({Key? key, required this.tripInfo, required this.onBack})
      : super(key: key);
  final Map<String, String> tripInfo;
  final Callback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            child: _BackButton(onTap: onBack),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(12.0),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        Text('Trip Detail', style: AppTextStyle.primaryHeading),
                  ),
                  VerticalAppSpacer(space: 16),
                  Row(
                    children: [
                      Text('Pickup: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['pickup'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Destination: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Text(tripInfo['destination'] as String,
                                style: AppTextStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Distance: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['distance'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Duration: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['duration'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  Expanded(child: Container()),
                  FullTextButton(onPressed: () {}, text: 'Book Now')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Steps
// 1 -> Idle
// 2 -> Chose Location
//    2.1 -> By Nearby Place(Place Name)
//    2.2 -> or By Using Map
// 3. Chose Vehicle