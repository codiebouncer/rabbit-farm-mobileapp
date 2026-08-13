// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cage_utilization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CageUtilizationModel _$CageUtilizationModelFromJson(
  Map<String, dynamic> json,
) => CageUtilizationModel(
  cage: json['cage'] as String,
  occupied: (json['occupied'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
);

Map<String, dynamic> _$CageUtilizationModelToJson(
  CageUtilizationModel instance,
) => <String, dynamic>{
  'cage': instance.cage,
  'occupied': instance.occupied,
  'capacity': instance.capacity,
};
