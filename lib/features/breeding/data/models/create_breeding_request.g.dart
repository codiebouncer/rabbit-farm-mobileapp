// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_breeding_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBreedingRequest _$CreateBreedingRequestFromJson(
  Map<String, dynamic> json,
) => CreateBreedingRequest(
  breedingId: json['breedingId'] as String,
  doeRabbitId: json['doeRabbitId'] as String,
  buckRabbitId: json['buckRabbitId'] as String,
  crossingDate: json['crossingDate'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateBreedingRequestToJson(
  CreateBreedingRequest instance,
) => <String, dynamic>{
  'breedingId': instance.breedingId,
  'doeRabbitId': instance.doeRabbitId,
  'buckRabbitId': instance.buckRabbitId,
  'crossingDate': instance.crossingDate,
  'notes': instance.notes,
};
