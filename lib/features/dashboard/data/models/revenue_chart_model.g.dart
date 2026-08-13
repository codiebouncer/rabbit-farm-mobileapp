// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_chart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueChartModel _$RevenueChartModelFromJson(Map<String, dynamic> json) =>
    RevenueChartModel(
      month: json['month'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$RevenueChartModelToJson(RevenueChartModel instance) =>
    <String, dynamic>{'month': instance.month, 'revenue': instance.revenue};
