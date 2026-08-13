import 'package:equatable/equatable.dart';

class RabbitModel extends Equatable {
  final String rabbitId;
  final String gender;
  final String status;
  final String? breed;
  final String? cage;
  final String? dateOfBirth;
  final String? colorMarkings;
  final String? stage;

  const RabbitModel({
    required this.rabbitId,
    required this.gender,
    required this.status,
    this.breed,
    this.cage,
    this.dateOfBirth,
    this.colorMarkings,
    this.stage,
  });

  factory RabbitModel.fromJson(Map<String, dynamic> json) {
    final rabbitId = json['rabbitId'];
    final gender = json['gender'];
    final status = json['status'];
    if (rabbitId is! String || gender is! String || status is! String) {
      throw const FormatException('Invalid rabbit record');
    }
    return RabbitModel(
      rabbitId: rabbitId,
      gender: gender,
      status: status,
      breed: json['breed'] as String?,
      cage: json['cage'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      colorMarkings: json['colorMarkings'] as String?,
      stage: json['stage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    rabbitId,
    gender,
    status,
    breed,
    cage,
    dateOfBirth,
    colorMarkings,
    stage,
  ];
}
