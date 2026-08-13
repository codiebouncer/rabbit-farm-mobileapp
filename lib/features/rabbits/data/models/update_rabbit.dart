class UpdateRabbitRequest {
  final String gender;
  final int? breedId;
  final String? dateOfBirth;
  final int? supplierId;
  final String? cageId;
  final String status;
  final String? stage;
  final String? colorMarkings;
  final String? notes;
  final String? motherRabbitId;
  final String? fatherRabbitId;

  const UpdateRabbitRequest({
    required this.gender,
    this.breedId,
    this.dateOfBirth,
    this.supplierId,
    this.cageId,
    required this.status,
    this.stage,
    this.colorMarkings,
    this.notes,
    this.motherRabbitId,
    this.fatherRabbitId,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'breedId': breedId,
      'dateOfBirth': dateOfBirth,
      'supplierId': supplierId,
      'cageId': cageId,
      'status': status,
      'stage': stage,
      'colorMarkings': colorMarkings,
      'notes': notes,
      'motherRabbitId': motherRabbitId,
      'fatherRabbitId': fatherRabbitId,
    };
  }
}
