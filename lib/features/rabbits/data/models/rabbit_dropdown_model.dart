import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rabbit_dropdown_model.g.dart';

@JsonSerializable()
class RabbitDropdownModel extends Equatable {
  final String rabbitId;

  const RabbitDropdownModel({required this.rabbitId});

  factory RabbitDropdownModel.fromJson(Map<String, dynamic> json) =>
      _$RabbitDropdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$RabbitDropdownModelToJson(this);

  @override
  List<Object?> get props => [rabbitId];
}
