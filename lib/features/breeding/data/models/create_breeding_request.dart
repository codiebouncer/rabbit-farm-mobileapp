import 'package:json_annotation/json_annotation.dart';

part 'create_breeding_request.g.dart';

@JsonSerializable()
class CreateBreedingRequest {
  final String breedingId;

  final String doeRabbitId;

  final String buckRabbitId;

  final String crossingDate;

  final String? notes;

  const CreateBreedingRequest({
    required this.breedingId,
    required this.doeRabbitId,
    required this.buckRabbitId,
    required this.crossingDate,
    this.notes,
  });

  factory CreateBreedingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBreedingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBreedingRequestToJson(this);
}
