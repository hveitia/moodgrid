import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthExportWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime> weeks;
  final Map<String, DailyRecord> recordsMap;
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
    return Container(
      width: 420,
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 20),
          _buildWeekdayHeader(),
          const SizedBox(height: 12),
          _buildWeeksGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final monthName = DateFormat('MMMM', 'es_ES').format(month);
    final year = month.year;
    final capitalizedMonth = monthName[0].toUpperCase() + monthName.substring(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.moodExcellent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$capitalizedMonth - $year',
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.moodExcellent,
        ),
        textAlign: TextAlign.center,
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
              style: GoogleFonts.montserrat(
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

        return Expanded(
          child: isBeforeRange || isAfterToday
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
      child: AspectRatio(
        aspectRatio: 1,
        child: record?.comment != null && record!.comment!.isNotEmpty
            ? Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
