import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';

class MonthChartWidget extends StatelessWidget {
  final DateTime month;
  final RxMap<String, DailyRecord> recordsMap;

  const MonthChartWidget({
    super.key,
    required this.month,
    required this.recordsMap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final spots = _generateSpots();

      if (spots.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay datos para este mes',
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Registra tu estado de ánimo para ver el gráfico',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < 1 || value.toInt() > 31) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              value.toInt().toString(),
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const emojis = [
                            '😢',
                            '😕',
                            '😐',
                            '🙂',
                            '😄',
                          ];
                          final index = value.toInt();
                          if (index < 0 || index >= emojis.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            emojis[index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey[400]!, width: 1),
                      bottom: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                  ),
                  minX: 1,
                  maxX: _getDaysInMonth().toDouble(),
                  minY: 0,
                  maxY: 4,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.moodBad,
                          AppColors.moodDifficult,
                          AppColors.moodNeutral,
                          AppColors.moodGood,
                          AppColors.moodExcellent,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final invertedIndex = 4 - spot.y.toInt();
                          return FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.getMoodColor(invertedIndex),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.moodBad.withValues(alpha: 0.1),
                            AppColors.moodDifficult.withValues(alpha: 0.1),
                            AppColors.moodNeutral.withValues(alpha: 0.1),
                            AppColors.moodGood.withValues(alpha: 0.1),
                            AppColors.moodExcellent.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final day = spot.x.toInt();
                          final invertedIndex = 4 - spot.y.toInt();
                          final moodText = AppColors.getMoodText(invertedIndex);
                          final date = DateTime(month.year, month.month, day);
                          final dateText = DateFormat('d MMM', 'es_ES').format(date);

                          return LineTooltipItem(
                            '$dateText\n$moodText',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                      getTooltipColor: (touchedSpot) {
                        return Colors.black87;
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Días del mes',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<FlSpot> _generateSpots() {
    final List<FlSpot> spots = [];
    final daysInMonth = _getDaysInMonth();

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final record = recordsMap[dateKey];

      if (record != null && record.colorIndex < 5) {
        final invertedValue = 4 - record.colorIndex;
        spots.add(FlSpot(day.toDouble(), invertedValue.toDouble()));
      }
    }

    return spots;
  }

  int _getDaysInMonth() {
    return DateTime(month.year, month.month + 1, 0).day;
  }
}
