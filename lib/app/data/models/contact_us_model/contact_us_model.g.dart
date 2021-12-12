// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_us_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContactUsModel _$$_ContactUsModelFromJson(Map<String, dynamic> json) =>
    _$_ContactUsModel(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      reviewed: json['reviewed'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$_ContactUsModelToJson(_$_ContactUsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'reviewed': instance.reviewed,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
