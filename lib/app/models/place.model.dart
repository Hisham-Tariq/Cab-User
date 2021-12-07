import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String name;
  final String address;
  final LatLng location;
  final LatLng norteast;
  final LatLng southwest;
  final String placeId;
  final List<dynamic> types;

  Place({
    required this.name,
    required this.address,
    required this.location,
    required this.norteast,
    required this.southwest,
    required this.placeId,
    required this.types,
  });
}
