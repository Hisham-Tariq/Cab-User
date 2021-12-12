// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BookedTripModel _$$_BookedTripModelFromJson(Map<String, dynamic> json) =>
    _$_BookedTripModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String,
      userDestinationLocation: const LatLngJsonConverter()
          .fromJson(json['userDestinationLocation'] as Map<String, dynamic>),
      destinationAddress: json['destinationAddress'] as String,
      userPickupLocation: const LatLngJsonConverter()
          .fromJson(json['userPickupLocation'] as Map<String, dynamic>),
      pickupAddress: json['pickupAddress'] as String,
      riderId: json['riderId'] as String,
      riderName: json['riderName'] as String,
      riderPhone: json['riderPhone'] as String,
      tripPrice: json['tripPrice'] as int,
      tripDistance: (json['tripDistance'] as num).toDouble(),
      vehicleType: json['vehicleType'] as String,
      bookedAt: json['bookedAt'] as String,
      tripStatus: json['tripStatus'] as String? ?? 'pending',
      completedAt: json['completedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$_BookedTripModelToJson(_$_BookedTripModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'userDestinationLocation':
          const LatLngJsonConverter().toJson(instance.userDestinationLocation),
      'destinationAddress': instance.destinationAddress,
      'userPickupLocation':
          const LatLngJsonConverter().toJson(instance.userPickupLocation),
      'pickupAddress': instance.pickupAddress,
      'riderId': instance.riderId,
      'riderName': instance.riderName,
      'riderPhone': instance.riderPhone,
      'tripPrice': instance.tripPrice,
      'tripDistance': instance.tripDistance,
      'vehicleType': instance.vehicleType,
      'bookedAt': instance.bookedAt,
      'tripStatus': instance.tripStatus,
      'completedAt': instance.completedAt,
      'createdAt': instance.createdAt,
    };
