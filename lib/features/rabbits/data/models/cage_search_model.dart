class CageSearchModel {
  final String cageId;
  final int? capacity;
  final int? occupancy;
  final int? availableSpaces;
  final String? cageType;
  final String? status;

  const CageSearchModel({
    required this.cageId,
    this.capacity,
    this.occupancy,
    this.availableSpaces,
    this.cageType,
    this.status,
  });

  factory CageSearchModel.fromJson(Map<String, dynamic> json) {
    final cageId = json['cageId'];
    if (cageId is! String) throw const FormatException('Invalid cage');
    return CageSearchModel(
      cageId: cageId,
      capacity: (json['capacity'] as num?)?.toInt(),
      occupancy: (json['occupancy'] as num?)?.toInt(),
      availableSpaces: (json['availableSpaces'] as num?)?.toInt(),
      cageType: json['cageType'] as String?,
      status: json['status'] as String?,
    );
  }
}
