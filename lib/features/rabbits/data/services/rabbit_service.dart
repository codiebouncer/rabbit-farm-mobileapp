import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/create_rabbbit_request.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/update_rabbit.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/move_rabbit_request.dart';

class RabbitService {
  final Dio _dio;

  RabbitService(this._dio);

  Future<Response> getAll() => _dio.get(ApiPaths.rabbits);

  Future<Response> getPage({
    required int page,
    required int pageSize,
    String? query,
    String? status,
  }) => _dio.get(
    '${ApiPaths.rabbits}/paged',
    queryParameters: {
      'page': page,
      'pageSize': pageSize,
      if (query != null && query.isNotEmpty) 'query': query,
      if (status != null && status != 'All') 'status': status,
    },
  );

  Future<Response> getById(String rabbitId) =>
      _dio.get('${ApiPaths.rabbits}/$rabbitId');

  Future<Response> getPregnant() => _dio.get('/rabbits/pregnant');

  Future<Response> getActive() => _dio.get('/rabbits/active');

  Future<Response> getSold() => _dio.get('/rabbits/sold');

  Future<Response> getDead() => _dio.get('/rabbits/dead');

  Future<Response> search(String query) =>
      _dio.get('/rabbits/search', queryParameters: {'query': query});

  Future<void> markPregnant(String rabbitId) async {
    await _dio.put('/rabbits/$rabbitId/mark-pregnant');
  }

  Future<void> markDeceased(String rabbitId) async {
    await _dio.put('/rabbits/$rabbitId/mark-deceased');
  }

  Future<void> moveCage(String rabbitId, MoveRabbitRequest request) async {
    await _dio.put('/rabbits/$rabbitId/move-cage', data: request.toJson());
  }

  Future<void> markSold(
    String rabbitId,
    double amount,
    String buyerName,
    String buyerContact,
  ) async {
    await _dio.put(
      '/rabbits/$rabbitId/mark-sold',
      data: {
        'amount': amount,
        'buyerName': buyerName,
        'buyerContact': buyerContact,
      },
    );
  }

  Future<Response> updateRabbit(String rabbitId, UpdateRabbitRequest request) =>
      _dio.put('/rabbits/$rabbitId', data: request.toJson());

  Future<Response> searchBreeds(String query) {
    return _dio.get('/breeds/search', queryParameters: {'query': query});
  }

  Future<Response> searchSuppliers(String query) {
    return _dio.get('/suppliers/search', queryParameters: {'query': query});
  }

  Future<Response> searchCages(String query) {
    return _dio.get(
      '${ApiPaths.cages}/search',
      queryParameters: {'query': query},
    );
  }

  Future<Response> getAvailableCages() =>
      _dio.get('${ApiPaths.cages}/available');

  Future<Response> createRabbit(CreateRabbitRequest request) {
    return _dio.post(ApiPaths.rabbits, data: request.toJson());
  }

  Future<Response> searchRabbit(String query) {
    return _dio.get(
      '/rabbits/search-rabbits',
      queryParameters: {'query': query},
    );
  }

  Future<Response> getHealthHistory(String rabbitId) =>
      _dio.get('/rabbits/$rabbitId/health-history');

  Future<Response> getBreedingHistory(String rabbitId) =>
      _dio.get('/rabbits/$rabbitId/breeding-history');

  Future<Response> getOffspring(String rabbitId) =>
      _dio.get('/rabbits/$rabbitId/offspring');

  Future<Response> getSalesHistory(String rabbitId) =>
      _dio.get('/rabbits/$rabbitId/sales-history');

  Future<Response> getCageMovements(String rabbitId) =>
      _dio.get('/rabbits/$rabbitId/cage-movements');
}
