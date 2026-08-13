import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'revenue_chart_model.g.dart';

@JsonSerializable()
class RevenueChartModel extends Equatable {
  final String month;
  final double revenue;

  const RevenueChartModel({required this.month, required this.revenue});

  factory RevenueChartModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueChartModelToJson(this);

  @override
  List<Object?> get props => [month, revenue];
}
