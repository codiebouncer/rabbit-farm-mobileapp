import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/breeding_chart_model.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/cage_utilization_model.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/mortality_chart_model.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/revenue_chart_model.dart';

class DashboardData {
  final DashboardSummaryModel summary;

  final List<RevenueChartModel> revenueChart;

  final List<MortalityChartModel> mortalityChart;

  final List<BreedingChartModel> breedingChart;

  final List<CageUtilizationModel> cageUtilization;

  DashboardData({
    required this.summary,
    required this.revenueChart,
    required this.mortalityChart,
    required this.breedingChart,
    required this.cageUtilization,
  });
}
