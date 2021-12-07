import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookedTripModel {
  late String? id;
  late String userId;
  late String userName;
  late String userPhone;
  late Timestamp? bookedAt;
  late LatLng userPickupLocation;
  late LatLng userDestinationLocation;
  late String riderId;
  late String riderName;
  late String riderPhone;
  late int tripPrice;
  late double tripDistance;
  late String vehicleType;
  late String tripStatus;

  BookedTripModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userPickupLocation,
    required this.userDestinationLocation,
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.tripPrice,
    required this.tripDistance,
    required this.vehicleType,
    this.bookedAt,
  });

  BookedTripModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    userId = json['userId'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    userPickupLocation = _mapToLatLng(json['userPickupLocation']);
    userDestinationLocation =
        _mapToLatLng(json['userDestinationLocation']);
    riderId = json['riderId'];
    riderName = json['riderName'];
    riderPhone = json['riderPhone'];
    tripPrice = json['tripPrice'];
    tripDistance = json['tripDistance'];
    vehicleType = json['vehicleType'];
    bookedAt = json['bookedAt'];
  }

  Map<String, double> _latLngToMap(LatLng loc) {
    return {
      'lat': loc.latitude,
      'lng': loc.longitude,
    };
  }

  LatLng _mapToLatLng(Map<String, double> loc) {
    return LatLng(loc['lat']!, loc['lng']!);
  }

  Map<String, dynamic> toCreateJson() => {
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'userPickupLocation': _latLngToMap(userPickupLocation),
        'userDestinationLocation': _latLngToMap(userDestinationLocation),
        'riderId': riderId,
        'riderName': riderName,
        'riderPhone': riderPhone,
        'tripPrice': tripPrice,
        'tripDistance': tripDistance,
        'vehicleType': vehicleType,
        'bookedAt': FieldValue.serverTimestamp(),
        'tripStatus': 'pending',
      };
  Map<String, dynamic> toJson() =>
      {'id': id, 'userLocation': userPickupLocation};
}
