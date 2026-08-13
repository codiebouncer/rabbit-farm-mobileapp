import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mortality_chart_model.g.dart';

@JsonSerializable()
class MortalityChartModel extends Equatable {
  final String month;
  final int deaths;

  const MortalityChartModel({required this.month, required this.deaths});

  factory MortalityChartModel.fromJson(Map<String, dynamic> json) =>
      _$MortalityChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$MortalityChartModelToJson(this);

  @override
  List<Object?> get props => [month, deaths];
}
