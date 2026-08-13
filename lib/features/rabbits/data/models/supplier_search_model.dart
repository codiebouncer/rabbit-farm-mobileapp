class SupplierSearchModel {
  final int supplierId;
  final String supplierName;

  const SupplierSearchModel({
    required this.supplierId,
    required this.supplierName,
  });

  factory SupplierSearchModel.fromJson(Map<String, dynamic> json) {
    return SupplierSearchModel(
      supplierId: json['supplierId'],
      supplierName: json['supplierName'],
    );
  }
}
