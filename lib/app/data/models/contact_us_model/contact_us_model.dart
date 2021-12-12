
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../helpers/model_helpers.dart';

part 'contact_us_model.freezed.dart';
part 'contact_us_model.g.dart';

@freezed
abstract class ContactUsModel implements _$ContactUsModel {
  const ContactUsModel._();

  const factory ContactUsModel({
    String? id,
    required String userId,
    required String name,
    required String phoneNumber,
    @Default(false) bool reviewed,
    String? createdAt,
    String? updatedAt,
  }) = _ContactUsModel;

  factory ContactUsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactUsModelFromJson(json);

  // factory ContactUsModel.empty() => ContactUsModel(id: '');

  factory ContactUsModel.fromDocument(DocumentSnapshot doc) =>
      ContactUsModel.fromJson(ModelHelpers().fromDocument(doc.data()!))
          .copyWith(id: doc.id);

  Map<String, dynamic> toDocument() => ModelHelpers().toDocument(toJson());
}
    