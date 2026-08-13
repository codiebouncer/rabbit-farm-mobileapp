import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_model.g.dart';

@JsonSerializable()
class DashboardSummaryModel extends Equatable {
  final int totalRabbits;
  final int pregnantRabbits;
  final int availableCages;
  final double monthlyRevenue;
  final double mortalityRate;
  final double breedingSuccessRate;

  const DashboardSummaryModel({
    required this.totalRabbits,
    required this.pregnantRabbits,
    required this.availableCages,
    required this.monthlyRevenue,
    required this.mortalityRate,
    required this.breedingSuccessRate,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  @override
  List<Object?> get props => [
    totalRabbits,
    pregnantRabbits,
    availableCages,
    monthlyRevenue,
    mortalityRate,
    breedingSuccessRate,
  ];
}
