import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/controller/direction.controller.dart';
import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/models/place.model.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:timelines/timelines.dart';

enum BookingState { pickup, destination, rideSelection, review, done }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // static late final _initialPosition;
  BookingState currentBookingState = BookingState.pickup;

  Position? _currentPosition;
  String? _currentAddress;
  late LatLng _currentCameraCoordinates;
  Debouncer currentCameraPosDebouncer = Debouncer(miliseconds: 200);

  late GoogleMapController _googleMapController;
  Marker? _pickupMarker;
  String? _pickupAddress;
  LatLng? _pickupLocation;

  Marker? _destinationMarker;
  String? _destinationAddress;
  LatLng? _destinationLocation;
  Directions? _info;

  bool isScheduling = false;

  _HomeScreenState() {
    //  Constructor
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition().then((value) {
      this.setState(() {
        this._currentPosition = value;
        _currentCameraCoordinates = LatLng(value.latitude, value.longitude);
        print(value.latitude);
        print(value.longitude);
        _getAddressFromLatLng(value.latitude, value.longitude).then((address) {
          this.setState(() {
            print('Address: $address');
            _currentAddress = address;
            _pickupAddress = address;
          });
        });
      });
    });
    //TODO:  Fetch Current User Data
    //          OR
    //TODO:  Create a Current User Controller
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
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
                      if (_pickupMarker != null) _pickupMarker as Marker,
                      if (_destinationMarker != null)
                        _destinationMarker as Marker,
                    },
                    polylines: {
                      if (_info != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          points: _info!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    onCameraMove: (position) {
                      currentCameraPosDebouncer.run(() {
                        this.setState(() {
                          _currentCameraCoordinates = LatLng(
                            position.target.latitude,
                            position.target.longitude,
                          );
                          _addPickupMarker(_currentCameraCoordinates);
                        });
                      });
                    },
                    onCameraIdle: () {},
                    // onLongPress: _addMarker,
                  ),
                  // Middle Circle
                  Positioned(
                    child: Icon(
                      Icons.circle,
                      size: 12.0,
                      color: AppColors.primary,
                    ),
                  ),
                  // Bottom Container
                  // TODO: Add If to show at the start only
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
                              this.isScheduling = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  if (this.isScheduling)
                    Positioned(
                      child: _PickupAndDestinationLocationPicker(
                        currentAddress: this._currentAddress as String,
                        currentLocation: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        onClose: () {
                          this.setState(() {
                            this.isScheduling = false;
                          });
                        },
                        onDestinationSelected: (Place place) {
                          this._destinationLocation = place.location;
                          this._destinationAddress = place.address;
                          // this._destinationMarker
                        },
                        onPickupSelected: (Place place) {
                          this._destinationLocation = place.location;
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

  Future<String?> _getAddressFromLatLng(lat, long) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
        lat,
        long,
      );
      Placemark place = p[0];
      // print(place.toJson());
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
      //TODO: Show a Error to User that You must enable the Location Services
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
    this.setState(() {
      _pickupMarker = Marker(
        markerId: const MarkerId('pickup'),
        infoWindow: const InfoWindow(title: 'pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: pos,
      );
    });
  }

  void _addDestinationMarker(LatLng pos) async {
    this.setState(() {
      _pickupMarker = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: pos,
      );
    });
  }

  void _addMarker(LatLng pos) async {
    if (_pickupMarker == null ||
        (_pickupMarker != null && _destinationMarker != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _pickupMarker = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destinationMarker = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destinationMarker = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsController()
          .getDirections(origin: _pickupMarker!.position, destination: pos);
      setState(() => _info = directions);
    }
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
        Text(
          'Good Afternoon Test',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
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

class _PickupAndDestinationLocationPicker extends StatefulWidget {
  final String currentAddress;
  final LatLng currentLocation;
  final Callback onClose;
  final void Function(Place) onDestinationSelected;
  final void Function(Place) onPickupSelected;

  const _PickupAndDestinationLocationPicker({
    Key? key,
    required this.onClose,
    required this.onDestinationSelected,
    required this.onPickupSelected,
    this.currentAddress = '',
    required this.currentLocation,
  }) : super(key: key);

  @override
  __PickupAndDestinationLocationPickerState createState() =>
      __PickupAndDestinationLocationPickerState();
}

class __PickupAndDestinationLocationPickerState
    extends State<_PickupAndDestinationLocationPicker> {
  bool isDestinationSelected = false;
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final searchPlaceDebouncer = Debouncer(miliseconds: 300);
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    this.pickupController.text = widget.currentAddress;
  }

  __PickupAndDestinationLocationPickerState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onClose,
                child: Icon(Icons.clear_rounded),
              ),
            ],
          ),
          VerticalAppSpacer(space: 24.0),
          Row(
            children: [
              HorizontalAppSpacer(space: 50),
              Expanded(
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30.0),
                  ),
                  initialValue: 'Sun, 18-July at 12:44 PM',
                ),
              ),
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
                    TextField(
                      controller: pickupController,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      decoration: InputDecoration(
                          hintText: 'From?',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          )),
                      onTap: () {
                        if (this.isDestinationSelected)
                          this.setState(() {
                            this.isDestinationSelected = false;
                          });
                      },
                    ),
                    VerticalAppSpacer(),
                    TextField(
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              print('Hello');
                            },
                            child: Icon(
                              Icons.map,
                              color: AppColors.primary,
                            ),
                          ),
                          hintText: 'Where to?',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          )),
                      onTap: () {
                        if (!this.isDestinationSelected)
                          this.setState(() {
                            this.isDestinationSelected = true;
                          });
                      },
                      onChanged: (value) {
                        searchPlaceDebouncer.run(() {
                          var controller = PlaceController();
                          controller
                              .getNearbyPlaces(
                            userLocation: widget.currentLocation,
                            keyword: value,
                          )
                              .then((value) {
                            this.setState(() {
                              this.places = value;
                            });
                          });
                        });
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
                        onTap: () {
                          if (this.isDestinationSelected) {
                            destinationController.text = places[index].name;
                            widget.onDestinationSelected(places[index]);
                          } else {
                            pickupController.text = places[index].name;
                            widget.onPickupSelected(places[index]);
                          }
                        },
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
                          style: TextStyle(fontSize: 13.0),
                        ),
                        horizontalTitleGap: 1.0,
                        subtitle: Text(
                          places[index].address,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      Divider(
                        height: 0.5,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Fetch User's Current Location                            ✘
// TODO:        Show Error (Location Service Not Enabled)                ✘
// TODO:        Show Error (Location Permission Not given)               ✘
// TODO:        Learn Position Stream From GeoLocator Pub.dev            ✘
