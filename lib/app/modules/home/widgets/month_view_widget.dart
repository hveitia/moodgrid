import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/modules/home/widgets/month_chart_widget.dart';

class MonthViewWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime> weeks;
  final RxMap<String, DailyRecord> recordsMap;
  final DateTime rangeStartDate;
  final Widget Function(DateTime, DateTime) buildWeekRow;
  final bool isChartView;

  const MonthViewWidget({
    super.key,
    required this.month,
    required this.weeks,
    required this.recordsMap,
    required this.rangeStartDate,
    required this.buildWeekRow,
    required this.isChartView,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: isChartView
          ? MonthChartWidget(
              month: month,
              recordsMap: recordsMap,
            )
          : Column(
              children: weeks.map((week) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: buildWeekRow(week, rangeStartDate),
              )).toList(),
            ),
    );
  }
}
