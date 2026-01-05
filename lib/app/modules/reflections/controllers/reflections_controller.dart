import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
import 'package:moodgrid/app/modules/reflections/widgets/year_in_pixels_export_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ReflectionsController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final RxBool isLoading = false.obs;
  final RxInt totalRecords = 0.obs;

  // Estadísticas de reflexión (comentarios)
  final RxInt totalDaysWithComments = 0.obs;
  final RxDouble commentPercentage = 0.0.obs;
  final RxDouble averageCommentLength = 0.0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt longestStreak = 0.obs;
  final RxString topCommentMonth = ''.obs;
  final RxInt topCommentMonthCount = 0.obs;

  // Año en píxeles
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxMap<String, DailyRecord> yearRecordsMap = <String, DailyRecord>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
    loadYearRecords();
  }

  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;
      final total = await _databaseHelper.getTotalRecordsCount();
      final recordsWithComments = await _databaseHelper.getRecordsWithComments();

      totalRecords.value = total;
      _calculateCommentStatistics(recordsWithComments, total);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar estadísticas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateCommentStatistics(List<DailyRecord> recordsWithComments, int total) {
    // Total de días con comentarios
    totalDaysWithComments.value = recordsWithComments.length;

    // Porcentaje de días con comentario
    if (total > 0) {
      commentPercentage.value = (recordsWithComments.length / total) * 100;
    } else {
      commentPercentage.value = 0.0;
    }

    // Promedio de longitud de comentarios (en palabras)
    if (recordsWithComments.isNotEmpty) {
      int totalWords = 0;
      for (final record in recordsWithComments) {
        if (record.comment != null && record.comment!.isNotEmpty) {
          totalWords += record.comment!.split(RegExp(r'\s+')).length;
        }
      }
      averageCommentLength.value = totalWords / recordsWithComments.length;
    } else {
      averageCommentLength.value = 0.0;
    }

    // Calcular rachas
    _calculateStreaks(recordsWithComments);

    // Mes con más comentarios
    _calculateTopMonth(recordsWithComments);
  }

  void _calculateStreaks(List<DailyRecord> recordsWithComments) {
    if (recordsWithComments.isEmpty) {
      currentStreak.value = 0;
      longestStreak.value = 0;
      return;
    }

    // Ordenar por fecha descendente (más reciente primero)
    final sortedRecords = List<DailyRecord>.from(recordsWithComments);
    sortedRecords.sort((a, b) => b.date.compareTo(a.date));

    // Crear un set de fechas con comentarios para búsqueda rápida
    final datesWithComments = <String>{};
    for (final record in sortedRecords) {
      datesWithComments.add(_dateToString(record.date));
    }

    // Calcular racha actual (desde hoy hacia atrás)
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    int current = 0;

    // Empezar desde hoy o ayer si hoy no tiene comentario
    DateTime checkDate = todayDate;
    if (!datesWithComments.contains(_dateToString(checkDate))) {
      checkDate = todayDate.subtract(const Duration(days: 1));
    }

    while (datesWithComments.contains(_dateToString(checkDate))) {
      current++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    currentStreak.value = current;

    // Calcular racha más larga histórica
    int longest = 0;
    int tempStreak = 0;
    DateTime? lastDate;

    // Ordenar por fecha ascendente para calcular rachas históricas
    sortedRecords.sort((a, b) => a.date.compareTo(b.date));

    for (final record in sortedRecords) {
      final recordDate = DateTime(record.date.year, record.date.month, record.date.day);

      if (lastDate == null) {
        tempStreak = 1;
      } else {
        final difference = recordDate.difference(lastDate).inDays;
        if (difference == 1) {
          tempStreak++;
        } else {
          if (tempStreak > longest) {
            longest = tempStreak;
          }
          tempStreak = 1;
        }
      }
      lastDate = recordDate;
    }

    if (tempStreak > longest) {
      longest = tempStreak;
    }

    longestStreak.value = longest;
  }

  void _calculateTopMonth(List<DailyRecord> recordsWithComments) {
    if (recordsWithComments.isEmpty) {
      topCommentMonth.value = '';
      topCommentMonthCount.value = 0;
      return;
    }

    final monthCounts = <String, int>{};

    for (final record in recordsWithComments) {
      final monthKey = DateFormat('yyyy-MM').format(record.date);
      monthCounts[monthKey] = (monthCounts[monthKey] ?? 0) + 1;
    }

    String topMonth = '';
    int maxCount = 0;

    for (final entry in monthCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        topMonth = entry.key;
      }
    }

    if (topMonth.isNotEmpty) {
      final parts = topMonth.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final date = DateTime(year, month, 1);
      topCommentMonth.value = DateFormat('MMMM yyyy', 'es_ES').format(date);
      topCommentMonthCount.value = maxCount;
    }
  }

  String _dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, date.day));
  }

  bool get hasComments => totalDaysWithComments.value > 0;

  Future<void> loadYearRecords() async {
    try {
      final startDate = DateTime(selectedYear.value, 1, 1);
      final endDate = DateTime(selectedYear.value, 12, 31);
      final records = await _databaseHelper.getRecordsByDateRange(startDate, endDate);

      final newMap = <String, DailyRecord>{};
      for (final record in records) {
        final dateKey = DateFormat('yyyy-MM-dd').format(record.date);
        newMap[dateKey] = record;
      }
      yearRecordsMap.assignAll(newMap);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar datos del año',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void changeYear(int year) {
    selectedYear.value = year;
    loadYearRecords();
  }

  void previousYear() {
    changeYear(selectedYear.value - 1);
  }

  void nextYear() {
    if (selectedYear.value < DateTime.now().year) {
      changeYear(selectedYear.value + 1);
    }
  }

  Future<void> exportYearAsImage() async {
    try {
      isLoading.value = true;

      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.moodExcellent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.moodExcellent,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Preparando exportación...',
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esto tomará un momento',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final screenshotController = ScreenshotController();

      final exportWidget = YearInPixelsExportWidget(
        year: selectedYear.value,
        recordsMap: Map<String, DailyRecord>.from(yearRecordsMap),
      );

      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        exportWidget,
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 300),
      );

      final tempDir = await getTemporaryDirectory();
      final fileName = 'moodgrid_año_${selectedYear.value}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      Get.back();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Feelmap - Mi Año en Píxeles ${selectedYear.value}',
          text: 'Mi registro de estado de ánimo del año ${selectedYear.value}',
        ),
      );
    } catch (e) {
      try {
        Get.back();
      } catch (_) {}

      try {
        Get.snackbar(
          'Error',
          'Error al exportar imagen: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      } catch (_) {}
    } finally {
      isLoading.value = false;
    }
  }
}
