// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_separation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSeparationRequest _$RecordSeparationRequestFromJson(
  Map<String, dynamic> json,
) => RecordSeparationRequest(
  separationDate: DateTime.parse(json['separationDate'] as String),
);

Map<String, dynamic> _$RecordSeparationRequestToJson(
  RecordSeparationRequest instance,
) => <String, dynamic>{
  'separationDate': instance.separationDate.toIso8601String(),
};
