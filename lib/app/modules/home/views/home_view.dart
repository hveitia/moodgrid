import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodGrid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: controller.exportData,
            tooltip: 'Exportar datos',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: controller.importData,
            tooltip: 'Importar datos',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'stats') {
                _showStatistics(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart),
                    SizedBox(width: 8),
                    Text('Estadísticas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leyenda de colores
              _buildLegend(),
              const SizedBox(height: 24),

              // Matriz de vida
              _buildMoodGrid(),
            ],
          ),
        );
      }),
    );
  }

  // Construir leyenda de colores
  Widget _buildLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leyenda',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(5, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.getMoodColor(index),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppColors.getMoodText(index),
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Construir matriz de vida
  Widget _buildMoodGrid() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calcular cuántas semanas mostrar (últimas 52 semanas = 1 año)
    const weeksToShow = 52;

    // Calcular el primer día (hace 52 semanas desde hoy)
    final startDate = today.subtract(Duration(days: weeksToShow * 7));

    // Ajustar al lunes más cercano
    final daysToMonday = (startDate.weekday - DateTime.monday) % 7;
    final firstMonday = startDate.subtract(Duration(days: daysToMonday));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de días de la semana
        _buildWeekdayHeader(),
        const SizedBox(height: 8),

        // Grid de semanas
        _buildWeeksGrid(firstMonday, weeksToShow),
      ],
    );
  }

  // Construir encabezado de días de la semana
  Widget _buildWeekdayHeader() {
    final weekdays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Construir grid de semanas
  Widget _buildWeeksGrid(DateTime firstMonday, int weeksToShow) {
    return Column(
      children: List.generate(weeksToShow, (weekIndex) {
        final weekStart = firstMonday.add(Duration(days: weekIndex * 7));
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildWeekRow(weekStart),
        );
      }),
    );
  }

  // Construir fila de semana
  Widget _buildWeekRow(DateTime weekStart) {
    return Row(
      children: List.generate(7, (dayIndex) {
        final date = weekStart.add(Duration(days: dayIndex));
        return Expanded(
          child: _buildDayCell(date),
        );
      }),
    );
  }

  // Construir celda de día
  Widget _buildDayCell(DateTime date) {
    final record = controller.getRecordForDate(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isFuture = date.isAfter(today);

    final colorIndex = record?.colorIndex ?? 5;
    final cellColor = isFuture ? Colors.transparent : AppColors.getMoodColor(colorIndex);

    return GestureDetector(
      onTap: isFuture ? null : () => controller.showRecordDialog(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(4),
          border: isToday
              ? Border.all(color: AppColors.textPrimary, width: 2)
              : Border.all(
                  color: isFuture ? Colors.transparent : AppColors.divider,
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
      ),
    );
  }

  // Mostrar estadísticas
  void _showStatistics(BuildContext context) async {
    final stats = await controller.getMoodStatistics();
    final total = stats.values.reduce((a, b) => a + b);

    Get.dialog(
      AlertDialog(
        title: const Text('Estadísticas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de registros: $total',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final count = stats[index] ?? 0;
              final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.getMoodColor(index),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppColors.getMoodText(index),
                            style: Get.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: total > 0 ? count / total : 0,
                            backgroundColor: AppColors.divider,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.getMoodColor(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$count ($percentage%)',
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
