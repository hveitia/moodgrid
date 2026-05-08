import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';

class YearInPixelsWidget extends StatelessWidget {
  final int year;
  final Map<String, DailyRecord> recordsMap;
  final VoidCallback? onExport;

  const YearInPixelsWidget({
    super.key,
    required this.year,
    required this.recordsMap,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildPixelGrid(),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.moodGood.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.grid_view_rounded,
            color: AppColors.moodGood,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'year_pixels.title'.tr,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$year',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (onExport != null)
          IconButton(
            onPressed: onExport,
            icon: Icon(
              Icons.share,
              color: AppColors.moodGood,
            ),
            tooltip: 'year_pixels.tooltip.export'.tr,
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
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  monthNames[monthIndex],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
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
                          padding: const EdgeInsets.all(0.5),
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
          borderRadius: BorderRadius.circular(2),
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
        borderRadius: BorderRadius.circular(2),
        border: isToday
            ? Border.all(color: Colors.black, width: 1.5)
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
      {'color': AppColors.moodEmpty, 'label': AppColors.getMoodText(5)},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: legends.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item['label'] as String,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
