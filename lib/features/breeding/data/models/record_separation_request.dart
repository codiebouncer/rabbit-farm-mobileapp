import 'package:json_annotation/json_annotation.dart';

part 'record_separation_request.g.dart';

@JsonSerializable()
class RecordSeparationRequest {
  final DateTime separationDate;

  const RecordSeparationRequest({required this.separationDate});

  factory RecordSeparationRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordSeparationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecordSeparationRequestToJson(this);
}
