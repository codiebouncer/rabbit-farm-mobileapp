// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_birth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordBirthRequest _$RecordBirthRequestFromJson(Map<String, dynamic> json) =>
    RecordBirthRequest(
      actualBirthDate: DateTime.parse(json['actualBirthDate'] as String),
      kitsBorn: (json['kitsBorn'] as num).toInt(),
      activeBorn: (json['activeBorn'] as num).toInt(),
      maleKits: (json['maleKits'] as num).toInt(),
      femaleKits: (json['femaleKits'] as num).toInt(),
    );

Map<String, dynamic> _$RecordBirthRequestToJson(RecordBirthRequest instance) =>
    <String, dynamic>{
      'actualBirthDate': instance.actualBirthDate.toIso8601String(),
      'kitsBorn': instance.kitsBorn,
      'activeBorn': instance.activeBorn,
      'maleKits': instance.maleKits,
      'femaleKits': instance.femaleKits,
    };
