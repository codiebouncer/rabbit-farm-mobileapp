import 'package:json_annotation/json_annotation.dart';

part 'record_weaning_request.g.dart';

@JsonSerializable()
class RecordWeaningRequest {
  final DateTime weaningDate;

  const RecordWeaningRequest({required this.weaningDate});

  factory RecordWeaningRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordWeaningRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecordWeaningRequestToJson(this);
}
