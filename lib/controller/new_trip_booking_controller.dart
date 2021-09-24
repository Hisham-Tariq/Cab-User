import '../models/models.dart';
import '../screens/Home/NewTripBooking/booking_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'direction.controller.dart';

// keep track of at what stage of the Trip is.

class NewTripBookingController extends GetxController {
  var currentBookingState = BookingState.idle;
  Position? _currentPosition;
  CameraPosition? initialCameraPosition;
  late GoogleMapController googleMapController;
  LatLng? currentCameraLatLng;
  LatLng? pickupLatLng;
  String? pickupAddress;
  LatLng? destinationLatLng;
  String? destinationAddress;

  Map<String, Marker?> markers = {};

  Directions? tripDirections;

  @override
  onInit() async {
    super.onInit();
    await updateCurrentPosition();
    currentCameraLatLng = pickupLatLng = currentLatLng;
    initialCameraPosition = CameraPosition(
      target: currentLatLng as LatLng,
      zoom: 11.5,
    );
    markers.addAll({
      'pickup': Marker(
        markerId: const MarkerId('pickup'),
        infoWindow: const InfoWindow(title: 'pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: currentLatLng as LatLng,
      ),
      'destination': null,
    });
    update();
  }

  changeBookingState(BookingState newState) {
    currentBookingState = newState;
    update();
  }

  updateCurrentPosition() async {
    _currentPosition = await Geolocator.getCurrentPosition();
  }

  LatLng? get currentLatLng {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
    return null;
  }

  Future<String?> getAddressFromLatLng(latlng) async {
    try {
      List<Placemark> p =
          await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
      Placemark place = p[0];
      print(place.toJson());
      return "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      print(e);
    }
  }

  updatePickupAddress() async =>
      pickupAddress = await getAddressFromLatLng(pickupLatLng);
  updateDestinationAddress() async =>
      destinationAddress = await getAddressFromLatLng(destinationLatLng);

  updatePickupMarker() {
    markers['pickup'] = Marker(
      markerId: const MarkerId('pickup'),
      infoWindow: const InfoWindow(title: 'pickup'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      position: pickupLatLng as LatLng,
    );
  }

  updateDestinationMarker() {
    markers['destination'] = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: destinationLatLng as LatLng,
    );
  }

  pickupLocationSelectedByPlace(Place place) {
    pickupLatLng = place.location;
    updatePickupAddress();
    updatePickupMarker();
    update();
  }

  destinationLocationSelectedByPlace(Place place) async {
    destinationLatLng = place.location;
    updateDestinationAddress();
    updateDestinationMarker();
    await _fetchTripDirection();
    update();
  }

  pickupLocationByMap() async {
    try {
      pickupLatLng = currentCameraLatLng;
      updatePickupAddress();
      await updatePickupMarker();
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  destinationLocationByMap() async {
    try {
      destinationLatLng = currentCameraLatLng;
      updateDestinationAddress();
      await updateDestinationMarker();
      await _fetchTripDirection();
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isPickupLocationIsValid() {
    if (pickupLatLng != null && pickupAddress!.isNotEmpty) return true;
    return false;
  }

  bool isDestinationLocationIsValid() {
    if (destinationLatLng != null && destinationAddress!.isNotEmpty)
      return true;
    return false;
  }

  _fetchTripDirection() async {
    final directions = await DirectionsController().getDirections(
      origin: markers['pickup']!.position,
      destination: markers['destination']!.position,
    );
    tripDirections = directions;
  }

  @override
  void onClose() {
    super.onClose();
    googleMapController.dispose();
  }
}
