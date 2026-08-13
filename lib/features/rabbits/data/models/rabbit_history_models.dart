import 'package:equatable/equatable.dart';

class RabbitHealthRecord extends Equatable {
  final int id;
  final String treatmentDate;
  final String treatment;
  final num cost;
  final String? notes;
  const RabbitHealthRecord({
    required this.id,
    required this.treatmentDate,
    required this.treatment,
    required this.cost,
    this.notes,
  });
  factory RabbitHealthRecord.fromJson(Map<String, dynamic> json) =>
      RabbitHealthRecord(
        id: (json['healthRecordId'] as num).toInt(),
        treatmentDate: json['treatmentDate'] as String,
        treatment: json['treatment'] as String,
        cost: json['cost'] as num,
        notes: json['notes'] as String?,
      );
  @override
  List<Object?> get props => [id, treatmentDate, treatment, cost, notes];
}

class RabbitBreedingRecord extends Equatable {
  final String breedingId;
  final String doeRabbitId;
  final String buckRabbitId;
  final String crossingDate;
  final String? expectedBirthDate;
  final String? actualBirthDate;
  final int? kitsBorn;
  final String? status;
  final String? notes;
  const RabbitBreedingRecord({
    required this.breedingId,
    required this.doeRabbitId,
    required this.buckRabbitId,
    required this.crossingDate,
    this.expectedBirthDate,
    this.actualBirthDate,
    this.kitsBorn,
    this.status,
    this.notes,
  });
  factory RabbitBreedingRecord.fromJson(Map<String, dynamic> json) =>
      RabbitBreedingRecord(
        breedingId: json['breedingId'] as String,
        doeRabbitId: json['doeRabbitId'] as String,
        buckRabbitId: json['buckRabbitId'] as String,
        crossingDate: json['crossingDate'] as String,
        expectedBirthDate: json['expectedBirthDate'] as String?,
        actualBirthDate: json['actualBirthDate'] as String?,
        kitsBorn: (json['kitsBorn'] as num?)?.toInt(),
        status: json['status'] as String?,
        notes: json['notes'] as String?,
      );
  @override
  List<Object?> get props => [
    breedingId,
    doeRabbitId,
    buckRabbitId,
    crossingDate,
    expectedBirthDate,
    actualBirthDate,
    kitsBorn,
    status,
    notes,
  ];
}

class RabbitSaleRecord extends Equatable {
  final int saleId;
  final String saleDate;
  final String buyerName;
  final String? buyerContact;
  final num amount;
  const RabbitSaleRecord({
    required this.saleId,
    required this.saleDate,
    required this.buyerName,
    required this.amount,
    this.buyerContact,
  });
  factory RabbitSaleRecord.fromJson(Map<String, dynamic> json) =>
      RabbitSaleRecord(
        saleId: (json['saleId'] as num).toInt(),
        saleDate: json['saleDate'] as String,
        buyerName: json['buyerName'] as String,
        buyerContact: json['buyerContact'] as String?,
        amount: json['amount'] as num,
      );
  @override
  List<Object?> get props => [
    saleId,
    saleDate,
    buyerName,
    buyerContact,
    amount,
  ];
}

class RabbitCageMovementRecord extends Equatable {
  final String movementId;
  final String? fromCageId;
  final String toCageId;
  final String effectiveDate;
  final String? reason;
  final String? notes;
  const RabbitCageMovementRecord({
    required this.movementId,
    required this.toCageId,
    required this.effectiveDate,
    this.fromCageId,
    this.reason,
    this.notes,
  });
  factory RabbitCageMovementRecord.fromJson(Map<String, dynamic> json) =>
      RabbitCageMovementRecord(
        movementId: json['movementId'] as String,
        fromCageId: json['fromCageId'] as String?,
        toCageId: json['toCageId'] as String,
        effectiveDate: json['effectiveDate'] as String,
        reason: json['reason'] as String?,
        notes: json['notes'] as String?,
      );
  @override
  List<Object?> get props => [
    movementId,
    fromCageId,
    toCageId,
    effectiveDate,
    reason,
    notes,
  ];
}
