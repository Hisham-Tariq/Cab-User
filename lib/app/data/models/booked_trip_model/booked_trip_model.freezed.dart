// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'booked_trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BookedTripModel _$BookedTripModelFromJson(Map<String, dynamic> json) {
  return _BookedTripModel.fromJson(json);
}

/// @nodoc
class _$BookedTripModelTearOff {
  const _$BookedTripModelTearOff();

  _BookedTripModel call(
      {required String id,
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
      String tripStatus = "pending",
      String? completedAt,
      String? createdAt}) {
    return _BookedTripModel(
      id: id,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      userDestinationLocation: userDestinationLocation,
      destinationAddress: destinationAddress,
      userPickupLocation: userPickupLocation,
      pickupAddress: pickupAddress,
      riderId: riderId,
      riderName: riderName,
      riderPhone: riderPhone,
      tripPrice: tripPrice,
      tripDistance: tripDistance,
      vehicleType: vehicleType,
      bookedAt: bookedAt,
      tripStatus: tripStatus,
      completedAt: completedAt,
      createdAt: createdAt,
    );
  }

  BookedTripModel fromJson(Map<String, Object?> json) {
    return BookedTripModel.fromJson(json);
  }
}

/// @nodoc
const $BookedTripModel = _$BookedTripModelTearOff();

/// @nodoc
mixin _$BookedTripModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userPhone => throw _privateConstructorUsedError;
  @LatLngJsonConverter()
  LatLng get userDestinationLocation => throw _privateConstructorUsedError;
  String get destinationAddress => throw _privateConstructorUsedError;
  @LatLngJsonConverter()
  LatLng get userPickupLocation => throw _privateConstructorUsedError;
  String get pickupAddress => throw _privateConstructorUsedError;
  String get riderId => throw _privateConstructorUsedError;
  String get riderName => throw _privateConstructorUsedError;
  String get riderPhone => throw _privateConstructorUsedError;
  int get tripPrice => throw _privateConstructorUsedError;
  double get tripDistance => throw _privateConstructorUsedError;
  String get vehicleType => throw _privateConstructorUsedError;
  String get bookedAt => throw _privateConstructorUsedError;
  String get tripStatus => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookedTripModelCopyWith<BookedTripModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookedTripModelCopyWith<$Res> {
  factory $BookedTripModelCopyWith(
          BookedTripModel value, $Res Function(BookedTripModel) then) =
      _$BookedTripModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String userId,
      String userName,
      String userPhone,
      @LatLngJsonConverter() LatLng userDestinationLocation,
      String destinationAddress,
      @LatLngJsonConverter() LatLng userPickupLocation,
      String pickupAddress,
      String riderId,
      String riderName,
      String riderPhone,
      int tripPrice,
      double tripDistance,
      String vehicleType,
      String bookedAt,
      String tripStatus,
      String? completedAt,
      String? createdAt});
}

/// @nodoc
class _$BookedTripModelCopyWithImpl<$Res>
    implements $BookedTripModelCopyWith<$Res> {
  _$BookedTripModelCopyWithImpl(this._value, this._then);

  final BookedTripModel _value;
  // ignore: unused_field
  final $Res Function(BookedTripModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userPhone = freezed,
    Object? userDestinationLocation = freezed,
    Object? destinationAddress = freezed,
    Object? userPickupLocation = freezed,
    Object? pickupAddress = freezed,
    Object? riderId = freezed,
    Object? riderName = freezed,
    Object? riderPhone = freezed,
    Object? tripPrice = freezed,
    Object? tripDistance = freezed,
    Object? vehicleType = freezed,
    Object? bookedAt = freezed,
    Object? tripStatus = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: userPhone == freezed
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      userDestinationLocation: userDestinationLocation == freezed
          ? _value.userDestinationLocation
          : userDestinationLocation // ignore: cast_nullable_to_non_nullable
              as LatLng,
      destinationAddress: destinationAddress == freezed
          ? _value.destinationAddress
          : destinationAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userPickupLocation: userPickupLocation == freezed
          ? _value.userPickupLocation
          : userPickupLocation // ignore: cast_nullable_to_non_nullable
              as LatLng,
      pickupAddress: pickupAddress == freezed
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as String,
      riderId: riderId == freezed
          ? _value.riderId
          : riderId // ignore: cast_nullable_to_non_nullable
              as String,
      riderName: riderName == freezed
          ? _value.riderName
          : riderName // ignore: cast_nullable_to_non_nullable
              as String,
      riderPhone: riderPhone == freezed
          ? _value.riderPhone
          : riderPhone // ignore: cast_nullable_to_non_nullable
              as String,
      tripPrice: tripPrice == freezed
          ? _value.tripPrice
          : tripPrice // ignore: cast_nullable_to_non_nullable
              as int,
      tripDistance: tripDistance == freezed
          ? _value.tripDistance
          : tripDistance // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleType: vehicleType == freezed
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: bookedAt == freezed
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as String,
      tripStatus: tripStatus == freezed
          ? _value.tripStatus
          : tripStatus // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: completedAt == freezed
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$BookedTripModelCopyWith<$Res>
    implements $BookedTripModelCopyWith<$Res> {
  factory _$BookedTripModelCopyWith(
          _BookedTripModel value, $Res Function(_BookedTripModel) then) =
      __$BookedTripModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String userId,
      String userName,
      String userPhone,
      @LatLngJsonConverter() LatLng userDestinationLocation,
      String destinationAddress,
      @LatLngJsonConverter() LatLng userPickupLocation,
      String pickupAddress,
      String riderId,
      String riderName,
      String riderPhone,
      int tripPrice,
      double tripDistance,
      String vehicleType,
      String bookedAt,
      String tripStatus,
      String? completedAt,
      String? createdAt});
}

/// @nodoc
class __$BookedTripModelCopyWithImpl<$Res>
    extends _$BookedTripModelCopyWithImpl<$Res>
    implements _$BookedTripModelCopyWith<$Res> {
  __$BookedTripModelCopyWithImpl(
      _BookedTripModel _value, $Res Function(_BookedTripModel) _then)
      : super(_value, (v) => _then(v as _BookedTripModel));

  @override
  _BookedTripModel get _value => super._value as _BookedTripModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userPhone = freezed,
    Object? userDestinationLocation = freezed,
    Object? destinationAddress = freezed,
    Object? userPickupLocation = freezed,
    Object? pickupAddress = freezed,
    Object? riderId = freezed,
    Object? riderName = freezed,
    Object? riderPhone = freezed,
    Object? tripPrice = freezed,
    Object? tripDistance = freezed,
    Object? vehicleType = freezed,
    Object? bookedAt = freezed,
    Object? tripStatus = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_BookedTripModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: userPhone == freezed
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      userDestinationLocation: userDestinationLocation == freezed
          ? _value.userDestinationLocation
          : userDestinationLocation // ignore: cast_nullable_to_non_nullable
              as LatLng,
      destinationAddress: destinationAddress == freezed
          ? _value.destinationAddress
          : destinationAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userPickupLocation: userPickupLocation == freezed
          ? _value.userPickupLocation
          : userPickupLocation // ignore: cast_nullable_to_non_nullable
              as LatLng,
      pickupAddress: pickupAddress == freezed
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as String,
      riderId: riderId == freezed
          ? _value.riderId
          : riderId // ignore: cast_nullable_to_non_nullable
              as String,
      riderName: riderName == freezed
          ? _value.riderName
          : riderName // ignore: cast_nullable_to_non_nullable
              as String,
      riderPhone: riderPhone == freezed
          ? _value.riderPhone
          : riderPhone // ignore: cast_nullable_to_non_nullable
              as String,
      tripPrice: tripPrice == freezed
          ? _value.tripPrice
          : tripPrice // ignore: cast_nullable_to_non_nullable
              as int,
      tripDistance: tripDistance == freezed
          ? _value.tripDistance
          : tripDistance // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleType: vehicleType == freezed
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: bookedAt == freezed
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as String,
      tripStatus: tripStatus == freezed
          ? _value.tripStatus
          : tripStatus // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: completedAt == freezed
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BookedTripModel extends _BookedTripModel {
  const _$_BookedTripModel(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userPhone,
      @LatLngJsonConverter() required this.userDestinationLocation,
      required this.destinationAddress,
      @LatLngJsonConverter() required this.userPickupLocation,
      required this.pickupAddress,
      required this.riderId,
      required this.riderName,
      required this.riderPhone,
      required this.tripPrice,
      required this.tripDistance,
      required this.vehicleType,
      required this.bookedAt,
      this.tripStatus = "pending",
      this.completedAt,
      this.createdAt})
      : super._();

  factory _$_BookedTripModel.fromJson(Map<String, dynamic> json) =>
      _$$_BookedTripModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userPhone;
  @override
  @LatLngJsonConverter()
  final LatLng userDestinationLocation;
  @override
  final String destinationAddress;
  @override
  @LatLngJsonConverter()
  final LatLng userPickupLocation;
  @override
  final String pickupAddress;
  @override
  final String riderId;
  @override
  final String riderName;
  @override
  final String riderPhone;
  @override
  final int tripPrice;
  @override
  final double tripDistance;
  @override
  final String vehicleType;
  @override
  final String bookedAt;
  @JsonKey(defaultValue: "pending")
  @override
  final String tripStatus;
  @override
  final String? completedAt;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'BookedTripModel(id: $id, userId: $userId, userName: $userName, userPhone: $userPhone, userDestinationLocation: $userDestinationLocation, destinationAddress: $destinationAddress, userPickupLocation: $userPickupLocation, pickupAddress: $pickupAddress, riderId: $riderId, riderName: $riderName, riderPhone: $riderPhone, tripPrice: $tripPrice, tripDistance: $tripDistance, vehicleType: $vehicleType, bookedAt: $bookedAt, tripStatus: $tripStatus, completedAt: $completedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookedTripModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.userName, userName) &&
            const DeepCollectionEquality().equals(other.userPhone, userPhone) &&
            const DeepCollectionEquality().equals(
                other.userDestinationLocation, userDestinationLocation) &&
            const DeepCollectionEquality()
                .equals(other.destinationAddress, destinationAddress) &&
            const DeepCollectionEquality()
                .equals(other.userPickupLocation, userPickupLocation) &&
            const DeepCollectionEquality()
                .equals(other.pickupAddress, pickupAddress) &&
            const DeepCollectionEquality().equals(other.riderId, riderId) &&
            const DeepCollectionEquality().equals(other.riderName, riderName) &&
            const DeepCollectionEquality()
                .equals(other.riderPhone, riderPhone) &&
            const DeepCollectionEquality().equals(other.tripPrice, tripPrice) &&
            const DeepCollectionEquality()
                .equals(other.tripDistance, tripDistance) &&
            const DeepCollectionEquality()
                .equals(other.vehicleType, vehicleType) &&
            const DeepCollectionEquality().equals(other.bookedAt, bookedAt) &&
            const DeepCollectionEquality()
                .equals(other.tripStatus, tripStatus) &&
            const DeepCollectionEquality()
                .equals(other.completedAt, completedAt) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(userName),
      const DeepCollectionEquality().hash(userPhone),
      const DeepCollectionEquality().hash(userDestinationLocation),
      const DeepCollectionEquality().hash(destinationAddress),
      const DeepCollectionEquality().hash(userPickupLocation),
      const DeepCollectionEquality().hash(pickupAddress),
      const DeepCollectionEquality().hash(riderId),
      const DeepCollectionEquality().hash(riderName),
      const DeepCollectionEquality().hash(riderPhone),
      const DeepCollectionEquality().hash(tripPrice),
      const DeepCollectionEquality().hash(tripDistance),
      const DeepCollectionEquality().hash(vehicleType),
      const DeepCollectionEquality().hash(bookedAt),
      const DeepCollectionEquality().hash(tripStatus),
      const DeepCollectionEquality().hash(completedAt),
      const DeepCollectionEquality().hash(createdAt));

  @JsonKey(ignore: true)
  @override
  _$BookedTripModelCopyWith<_BookedTripModel> get copyWith =>
      __$BookedTripModelCopyWithImpl<_BookedTripModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookedTripModelToJson(this);
  }
}

abstract class _BookedTripModel extends BookedTripModel {
  const factory _BookedTripModel(
      {required String id,
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
      String tripStatus,
      String? completedAt,
      String? createdAt}) = _$_BookedTripModel;
  const _BookedTripModel._() : super._();

  factory _BookedTripModel.fromJson(Map<String, dynamic> json) =
      _$_BookedTripModel.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userPhone;
  @override
  @LatLngJsonConverter()
  LatLng get userDestinationLocation;
  @override
  String get destinationAddress;
  @override
  @LatLngJsonConverter()
  LatLng get userPickupLocation;
  @override
  String get pickupAddress;
  @override
  String get riderId;
  @override
  String get riderName;
  @override
  String get riderPhone;
  @override
  int get tripPrice;
  @override
  double get tripDistance;
  @override
  String get vehicleType;
  @override
  String get bookedAt;
  @override
  String get tripStatus;
  @override
  String? get completedAt;
  @override
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$BookedTripModelCopyWith<_BookedTripModel> get copyWith =>
      throw _privateConstructorUsedError;
}
