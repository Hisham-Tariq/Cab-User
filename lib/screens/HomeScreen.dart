import 'package:driving_app_its/controller/direction.controller.dart';
import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum BookingState { pickup, destination, rideSelection, review, done }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // static late final _initialPosition;
  BookingState currentBookingState = BookingState.pickup;
  late Map<BookingState, dynamic> bookingStateWidgets;

  Position? _currentPosition;
  String? _currentAddress;
  late LatLng _currentCameraCoordinates;
  Debouncer currentCameraPosDebouncer = Debouncer(miliseconds: 200);

  late GoogleMapController _googleMapController;
  Marker? _pickupMarker;
  String? _pickupAddress;
  Marker? _destinationMarker;
  String? _destinationAddress;
  Directions? _info;

  _HomeScreenState() {
    bookingStateWidgets = {
      BookingState.pickup: _pickupWidget,
      BookingState.destination: _destinationWidget,
    };
  }

  @override
  void initState() {
    // print(FirebaseAuth.instance.currentUser!.phoneNumber);
    // TODO: implement initState
    super.initState();
    _getCurrentPosition().then((value) {
      this.setState(() {
        this._currentPosition = value;
        _currentCameraCoordinates = LatLng(value.latitude, value.longitude);
        _getAddressFromLatLng(value.latitude, value.longitude).then((address) {
          this.setState(() {
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
                  Positioned(
                    child: Icon(
                      Icons.circle,
                      size: 12.0,
                      color: AppColors.primary,
                    ),
                  ),
                  if (_info != null)
                    Positioned(
                      top: 20.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        child: Text(
                          '${_info!.totalDistance}, ${_info!.totalDuration}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  ArrowIcons(
                                    icon: Icons.arrow_back,
                                    isActive: false,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'TOP',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ArrowIcons(
                                    icon: Icons.arrow_forward,
                                    isActive: false,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: AnimatedContainer(
                                // curve: Curves.easeInOutExpo,
                                duration: Duration(seconds: 2),
                                child:
                                    bookingStateWidgets[currentBookingState](),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  _pickupWidget() {
    if (_pickupAddress == null) return PickUpWidget(onNext: () {});
    var lat = _pickupMarker!.position.latitude;
    var long = _pickupMarker!.position.longitude;
    return FutureBuilder(
      future: _getAddressFromLatLng(lat, long),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return PickUpWidget(onNext: () {});
        } else {
          return PickUpWidget(
            onNext: () {},
            address: snapshot.data as String,
          );
        }
      },
    );
    // var address = await _getAddressFromLatLng(
    //   _pickupMarker!.position.latitude,
    //   _pickupMarker!.position.longitude,
    // ) as String;
    // return
  }

  _destinationWidget() {
    return DestinationWidget();
  }

  Future<String?> _getAddressFromLatLng(lat, long) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
        lat,
        long,
      );
      Placemark place = p[0];
      return "${place.locality}, ${place.postalCode}, ${place.country}";
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

class ArrowIcons extends StatelessWidget {
  ArrowIcons({Key? key, required this.icon, required this.isActive})
      : super(key: key);
  final IconData icon;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        icon,
        color: isActive ? Colors.green : Colors.grey.shade400,
      ),
      width: 40,
    );
  }
}

class PickUpWidget extends StatelessWidget {
  final Callback onNext;
  late TextEditingController pickupController;

  PickUpWidget({Key? key, required this.onNext, String address = ''})
      : super(key: key) {
    pickupController = TextEditingController(text: address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: pickupController,
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          VerticalAppSpacer(),
          FullTextButton(onPressed: onNext, text: 'Confirm Pickup')
        ],
      ),
    );
  }
}

class DestinationWidget extends StatelessWidget {
  const DestinationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      color: Colors.orange,
      child: Center(
        child: Text('Destination'),
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
