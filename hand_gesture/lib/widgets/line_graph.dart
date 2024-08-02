import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hand_gesture/utils/constants.dart';

class Linechart extends StatelessWidget {
  const Linechart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 20),
              FlSpot(1, 50),
              FlSpot(2, 55),
              FlSpot(3, 80),
              FlSpot(4, 90),
              FlSpot(5, 70),
              FlSpot(6, 70),
            ],
            isCurved: true,
            color: PRIMARY_COLOR,
            barWidth: 6,
            belowBarData: BarAreaData(
              show: true,
              color: PRIMARY_COLOR.withOpacity(0.2),
            ),
            dotData: const FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }
}
