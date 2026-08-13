import 'package:json_annotation/json_annotation.dart';

part 'update_breeding_request.g.dart';

@JsonSerializable()
class UpdateBreedingRequest {
  final String crossingDate;

  final String? notes;

  final String? status;

  const UpdateBreedingRequest({
    required this.crossingDate,
    this.notes,
    this.status,
  });

  factory UpdateBreedingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBreedingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBreedingRequestToJson(this);
}
