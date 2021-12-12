import 'package:geocoding/geocoding.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//////// Booking Steps    ////////
/// 0. Idle
/// 1. Select Pickup Location
/// 2. Select Destination Location
/// 3. Select Vehicle
/// 4. Finding Rider
/// 5. Done

class TripLocationModel {
  String title;
  double latitude;
  double longitude;
  bool needAddress;
  String? address;
  double markerHue;

  TripLocationModel(this.title, this.latitude, this.longitude, this.markerHue, {this.needAddress = true}) {
    if (needAddress) {
      _setAddress();
    }
  }

  LatLng get latlng => LatLng(latitude, longitude);

  Marker get marker => Marker(
        markerId: MarkerId(title),
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
        position: latlng,
      );

  updateLatLng(LatLng location) {
    latitude = location.latitude;
    longitude = location.longitude;
    if (needAddress) {
      _setAddress();
    }
  }

  _setAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = p[0];
      address = "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      "Error: $e".printInfo();
    }
  }
}
