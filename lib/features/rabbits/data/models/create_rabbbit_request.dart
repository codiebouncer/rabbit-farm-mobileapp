class CreateRabbitRequest {
  final String gender;
  final int? breedId;
  final String? dateOfBirth;
  final int? supplierId;
  final String? cageId;
  final String status;
  final String? motherRabbitId;
  final String? fatherRabbitId;
  final String stage;
  final String? colorMarkings;
  final String? notes;

  const CreateRabbitRequest({
    required this.gender,
    required this.breedId,
    required this.dateOfBirth,
    required this.supplierId,
    required this.cageId,
    required this.status,
    required this.motherRabbitId,
    required this.fatherRabbitId,
    required this.stage,
    this.colorMarkings,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'breedId': breedId,
      'dateOfBirth': dateOfBirth,
      'supplierId': supplierId,
      'cageId': cageId,
      'status': status,
      'motherRabbitId': motherRabbitId,
      'fatherRabbitId': fatherRabbitId,
      'stage': stage,
      'colorMarkings': colorMarkings,
      'notes': notes,
    };
  }
}
