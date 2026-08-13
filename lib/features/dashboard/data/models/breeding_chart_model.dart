import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'breeding_chart_model.g.dart';

@JsonSerializable()
class BreedingChartModel extends Equatable {
  final String month;
  final int successfulBreedings;
  final int failedBreedings;

  const BreedingChartModel({
    required this.month,
    required this.successfulBreedings,
    required this.failedBreedings,
  });

  factory BreedingChartModel.fromJson(Map<String, dynamic> json) =>
      _$BreedingChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedingChartModelToJson(this);

  @override
  List<Object?> get props => [month, successfulBreedings, failedBreedings];
}
