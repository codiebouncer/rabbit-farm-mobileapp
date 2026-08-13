import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cage_utilization_model.g.dart';

@JsonSerializable()
class CageUtilizationModel extends Equatable {
  final String cage;
  final int occupied;
  final int capacity;

  const CageUtilizationModel({
    required this.cage,
    required this.occupied,
    required this.capacity,
  });

  factory CageUtilizationModel.fromJson(Map<String, dynamic> json) =>
      _$CageUtilizationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CageUtilizationModelToJson(this);

  @override
  List<Object?> get props => [cage, occupied, capacity];
}
