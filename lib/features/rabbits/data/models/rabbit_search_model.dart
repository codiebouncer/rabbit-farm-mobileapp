class RabbitSearchModel {
  final String rabbitId;

  const RabbitSearchModel({required this.rabbitId});

  factory RabbitSearchModel.fromJson(Map<String, dynamic> json) {
    return RabbitSearchModel(rabbitId: json['rabbitId']);
  }
}
