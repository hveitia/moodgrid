import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodGrid'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.profile),
              child: CircleAvatar(
                backgroundColor: AppColors.moodExcellent,
                child: Text(
                  _getUserInitial(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Obx(() {
        if (controller.isLoading.value && controller.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Leyenda de colores
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildLegend(),
            ),
            const SizedBox(height: 16),

            // Header fijo de días de la semana
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildWeekdayHeader(),
            ),
            const SizedBox(height: 8),

            // Matriz de vida scrolleable
            Expanded(
              child: _buildMoodGrid(),
            ),
          ],
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

    // Determinar fecha de inicio basada en el primer registro o el mes actual
    DateTime rangeStartDate;

    if (controller.records.isNotEmpty) {
      // Si hay registros, usar el primer día del mes del primer registro
      final firstRecord = controller.records.last;
      rangeStartDate = DateTime(firstRecord.date.year, firstRecord.date.month, 1);
    } else {
      // Si no hay registros, usar el primer día del mes actual
      rangeStartDate = DateTime(now.year, now.month, 1);
    }

    // Encontrar el lunes de la semana donde cae rangeStartDate
    // weekday: 1=lunes, 2=martes, ..., 7=domingo
    final daysFromMonday = rangeStartDate.weekday - DateTime.monday;
    final firstMonday = rangeStartDate.subtract(Duration(days: daysFromMonday));

    // Calcular cuántas semanas hay desde firstMonday hasta hoy
    final daysDifference = today.difference(firstMonday).inDays;
    final weeksToShow = (daysDifference / 7).ceil() + 1;

    // Agrupar semanas por mes
    final monthBlocks = _groupWeeksByMonth(firstMonday, weeksToShow, rangeStartDate, today);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: monthBlocks.length,
      itemBuilder: (context, index) {
        final block = monthBlocks[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Separador de mes
            _buildMonthSeparator(block['month'] as DateTime),
            const SizedBox(height: 12),

            // Semanas del mes
            ...block['weeks'].map((week) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _buildWeekRow(week as DateTime, rangeStartDate),
            )),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Agrupar semanas por mes
  List<Map<String, dynamic>> _groupWeeksByMonth(
    DateTime firstMonday,
    int weeksToShow,
    DateTime rangeStartDate,
    DateTime today,
  ) {
    final List<Map<String, dynamic>> monthBlocks = [];
    DateTime? currentMonth;
    List<DateTime> currentWeeks = [];

    for (int weekIndex = 0; weekIndex < weeksToShow; weekIndex++) {
      final weekStart = firstMonday.add(Duration(days: weekIndex * 7));

      // Determinar el mes de esta semana (usar el primer día válido de la semana)
      DateTime? weekMonth;
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        final date = weekStart.add(Duration(days: dayIndex));
        if (!date.isBefore(rangeStartDate) && !date.isAfter(today)) {
          weekMonth = DateTime(date.year, date.month, 1);
          break;
        }
      }

      if (weekMonth == null) continue;

      // Si cambiamos de mes, crear nuevo bloque
      if (currentMonth == null || currentMonth.month != weekMonth.month || currentMonth.year != weekMonth.year) {
        if (currentMonth != null && currentWeeks.isNotEmpty) {
          monthBlocks.add({
            'month': currentMonth,
            'weeks': List<DateTime>.from(currentWeeks),
          });
        }
        currentMonth = weekMonth;
        currentWeeks = [];
      }

      currentWeeks.add(weekStart);
    }

    // Agregar el último bloque
    if (currentMonth != null && currentWeeks.isNotEmpty) {
      monthBlocks.add({
        'month': currentMonth,
        'weeks': List<DateTime>.from(currentWeeks),
      });
    }

    return monthBlocks;
  }

  // Construir separador de mes
  Widget _buildMonthSeparator(DateTime month) {
    final monthName = DateFormat('MMMM', 'es_ES').format(month);
    final year = month.year;
    final capitalizedMonth = monthName[0].toUpperCase() + monthName.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.moodExcellent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$capitalizedMonth - $year',
        style: Get.textTheme.titleMedium?.copyWith(
          color: AppColors.moodExcellent,
          fontWeight: FontWeight.w600,
        ),
      ),
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

  // Construir fila de semana
  Widget _buildWeekRow(DateTime weekStart, DateTime rangeStartDate) {
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
              : _buildDayCell(date),
        );
      }),
    );
  }

  // Construir celda vacía
  Widget _buildEmptyCell() {
    return Container(
      margin: const EdgeInsets.all(2),
      child: const AspectRatio(
        aspectRatio: 1,
        child: SizedBox.shrink(),
      ),
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

    final colorIndex = record?.colorIndex ?? 5;
    final cellColor = AppColors.getMoodColor(colorIndex);

    return GestureDetector(
      onTap: () => controller.showRecordDialog(date),
      child: Container(
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
      ),
    );
  }

  Widget _buildDrawer() {
    final authController = Get.find<AuthController>();
    final email = authController.user?.email ?? 'Usuario';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.moodExcellent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    _getUserInitial(),
                    style: TextStyle(
                      color: AppColors.moodExcellent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Respaldo de Datos'),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.backup);
            },
          ),
        ],
      ),
    );
  }

  String _getUserInitial() {
    final authController = Get.find<AuthController>();
    final email = authController.user?.email ?? '';
    if (email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }
}
