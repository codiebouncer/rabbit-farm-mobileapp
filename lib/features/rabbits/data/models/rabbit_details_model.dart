import 'package:equatable/equatable.dart';

class RabbitDetailsModel extends Equatable {
  final String rabbitId;
  final String gender;
  final String status;
  final String? stage;
  final String? breedName;
  final int? breedId;
  final String? cageId;
  final int? capacity;
  final String? cageType;
  final String? dateOfBirth;
  final DateTime createdAt;
  final String? colorMarkings;
  final int? supplierId;
  final String? supplierName;
  final String? motherRabbitId;
  final String? fatherRabbitId;
  final String? datePurchased;
  final String? notes;

  const RabbitDetailsModel({
    required this.rabbitId,
    required this.gender,
    required this.status,
    required this.createdAt,
    this.stage,
    this.breedName,
    this.breedId,
    this.cageId,
    this.capacity,
    this.cageType,
    this.dateOfBirth,
    this.colorMarkings,
    this.supplierId,
    this.supplierName,
    this.motherRabbitId,
    this.fatherRabbitId,
    this.datePurchased,
    this.notes,
  });

  factory RabbitDetailsModel.fromJson(Map<String, dynamic> json) {
    final rabbitId = json['rabbitId'];
    final gender = json['gender'];
    final status = json['status'];
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    if (rabbitId is! String ||
        gender is! String ||
        status is! String ||
        createdAt == null) {
      throw const FormatException('Invalid rabbit details');
    }
    return RabbitDetailsModel(
      rabbitId: rabbitId,
      gender: gender,
      status: status,
      createdAt: createdAt,
      stage: json['stage'] as String?,
      breedName: json['breedName'] as String?,
      breedId: (json['breedId'] as num?)?.toInt(),
      cageId: json['cageId'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      cageType: json['cageType'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      colorMarkings: json['colorMarkings'] as String?,
      supplierId: (json['supplierId'] as num?)?.toInt(),
      supplierName: json['supplierName'] as String?,
      motherRabbitId: json['motherRabbitId'] as String?,
      fatherRabbitId: json['fatherRabbitId'] as String?,
      datePurchased: json['datePurchased'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    rabbitId,
    gender,
    status,
    stage,
    breedName,
    breedId,
    cageId,
    capacity,
    cageType,
    dateOfBirth,
    createdAt,
    colorMarkings,
    supplierId,
    supplierName,
    motherRabbitId,
    fatherRabbitId,
    datePurchased,
    notes,
  ];
}
