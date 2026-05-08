import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';

class YearInPixelsExportWidget extends StatelessWidget {
  final int year;
  final Map<String, DailyRecord> recordsMap;

  const YearInPixelsExportWidget({
    super.key,
    required this.year,
    required this.recordsMap,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(
        size: Size(920, 720),
        devicePixelRatio: 3.0,
        textScaler: TextScaler.linear(1.0),
      ),
      child: Material(
        color: Colors.white,
        child: SizedBox(
          width: 920,
          child: Container(
            padding: const EdgeInsets.all(40),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildPixelGrid(),
                const SizedBox(height: 24),
                _buildLegend(),
                const SizedBox(height: 16),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/moodgrid.png',
          height: 50,
          width: 50,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EmotionsMap',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'year_pixels.export.title'.trParams({'year': '$year'}),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPixelGrid() {
    final monthNames = [
      'year_pixels.month.jan'.tr,
      'year_pixels.month.feb'.tr,
      'year_pixels.month.mar'.tr,
      'year_pixels.month.apr'.tr,
      'year_pixels.month.may'.tr,
      'year_pixels.month.jun'.tr,
      'year_pixels.month.jul'.tr,
      'year_pixels.month.aug'.tr,
      'year_pixels.month.sep'.tr,
      'year_pixels.month.oct'.tr,
      'year_pixels.month.nov'.tr,
      'year_pixels.month.dec'.tr,
    ];

    return Column(
      children: List.generate(12, (monthIndex) {
        final month = monthIndex + 1;
        final daysInMonth = DateTime(year, month + 1, 0).day;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 45,
                child: Text(
                  monthNames[monthIndex],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: List.generate(31, (dayIndex) {
                    final day = dayIndex + 1;
                    final isValidDay = day <= daysInMonth;
                    final date = isValidDay ? DateTime(year, month, day) : null;
                    final isFuture = date != null && date.isAfter(DateTime.now());

                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: _buildPixelCell(
                            date: date,
                            isValidDay: isValidDay,
                            isFuture: isFuture,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPixelCell({
    required DateTime? date,
    required bool isValidDay,
    required bool isFuture,
  }) {
    if (!isValidDay) {
      return const SizedBox.shrink();
    }

    if (isFuture) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }

    final dateKey = date != null
        ? DateFormat('yyyy-MM-dd').format(date)
        : '';
    final record = recordsMap[dateKey];
    final colorIndex = record?.colorIndex ?? 5;
    final color = AppColors.getMoodColor(colorIndex);

    final isToday = date != null &&
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: isToday
            ? Border.all(color: Colors.black, width: 2)
            : null,
      ),
    );
  }

  Widget _buildLegend() {
    final legends = [
      {'color': AppColors.moodExcellent, 'label': AppColors.getMoodText(0)},
      {'color': AppColors.moodGood, 'label': AppColors.getMoodText(1)},
      {'color': AppColors.moodNeutral, 'label': AppColors.getMoodText(2)},
      {'color': AppColors.moodDifficult, 'label': AppColors.getMoodText(3)},
      {'color': AppColors.moodBad, 'label': AppColors.getMoodText(4)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: legends.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item['label'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Text(
      'year_pixels.export.footer'.tr,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
