// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'contact_us_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContactUsModel _$ContactUsModelFromJson(Map<String, dynamic> json) {
  return _ContactUsModel.fromJson(json);
}

/// @nodoc
class _$ContactUsModelTearOff {
  const _$ContactUsModelTearOff();

  _ContactUsModel call(
      {String? id,
      required String userId,
      required String name,
      required String phoneNumber,
      bool reviewed = false,
      String? createdAt,
      String? updatedAt}) {
    return _ContactUsModel(
      id: id,
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      reviewed: reviewed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ContactUsModel fromJson(Map<String, Object?> json) {
    return ContactUsModel.fromJson(json);
  }
}

/// @nodoc
const $ContactUsModel = _$ContactUsModelTearOff();

/// @nodoc
mixin _$ContactUsModel {
  String? get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  bool get reviewed => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactUsModelCopyWith<ContactUsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactUsModelCopyWith<$Res> {
  factory $ContactUsModelCopyWith(
          ContactUsModel value, $Res Function(ContactUsModel) then) =
      _$ContactUsModelCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String userId,
      String name,
      String phoneNumber,
      bool reviewed,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$ContactUsModelCopyWithImpl<$Res>
    implements $ContactUsModelCopyWith<$Res> {
  _$ContactUsModelCopyWithImpl(this._value, this._then);

  final ContactUsModel _value;
  // ignore: unused_field
  final $Res Function(ContactUsModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? reviewed = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: phoneNumber == freezed
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      reviewed: reviewed == freezed
          ? _value.reviewed
          : reviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ContactUsModelCopyWith<$Res>
    implements $ContactUsModelCopyWith<$Res> {
  factory _$ContactUsModelCopyWith(
          _ContactUsModel value, $Res Function(_ContactUsModel) then) =
      __$ContactUsModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String userId,
      String name,
      String phoneNumber,
      bool reviewed,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$ContactUsModelCopyWithImpl<$Res>
    extends _$ContactUsModelCopyWithImpl<$Res>
    implements _$ContactUsModelCopyWith<$Res> {
  __$ContactUsModelCopyWithImpl(
      _ContactUsModel _value, $Res Function(_ContactUsModel) _then)
      : super(_value, (v) => _then(v as _ContactUsModel));

  @override
  _ContactUsModel get _value => super._value as _ContactUsModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? reviewed = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_ContactUsModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: phoneNumber == freezed
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      reviewed: reviewed == freezed
          ? _value.reviewed
          : reviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ContactUsModel extends _ContactUsModel {
  const _$_ContactUsModel(
      {this.id,
      required this.userId,
      required this.name,
      required this.phoneNumber,
      this.reviewed = false,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$_ContactUsModel.fromJson(Map<String, dynamic> json) =>
      _$$_ContactUsModelFromJson(json);

  @override
  final String? id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String phoneNumber;
  @JsonKey(defaultValue: false)
  @override
  final bool reviewed;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'ContactUsModel(id: $id, userId: $userId, name: $name, phoneNumber: $phoneNumber, reviewed: $reviewed, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactUsModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.phoneNumber, phoneNumber) &&
            const DeepCollectionEquality().equals(other.reviewed, reviewed) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(phoneNumber),
      const DeepCollectionEquality().hash(reviewed),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$ContactUsModelCopyWith<_ContactUsModel> get copyWith =>
      __$ContactUsModelCopyWithImpl<_ContactUsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContactUsModelToJson(this);
  }
}

abstract class _ContactUsModel extends ContactUsModel {
  const factory _ContactUsModel(
      {String? id,
      required String userId,
      required String name,
      required String phoneNumber,
      bool reviewed,
      String? createdAt,
      String? updatedAt}) = _$_ContactUsModel;
  const _ContactUsModel._() : super._();

  factory _ContactUsModel.fromJson(Map<String, dynamic> json) =
      _$_ContactUsModel.fromJson;

  @override
  String? get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get phoneNumber;
  @override
  bool get reviewed;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$ContactUsModelCopyWith<_ContactUsModel> get copyWith =>
      throw _privateConstructorUsedError;
}
