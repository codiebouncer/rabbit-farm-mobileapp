import 'package:json_annotation/json_annotation.dart';

part 'record_birth_request.g.dart';

@JsonSerializable()
class RecordBirthRequest {
  final DateTime actualBirthDate;

  final int kitsBorn;

  final int activeBorn;

  final int maleKits;

  final int femaleKits;

  const RecordBirthRequest({
    required this.actualBirthDate,
    required this.kitsBorn,
    required this.activeBorn,
    required this.maleKits,
    required this.femaleKits,
  });

  factory RecordBirthRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordBirthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecordBirthRequestToJson(this);
}
