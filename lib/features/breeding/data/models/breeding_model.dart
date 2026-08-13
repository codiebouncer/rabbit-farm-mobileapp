import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'breeding_model.g.dart';

@JsonSerializable()
class BreedingModel extends Equatable {
  final String breedingId;

  final String doeRabbitId;

  final String buckRabbitId;

  final String buckBreed;
  final String doeBreed;
  final String? notes;
  final String status;

  final DateTime crossingDate;

  final DateTime expectedBirthDate;

  final DateTime? actualBirthDate;
  final DateTime? weaningDate;
  final DateTime? separationDate;

  final int? kitsBorn;

  final int? activeBorn;

  final int deaths;
  final int? maleBorn;
  final int? femaleBorn;

  const BreedingModel({
    required this.breedingId,
    required this.doeRabbitId,
    required this.buckRabbitId,
    required this.crossingDate,
    required this.expectedBirthDate,
    this.actualBirthDate,
    this.kitsBorn,
    this.activeBorn,
    required this.status,
    this.weaningDate,
    this.separationDate,
    this.notes,
    required this.buckBreed,
    required this.doeBreed,
    required this.deaths,
    this.maleBorn,
    this.femaleBorn,
  });

  factory BreedingModel.fromJson(Map<String, dynamic> json) =>
      _$BreedingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedingModelToJson(this);

  @override
  List<Object?> get props => [
    breedingId,
    doeRabbitId,
    buckRabbitId,
    crossingDate,
    expectedBirthDate,
    actualBirthDate,
    kitsBorn,
    activeBorn,
    status,
    buckBreed,
    doeBreed,
    weaningDate,
    separationDate,
    deaths,
    notes,
  ];
}
