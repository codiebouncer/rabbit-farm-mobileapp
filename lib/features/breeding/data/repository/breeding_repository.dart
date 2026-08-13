import 'package:rabbit_farm_mobileapp/features/breeding/data/models/breeding_model.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/create_breeding_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/record_birth_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/record_separation_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/record_weaning_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/models/update_breeding_request.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/services/breeding_service.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_search_model.dart';
import 'package:rabbit_farm_mobileapp/core/network/api_envelope_parser.dart';

class BreedingRepository {
  final BreedingService _service;

  BreedingRepository(this._service);

  Future<List<BreedingModel>> getAll() async {
    final response = await _service.getAll();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => BreedingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<BreedingModel> getById(String breedingId) async {
    final response = await _service.getById(breedingId);

    return BreedingModel.fromJson(ApiEnvelopeParser.dataMap(response.data));
  }

  Future<List<BreedingModel>> getPregnant() async {
    final response = await _service.getPregnant();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => BreedingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<BreedingModel>> getDueSoon() async {
    final response = await _service.getDueSoon();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => BreedingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<BreedingModel>> getOverdue() async {
    final response = await _service.getOverdue();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => BreedingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<BreedingModel>> getRecentBirths() async {
    final response = await _service.getRecentBirths();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => BreedingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> createBreeding(CreateBreedingRequest request) {
    return _service.createBreeding(request);
  }

  Future<void> updateBreeding(
    String breedingId,
    UpdateBreedingRequest request,
  ) {
    return _service.updateBreeding(breedingId, request);
  }

  Future<void> deleteBreeding(String breedingId) {
    return _service.deleteBreeding(breedingId);
  }

  Future<void> recordBirth(String breedingId, RecordBirthRequest request) {
    return _service.recordBirth(breedingId, request);
  }

  Future<void> recordWeaning(String breedingId, RecordWeaningRequest request) {
    return _service.recordWeaning(breedingId, request);
  }

  Future<void> recordSeparation(
    String breedingId,
    RecordSeparationRequest request,
  ) {
    return _service.recordSeparation(breedingId, request);
  }

  Future<List<RabbitSearchModel>> searchRabbits(String query) async {
    final response = await _service.searchRabbits(query);

    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (e) =>
              RabbitSearchModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }
}
