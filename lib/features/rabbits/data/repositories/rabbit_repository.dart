import 'package:rabbit_farm_mobileapp/core/network/api_envelope_parser.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/breed_search_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/cage_search_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/create_rabbbit_request.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_search_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/supplier_search_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/update_rabbit.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/move_rabbit_request.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/paged_rabbits.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_history_models.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_profile.dart';
import 'package:rabbit_farm_mobileapp/shared/models/api_response.dart';

import '../models/rabbit_model.dart';
import '../models/rabbit_details_model.dart';
import '../services/rabbit_service.dart';

class RabbitRepository {
  final RabbitService _service;

  RabbitRepository(this._service);

  Future<PagedRabbits> getPage({
    required int page,
    int pageSize = 20,
    String? query,
    String? status,
  }) async {
    final response = await _service.getPage(
      page: page,
      pageSize: pageSize,
      query: query,
      status: status,
    );
    return PagedRabbits.fromJson(ApiEnvelopeParser.dataMap(response.data));
  }

  Future<List<RabbitModel>> getAll() async {
    final response = await _service.getAll();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<RabbitDetailsModel> getById(String rabbitId) async {
    final response = await _service.getById(rabbitId);

    return RabbitDetailsModel.fromJson(
      ApiEnvelopeParser.dataMap(response.data),
    );
  }

  Future<RabbitProfile> getProfile(String rabbitId) async {
    final responses = await Future.wait([
      _service.getById(rabbitId),
      _service.getHealthHistory(rabbitId),
      _service.getBreedingHistory(rabbitId),
      _service.getOffspring(rabbitId),
      _service.getSalesHistory(rabbitId),
      _service.getCageMovements(rabbitId),
    ]);
    return RabbitProfile(
      rabbit: RabbitDetailsModel.fromJson(
        ApiEnvelopeParser.dataMap(responses[0].data),
      ),
      healthHistory: ApiEnvelopeParser.dataList(responses[1].data)
          .map(
            (item) => RabbitHealthRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      breedingHistory: ApiEnvelopeParser.dataList(responses[2].data)
          .map(
            (item) => RabbitBreedingRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      offspring: ApiEnvelopeParser.dataList(responses[3].data)
          .map(
            (item) =>
                RabbitModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      salesHistory: ApiEnvelopeParser.dataList(responses[4].data)
          .map(
            (item) => RabbitSaleRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      cageMovements: ApiEnvelopeParser.dataList(responses[5].data)
          .map(
            (item) => RabbitCageMovementRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Future<List<RabbitModel>> getActive() async {
    final response = await _service.getActive();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<RabbitModel>> getPregnant() async {
    final response = await _service.getPregnant();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<RabbitModel>> getSold() async {
    final response = await _service.getSold();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<RabbitModel>> getDead() async {
    final response = await _service.getDead();

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<RabbitModel>> search(String query) async {
    final response = await _service.search(query);

    return ApiEnvelopeParser.dataList(response.data)
        .map((e) => RabbitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> markPregnant(String rabbitId) => _service.markPregnant(rabbitId);

  Future<void> markDeceased(String rabbitId) => _service.markDeceased(rabbitId);

  Future<void> moveCage(String rabbitId, MoveRabbitRequest request) =>
      _service.moveCage(rabbitId, request);

  Future<void> markSold(
    String rabbitId,
    double amount,
    String buyerName,
    String buyerContact,
  ) => _service.markSold(rabbitId, amount, buyerName, buyerContact);
  Future<void> updateRabbit(String rabbitId, UpdateRabbitRequest request) {
    return _service.updateRabbit(rabbitId, request);
  }

  Future<List<BreedSearchModel>> searchBreeds(String query) async {
    final response = await _service.searchBreeds(query);

    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (e) => BreedSearchModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<List<SupplierSearchModel>> searchSuppliers(String query) async {
    final response = await _service.searchSuppliers(query);

    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (e) =>
              SupplierSearchModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<List<CageSearchModel>> searchCages(String query) async {
    final response = await _service.searchCages(query);

    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (e) => CageSearchModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<List<CageSearchModel>> getAvailableCages() async {
    final response = await _service.getAvailableCages();
    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (item) =>
              CageSearchModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<List<RabbitSearchModel>> searchRabbits(String query) async {
    final response = await _service.searchRabbit(query);
    return ApiEnvelopeParser.dataList(response.data)
        .map(
          (e) =>
              RabbitSearchModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<ApiResponse<dynamic>> createRabbit(CreateRabbitRequest request) async {
    final response = await _service.createRabbit(request);

    return ApiResponse<dynamic>(
      success: response.data is Map && response.data['success'] == true,
      message: response.data is Map && response.data['message'] is String
          ? response.data['message'] as String
          : 'Rabbit created successfully.',
      data: ApiEnvelopeParser.data(response.data),
    );
  }

  Future<RabbitDetailsModel> createRabbitAndReturn(
    CreateRabbitRequest request,
  ) async {
    final response = await _service.createRabbit(request);
    return RabbitDetailsModel.fromJson(
      ApiEnvelopeParser.dataMap(response.data),
    );
  }

  Future<RabbitDetailsModel> updateRabbitAndReturn(
    String rabbitId,
    UpdateRabbitRequest request,
  ) async {
    final response = await _service.updateRabbit(rabbitId, request);
    return RabbitDetailsModel.fromJson(
      ApiEnvelopeParser.dataMap(response.data),
    );
  }
}
