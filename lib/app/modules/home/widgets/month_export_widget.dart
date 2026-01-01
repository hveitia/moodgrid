import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';

class MonthExportWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime> weeks;
  final RxMap<String, DailyRecord> recordsMap;
  final DateTime rangeStartDate;

  const MonthExportWidget({
    super.key,
    required this.month,
    required this.weeks,
    required this.recordsMap,
    required this.rangeStartDate,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat('MMMM', 'es_ES').format(month);
    final capitalizedMonth = monthName[0].toUpperCase() + monthName.substring(1);

    return MediaQuery(
      data: const MediaQueryData(
        size: Size(800, 600),
        devicePixelRatio: 3.0,
        textScaler: TextScaler.linear(1.0),
      ),
      child: Material(
        color: Colors.white,
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Image.asset(
                    'assets/moodgrid.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MoodGrid',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$capitalizedMonth ${month.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Grid
              _buildWeekdayHeader(),
              const SizedBox(height: 12),
              _buildWeeksGrid(),

              const SizedBox(height: 24),

              // Footer
              Text(
                'Mi registro de estado de ánimo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeksGrid() {
    return Column(
      children: weeks.map((weekStart) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildWeekRow(weekStart),
        );
      }).toList(),
    );
  }

  Widget _buildWeekRow(DateTime weekStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Row(
      children: List.generate(7, (dayIndex) {
        final date = weekStart.add(Duration(days: dayIndex));
        final isBeforeRange = date.isBefore(rangeStartDate);
        final isAfterToday = date.isAfter(today);
        // Solo mostrar celdas que pertenecen al mes actual
        final isInCurrentMonth = date.year == month.year && date.month == month.month;

        return Expanded(
          child: isBeforeRange || isAfterToday || !isInCurrentMonth
              ? _buildEmptyCell()
              : _buildDayCell(date, today),
        );
      }),
    );
  }

  Widget _buildEmptyCell() {
    return Container(
      margin: const EdgeInsets.all(2),
      child: const AspectRatio(
        aspectRatio: 1,
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, DateTime today) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final record = recordsMap[dateKey];
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    final colorIndex = record?.colorIndex ?? 5;
    final cellColor = AppColors.getMoodColor(colorIndex);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(4),
        border: isToday
            ? Border.all(color: AppColors.textPrimary, width: 2)
            : Border.all(
                color: AppColors.divider,
                width: 0.5,
              ),
      ),
      child: const AspectRatio(
        aspectRatio: 1,
      ),
    );
  }
}
