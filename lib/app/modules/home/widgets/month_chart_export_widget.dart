import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/modules/home/widgets/month_chart_widget.dart';

class MonthChartExportWidget extends StatelessWidget {
  final DateTime month;
  final RxMap<String, DailyRecord> recordsMap;

  const MonthChartExportWidget({
    super.key,
    required this.month,
    required this.recordsMap,
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
          padding: const EdgeInsets.all(32),
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

          // Gráfico
          SizedBox(
            height: 400,
            child: MonthChartWidget(
              month: month,
              recordsMap: recordsMap,
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          Text(
            'Mi evolución emocional',
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
}
