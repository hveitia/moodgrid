import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:moodgrid/app/core/utils/date_format_helper.dart';
import 'package:moodgrid/app/core/widgets/ad_banner.dart';
import 'package:moodgrid/app/routes/app_routes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';

import '../widgets/month_view_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmotionsMap'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  Icons.grid_on,
                  color: !controller.isChartView.value
                      ? AppColors.moodExcellent
                      : Colors.grey[600],
                ),
                onPressed: () => controller.toggleView(false),
                tooltip: 'home.appbar.tooltip.grid'.tr,
              )),
          Obx(() => IconButton(
                icon: Icon(
                  Icons.show_chart,
                  color: controller.isChartView.value
                      ? AppColors.moodExcellent
                      : Colors.grey[600],
                ),
                onPressed: () => controller.toggleView(true),
                tooltip: 'home.appbar.tooltip.chart'.tr,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
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
      bottomNavigationBar: const AdBanner(),
      body: Obx(() {
        if (controller.isLoading.value && controller.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Leyenda de colores
            const SizedBox(height: 8),
            _buildLegend(),
            const SizedBox(height: 16),

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
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home.legend.title'.tr,
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
            _buildMonthSeparator(
              block['month'] as DateTime,
              block['weeks'] as List<dynamic>,
            ),
            const SizedBox(height: 12),
            Obx(() => !controller.isChartView.value
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildWeekdayHeader(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox.shrink()),

            // Vista de mes (cuadrícula o gráfico)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => MonthViewWidget(
                    month: block['month'] as DateTime,
                    weeks: (block['weeks'] as List<dynamic>).cast<DateTime>(),
                    recordsMap: controller.recordsMap,
                    rangeStartDate: rangeStartDate,
                    buildWeekRow: _buildWeekRow,
                    isChartView: controller.isChartView.value,
                  )),
            ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Agrupar semanas por mes (cada mes tiene su propio grid independiente)
  List<Map<String, dynamic>> _groupWeeksByMonth(
    DateTime firstMonday,
    int weeksToShow,
    DateTime rangeStartDate,
    DateTime today,
  ) {
    // Usar un mapa para agrupar semanas por mes
    final Map<String, List<DateTime>> monthWeeksMap = {};
    final List<DateTime> monthOrder = [];

    for (int weekIndex = 0; weekIndex < weeksToShow; weekIndex++) {
      final weekStart = firstMonday.add(Duration(days: weekIndex * 7));

      // Revisar cada día de la semana para determinar a qué meses pertenece
      final Set<String> monthsInWeek = {};
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        final date = weekStart.add(Duration(days: dayIndex));
        if (!date.isBefore(rangeStartDate) && !date.isAfter(today)) {
          final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          monthsInWeek.add(monthKey);
        }
      }

      // Agregar la semana a cada mes al que pertenece
      for (final monthKey in monthsInWeek) {
        if (!monthWeeksMap.containsKey(monthKey)) {
          monthWeeksMap[monthKey] = [];
          final parts = monthKey.split('-');
          monthOrder.add(DateTime(int.parse(parts[0]), int.parse(parts[1]), 1));
        }
        monthWeeksMap[monthKey]!.add(weekStart);
      }
    }

    // Ordenar meses cronológicamente
    monthOrder.sort((a, b) => a.compareTo(b));

    // Construir lista de bloques de mes
    final List<Map<String, dynamic>> monthBlocks = [];
    for (final month in monthOrder) {
      final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      final weeks = monthWeeksMap[monthKey] ?? [];
      if (weeks.isNotEmpty) {
        monthBlocks.add({
          'month': month,
          'weeks': weeks,
        });
      }
    }

    return monthBlocks;
  }

  // Construir separador de mes
  Widget _buildMonthSeparator(DateTime month, List<dynamic> weeks) {
    final monthName = appDateFormat(month, 'MMMM');
    final year = month.year;
    final capitalizedMonth = monthName[0].toUpperCase() + monthName.substring(1);
    final hasRecords = controller.hasRecordsInMonth(month);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.moodExcellent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$capitalizedMonth - $year',
              style: Get.textTheme.titleMedium?.copyWith(
                color: AppColors.moodExcellent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (hasRecords)
            IconButton(
              icon: const Icon(Icons.share, size: 30),
              color: AppColors.moodExcellent,
              tooltip: 'home.month.tooltip.export'.tr,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                controller.showExportDialog(
                  month: month,
                  weeks: weeks.cast<DateTime>(),
                );
              },
            ),
        ],
      ),
    );
  }

  // Construir encabezado de días de la semana
  Widget _buildWeekdayHeader() {
    final weekdays = [
      'home.weekday.short.mon'.tr,
      'home.weekday.short.tue'.tr,
      'home.weekday.short.wed'.tr,
      'home.weekday.short.thu'.tr,
      'home.weekday.short.fri'.tr,
      'home.weekday.short.sat'.tr,
      'home.weekday.short.sun'.tr,
    ];

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

  // Construir fila de semana (filtrada por mes)
  Widget _buildWeekRow(DateTime weekStart, DateTime rangeStartDate, DateTime currentMonth) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Row(
      children: List.generate(7, (dayIndex) {
        final date = weekStart.add(Duration(days: dayIndex));
        final isBeforeRange = date.isBefore(rangeStartDate);
        final isAfterToday = date.isAfter(today);
        // Solo mostrar celdas que pertenecen al mes actual
        final isInCurrentMonth = date.year == currentMonth.year && date.month == currentMonth.month;

        return Expanded(
          child: isBeforeRange || isAfterToday || !isInCurrentMonth
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
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      size: 10,
                      color: Colors.black87,
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
    final email = authController.user?.email ?? 'profile.user_default'.tr;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.moodExcellent,
                  AppColors.moodGood,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      _getUserInitial(),
                      style: TextStyle(
                        color: AppColors.moodExcellent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'drawer.welcome'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Sección Principal
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              'drawer.section.main'.tr,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_rounded, color: AppColors.moodExcellent),
            title: Text('drawer.item.home'.tr),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.moodGood),
            title: Text('drawer.item.profile.title'.tr),
            subtitle: Text('drawer.item.profile.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.profile);
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_graph, color: AppColors.moodExcellent),
            title: Text('drawer.item.reflections.title'.tr),
            subtitle: Text('drawer.item.reflections.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.reflections);
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: AppColors.moodNeutral),
            title: Text('drawer.item.journal.title'.tr),
            subtitle: Text('drawer.item.journal.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.journal);
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: AppColors.moodDifficult),
            title: Text('drawer.item.wordcloud.title'.tr),
            subtitle: Text('drawer.item.wordcloud.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.wordCloud);
            },
          ),

          // Sección de Herramientas
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              'drawer.section.tools'.tr,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.backup, color: AppColors.moodNeutral),
            title: Text('drawer.item.backup.title'.tr),
            subtitle: Text('drawer.item.backup.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.backup);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: AppColors.moodDifficult),
            title: Text('drawer.item.security.title'.tr),
            subtitle: Text('drawer.item.security.subtitle'.tr),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.securitySettings);
            },
          ),

          // Sección de Información
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              'drawer.section.info'.tr,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: Text('drawer.item.about.title'.tr),
            subtitle: Text('drawer.item.about.subtitle'.tr),
            onTap: () {
              Get.back();
              _showAboutDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.orange),
            title: Text('drawer.item.help.title'.tr),
            subtitle: Text('drawer.item.help.subtitle'.tr),
            onTap: () {
              Get.back();
              _showHelpDialog();
            },
          ),

          // Separador visual antes de la versión
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(thickness: 1),
          ),

          // Información de versión
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '...';
              final buildNumber = snapshot.data?.buildNumber ?? '...';
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/moodgrid.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EmotionsMap',
                      style: Get.textTheme.titleSmall?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'drawer.version'.trParams({
                        'version': version,
                        'build': buildNumber,
                      }),
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/moodgrid.png',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('about.title'.tr),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'about.description'.tr,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'about.features.title'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.moodExcellent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'about.features.bullets'.tr,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('common.close'.tr),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.orange),
            const SizedBox(width: 12),
            Text('help.title'.tr),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpSection(
                'help.section.log.title'.tr,
                'help.section.log.body'.tr,
              ),
              const SizedBox(height: 12),
              _buildHelpSection(
                'help.section.colors.title'.tr,
                'help.section.colors.body'.tr,
              ),
              const SizedBox(height: 12),
              _buildHelpSection(
                'help.section.comments.title'.tr,
                'help.section.comments.body'.tr,
              ),
              const SizedBox(height: 12),
              _buildHelpSection(
                'help.section.views.title'.tr,
                'help.section.views.body'.tr,
              ),
              const SizedBox(height: 12),
              _buildHelpSection(
                'help.section.export.title'.tr,
                'help.section.export.body'.tr,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('help.button.understood'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.moodExcellent,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(height: 1.5),
        ),
      ],
    );
  }

  String _getUserInitial() {
    final authController = Get.find<AuthController>();
    final email = authController.user?.email ?? '';
    if (email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }
}
