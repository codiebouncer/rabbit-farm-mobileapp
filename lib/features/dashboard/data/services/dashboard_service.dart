import 'package:dio/dio.dart';

class DashboardService {
  final Dio _dio;

  DashboardService(this._dio);

  Future<Response> getSummary() async {
    final response = await _dio.get('/dashboard/summary');
    return response;
  }

  Future<Response> getRevenueChart() async {
    final response = await _dio.get('/dashboard/revenue-chart');
    return response;
  }

  Future<Response> getMortalityChart() async {
    final response = await _dio.get('/dashboard/mortality-chart');
    return response;
  }

  Future<Response> getBreedingChart() async {
    final response = await _dio.get('/dashboard/breeding-chart');

    return response;
  }

  Future<Response> getCageUtilization() async {
    final response = await _dio.get('/dashboard/cage-utilization');

    return response;
  }
}
