// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_breeding_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBreedingRequest _$UpdateBreedingRequestFromJson(
  Map<String, dynamic> json,
) => UpdateBreedingRequest(
  crossingDate: json['crossingDate'] as String,
  notes: json['notes'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$UpdateBreedingRequestToJson(
  UpdateBreedingRequest instance,
) => <String, dynamic>{
  'crossingDate': instance.crossingDate,
  'notes': instance.notes,
  'status': instance.status,
};
