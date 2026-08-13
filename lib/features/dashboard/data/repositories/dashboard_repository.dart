import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/dashboard_data.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/services/dashboard_service.dart';
import '../models/dashboard_summary_model.dart';
import '../models/revenue_chart_model.dart';
import '../models/mortality_chart_model.dart';
import '../models/breeding_chart_model.dart';
import '../models/cage_utilization_model.dart';
import 'package:dio/dio.dart';
import 'package:rabbit_farm_mobileapp/core/network/api_envelope_parser.dart';

class DashboardRepository {
  final DashboardService _service;

  DashboardRepository(this._service);

  Future<DashboardData> loadDashboard() async {
    final results = await Future.wait<Response>([
      _service.getSummary(),
      _service.getRevenueChart(),
      _service.getMortalityChart(),
      _service.getBreedingChart(),
      _service.getCageUtilization(),
    ]);

    final summaryResponse = ApiEnvelopeParser.dataMap(results[0].data);
    final revenueResponse = ApiEnvelopeParser.dataList(results[1].data);
    final mortalityResponse = ApiEnvelopeParser.dataList(results[2].data);
    final breedingResponse = ApiEnvelopeParser.dataList(results[3].data);
    final cageResponse = ApiEnvelopeParser.dataList(results[4].data);

    return DashboardData(
      summary: DashboardSummaryModel.fromJson(summaryResponse),

      revenueChart: revenueResponse
          .map((e) => RevenueChartModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      mortalityChart: mortalityResponse
          .map((e) => MortalityChartModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      breedingChart: breedingResponse
          .map((e) => BreedingChartModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      cageUtilization: cageResponse
          .map((e) => CageUtilizationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
