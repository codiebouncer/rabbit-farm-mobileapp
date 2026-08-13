// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryModel(
  totalRabbits: (json['totalRabbits'] as num).toInt(),
  pregnantRabbits: (json['pregnantRabbits'] as num).toInt(),
  availableCages: (json['availableCages'] as num).toInt(),
  monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
  mortalityRate: (json['mortalityRate'] as num).toDouble(),
  breedingSuccessRate: (json['breedingSuccessRate'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  DashboardSummaryModel instance,
) => <String, dynamic>{
  'totalRabbits': instance.totalRabbits,
  'pregnantRabbits': instance.pregnantRabbits,
  'availableCages': instance.availableCages,
  'monthlyRevenue': instance.monthlyRevenue,
  'mortalityRate': instance.mortalityRate,
  'breedingSuccessRate': instance.breedingSuccessRate,
};
