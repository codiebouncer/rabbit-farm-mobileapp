// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedingModel _$BreedingModelFromJson(Map<String, dynamic> json) =>
    BreedingModel(
      breedingId: json['breedingId'] as String,
      doeRabbitId: json['doeRabbitId'] as String,
      buckRabbitId: json['buckRabbitId'] as String,
      crossingDate: DateTime.parse(json['crossingDate'] as String),
      expectedBirthDate: DateTime.parse(json['expectedBirthDate'] as String),
      actualBirthDate: json['actualBirthDate'] == null
          ? null
          : DateTime.parse(json['actualBirthDate'] as String),
      kitsBorn: (json['kitsBorn'] as num?)?.toInt(),
      activeBorn: (json['activeBorn'] as num?)?.toInt(),
      status: json['status'] as String,
      weaningDate: json['weaningDate'] == null
          ? null
          : DateTime.parse(json['weaningDate'] as String),
      separationDate: json['separationDate'] == null
          ? null
          : DateTime.parse(json['separationDate'] as String),
      notes: json['notes'] as String?,
      buckBreed: json['buckBreed'] as String,
      doeBreed: json['doeBreed'] as String,
      deaths: (json['deaths'] as num).toInt(),
      maleBorn: (json['maleBorn'] as num?)?.toInt(),
      femaleBorn: (json['femaleBorn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BreedingModelToJson(BreedingModel instance) =>
    <String, dynamic>{
      'breedingId': instance.breedingId,
      'doeRabbitId': instance.doeRabbitId,
      'buckRabbitId': instance.buckRabbitId,
      'buckBreed': instance.buckBreed,
      'doeBreed': instance.doeBreed,
      'notes': instance.notes,
      'status': instance.status,
      'crossingDate': instance.crossingDate.toIso8601String(),
      'expectedBirthDate': instance.expectedBirthDate.toIso8601String(),
      'actualBirthDate': instance.actualBirthDate?.toIso8601String(),
      'weaningDate': instance.weaningDate?.toIso8601String(),
      'separationDate': instance.separationDate?.toIso8601String(),
      'kitsBorn': instance.kitsBorn,
      'activeBorn': instance.activeBorn,
      'deaths': instance.deaths,
      'maleBorn': instance.maleBorn,
      'femaleBorn': instance.femaleBorn,
    };
