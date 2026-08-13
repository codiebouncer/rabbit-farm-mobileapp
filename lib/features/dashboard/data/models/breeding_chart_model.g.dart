// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeding_chart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedingChartModel _$BreedingChartModelFromJson(Map<String, dynamic> json) =>
    BreedingChartModel(
      month: json['month'] as String,
      successfulBreedings: (json['successfulBreedings'] as num).toInt(),
      failedBreedings: (json['failedBreedings'] as num).toInt(),
    );

Map<String, dynamic> _$BreedingChartModelToJson(BreedingChartModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'successfulBreedings': instance.successfulBreedings,
      'failedBreedings': instance.failedBreedings,
    };
