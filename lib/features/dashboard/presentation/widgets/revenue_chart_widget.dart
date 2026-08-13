import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/revenue_chart_model.dart';

class RevenueChartWidget extends StatelessWidget {
  final List<RevenueChartModel> data;

  const RevenueChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(index.toDouble(), data[index].revenue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
