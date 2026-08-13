// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_weaning_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordWeaningRequest _$RecordWeaningRequestFromJson(
  Map<String, dynamic> json,
) => RecordWeaningRequest(
  weaningDate: DateTime.parse(json['weaningDate'] as String),
);

Map<String, dynamic> _$RecordWeaningRequestToJson(
  RecordWeaningRequest instance,
) => <String, dynamic>{'weaningDate': instance.weaningDate.toIso8601String()};
