import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';

import '../models/create_breeding_request.dart';
import '../models/update_breeding_request.dart';
import '../models/record_birth_request.dart';
import '../models/record_weaning_request.dart';
import '../models/record_separation_request.dart';

class BreedingService {
  final Dio _dio;

  BreedingService(this._dio);

  /// GET ALL
  Future<Response> getAll() {
    return _dio.get(ApiPaths.breedings);
  }

  /// GET ONE
  Future<Response> getById(String breedingId) {
    return _dio.get('${ApiPaths.breedings}/$breedingId');
  }

  /// CREATE
  Future<Response> createBreeding(CreateBreedingRequest request) {
    return _dio.post(ApiPaths.breedings, data: request.toJson());
  }

  /// UPDATE
  Future<Response> updateBreeding(
    String breedingId,
    UpdateBreedingRequest request,
  ) {
    return _dio.put(
      '${ApiPaths.breedings}/$breedingId',
      data: request.toJson(),
    );
  }

  /// DELETE
  Future<Response> deleteBreeding(String breedingId) {
    return _dio.delete('${ApiPaths.breedings}/$breedingId');
  }

  /// RECORD BIRTH
  Future<Response> recordBirth(String breedingId, RecordBirthRequest request) {
    return _dio.post(
      '/breedings/$breedingId/record-birth',
      data: request.toJson(),
    );
  }

  /// RECORD WEANING
  Future<Response> recordWeaning(
    String breedingId,
    RecordWeaningRequest request,
  ) {
    return _dio.post(
      '/breedings/$breedingId/record-weaning',
      data: request.toJson(),
    );
  }

  /// RECORD SEPARATION
  Future<Response> recordSeparation(
    String breedingId,
    RecordSeparationRequest request,
  ) {
    return _dio.post(
      '/breedings/$breedingId/record-separation',
      data: request.toJson(),
    );
  }

  /// FILTERS
  Future<Response> getPregnant() {
    return _dio.get('/breedings/pregnant');
  }

  Future<Response> getDueSoon() {
    return _dio.get('/breedings/due-soon');
  }

  Future<Response> getOverdue() {
    return _dio.get('/breedings/overdue');
  }

  Future<Response> getRecentBirths() {
    return _dio.get('/breedings/recent-births');
  }

  /// SEARCH RABBITS
  Future<Response> searchRabbits(String query) {
    return _dio.get(
      '/rabbits/search-rabbits',
      queryParameters: {'query': query},
    );
  }
}
