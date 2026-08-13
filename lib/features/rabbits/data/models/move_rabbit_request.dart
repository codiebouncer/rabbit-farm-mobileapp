class MoveRabbitRequest {
  final String cageId;
  final String effectiveDate;
  final String? reason;
  final String? notes;
  const MoveRabbitRequest({
    required this.cageId,
    required this.effectiveDate,
    this.reason,
    this.notes,
  });
  Map<String, dynamic> toJson() => {
    'cageId': cageId,
    'effectiveDate': effectiveDate,
    'reason': reason,
    'notes': notes,
  };
}
