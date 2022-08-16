import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../helpers/model_helpers.dart';

part 'booked_trip_model.freezed.dart';
part 'booked_trip_model.g.dart';

@freezed
abstract class BookedTripModel implements _$BookedTripModel {
  const BookedTripModel._();

  const factory BookedTripModel({
    required String id,
    required String userId,
    required String userName,
    required String userPhone,
    @LatLngJsonConverter() required LatLng userDestinationLocation,
    required String destinationAddress,
    @LatLngJsonConverter() required LatLng userPickupLocation,
    required String pickupAddress,
    required String riderId,
    required String riderName,
    required String riderPhone,
    required int tripPrice,
    required double tripDistance,
    required String vehicleType,
    required String bookedAt,
    @Default("pending") String tripStatus,
    String? completedAt,
    String? createdAt,
  }) = _BookedTripModel;

  factory BookedTripModel.fromJson(Map<String, dynamic> json) => _$BookedTripModelFromJson(json);

  // factory BookedTripModel.empty() => BookedTripModel(id: '',);

  factory BookedTripModel.fromDocument(DocumentSnapshot doc) =>
      BookedTripModel.fromJson(ModelHelpers().fromDocument(doc.data()!)).copyWith(id: doc.id);

  Map<String, dynamic> toDocument() => ModelHelpers().toDocument(toJson());

  static String latLngToJson(LatLng? latLng) => jsonEncode(latLng != null ? {'latitude': latLng.latitude, 'longitude': latLng.longitude} : null);

  static LatLng? latLngFromJson(String jsonString) {
    final LinkedHashMap<String, dynamic>? jsonMap = jsonDecode(jsonString);

    return jsonMap != null ? LatLng(jsonMap['latitude'], jsonMap['longitude']) : null;
  }
}

class LatLngJsonConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngJsonConverter();
  @override
  LatLng fromJson(Map<String, dynamic> json) {
    if (json["lat"] is String) {
      return LatLng(double.parse(json["lat"]), double.parse(json["lng"]));
    }
    print(json["lat"].runtimeType);
    return LatLng(json["lat"]!, json["lng"]!);
  }

  @override
  Map<String, dynamic> toJson(LatLng object) {
    return {
      "lat": object.latitude,
      "lng": object.longitude,
    };
  }
}
