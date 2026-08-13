// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortality_chart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MortalityChartModel _$MortalityChartModelFromJson(Map<String, dynamic> json) =>
    MortalityChartModel(
      month: json['month'] as String,
      deaths: (json['deaths'] as num).toInt(),
    );

Map<String, dynamic> _$MortalityChartModelToJson(
  MortalityChartModel instance,
) => <String, dynamic>{'month': instance.month, 'deaths': instance.deaths};
