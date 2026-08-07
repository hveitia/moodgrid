import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/services/ads_service.dart';
import 'package:moodgrid/app/core/services/analytics_service.dart';
import 'package:moodgrid/app/core/utils/date_format_helper.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
import 'package:moodgrid/app/modules/home/widgets/month_export_widget.dart';
import 'package:moodgrid/app/modules/home/widgets/month_chart_export_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class HomeController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Observables
  final RxList<DailyRecord> records = <DailyRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedDate = ''.obs;
  final RxBool isChartView = false.obs;

  // Mapa de registros por fecha para acceso rápido
  final RxMap<String, DailyRecord> recordsMap = <String, DailyRecord>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  // Cambiar entre vista de cuadrícula y gráfico
  void toggleView(bool showChart) {
    isChartView.value = showChart;
  }

  // Cargar todos los registros
  Future<void> loadRecords() async {
    try {
      isLoading.value = true;
      final allRecords = await _databaseHelper.getAllRecords();
      records.value = allRecords;

      // Construir mapa para acceso rápido
      recordsMap.clear();
      for (final record in allRecords) {
        final dateKey = _getDateKey(record.date);
        recordsMap[dateKey] = record;
      }
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'home.error.load'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Obtener clave de fecha (YYYY-MM-DD)
  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Obtener registro por fecha
  DailyRecord? getRecordForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return recordsMap[dateKey];
  }

  // Guardar o actualizar un registro
  Future<void> saveRecord({
    required DateTime date,
    required int colorIndex,
    String? comment,
  }) async {
    try {
      isLoading.value = true;

      final existingRecord = getRecordForDate(date);

      if (existingRecord != null) {
        // Actualizar registro existente
        final updatedRecord = existingRecord.copyWith(
          colorIndex: colorIndex,
          comment: comment,
        );
        await _databaseHelper.updateRecord(updatedRecord);
      } else {
        // Crear nuevo registro
        final newRecord = DailyRecord(
          date: date,
          colorIndex: colorIndex,
          comment: comment,
        );
        await _databaseHelper.insertRecord(newRecord);
      }

      // Recargar registros
      await loadRecords();

      appSnackBar(
        title: 'common.success'.tr,
        message: 'home.snack.saved'.tr,
        kind: AppSnackKind.success,
        duration: const Duration(seconds: 2),
      );

      // Interstitial solo tras escribir una reflexion nueva o editada,
      // nunca tras el registro rapido de mood. Respeta el cap del servicio.
      final wroteReflection = comment != null &&
          comment.trim().isNotEmpty &&
          comment != existingRecord?.comment;

      unawaited(AnalyticsService.instance.logMoodLogged(
        colorIndex: colorIndex,
        hasComment: comment != null && comment.trim().isNotEmpty,
        isUpdate: existingRecord != null,
      ));
      if (wroteReflection) {
        unawaited(AnalyticsService.instance
            .logReflectionSaved(length: comment.trim().length));
      }

      if (wroteReflection) {
        await AdsService.instance.showInterstitialIfAllowed();
      }
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'home.error.save'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar un registro
  Future<void> deleteRecord(DateTime date) async {
    try {
      isLoading.value = true;
      await _databaseHelper.deleteRecordByDate(date);
      await loadRecords();

      unawaited(AnalyticsService.instance.logMoodDeleted());

      appSnackBar(
        title: 'common.success'.tr,
        message: 'home.snack.deleted'.tr,
        kind: AppSnackKind.warning,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'home.error.delete'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Exportar datos
  Future<void> exportData() async {
    try {
      isLoading.value = true;
      final file = await _databaseHelper.saveBackupToFile();

      // Primero terminar el loading antes de mostrar el diálogo de compartir
      isLoading.value = false;

      unawaited(
          AnalyticsService.instance.logDataExported(recordCount: records.length));

      // Compartir archivo
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'home.share.backup.subject'.tr,
          text: 'home.share.backup.text'.tr,
        ),
      );
    } catch (e) {
      isLoading.value = false;
      appSnackBar(
        title: 'common.error'.tr,
        message: 'home.error.export'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    }
  }

  // Importar datos
  Future<void> importData() async {
    try {
      // Seleccionar archivo
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      isLoading.value = true;
      final file = File(result.files.single.path!);
      final importedCount = await _databaseHelper.importFromFile(file);

      await loadRecords();

      unawaited(AnalyticsService.instance
          .logDataImported(recordCount: importedCount));

      appSnackBar(
        title: 'common.success'.tr,
        message: 'home.snack.imported.one'.trPluralParams(
          'home.snack.imported.other',
          importedCount,
          {'count': '$importedCount'},
        ),
        kind: AppSnackKind.success,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'home.error.import'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Obtener estadísticas
  Future<Map<int, int>> getMoodStatistics() async {
    return await _databaseHelper.getMoodStatistics();
  }

  // Verificar si hay registros en un mes
  bool hasRecordsInMonth(DateTime month) {
    return records.any((record) =>
        record.date.year == month.year && record.date.month == month.month);
  }

  // Mostrar diálogo de selección de exportación
  void showExportDialog({
    required DateTime month,
    required List<DateTime> weeks,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home.export.title'.tr,
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.grid_on, color: Colors.blue),
              title: Text('home.export.grid.title'.tr),
              subtitle: Text('home.export.grid.subtitle'.tr),
              onTap: () {
                Get.back();
                exportMonthAsImage(
                  month: month,
                  weeks: weeks,
                  exportType: 'grid',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart, color: Colors.green),
              title: Text('home.export.chart.title'.tr),
              subtitle: Text('home.export.chart.subtitle'.tr),
              onTap: () {
                Get.back();
                exportMonthAsImage(
                  month: month,
                  weeks: weeks,
                  exportType: 'chart',
                );
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('common.cancel'.tr),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  // Exportar mes como imagen
  Future<void> exportMonthAsImage({
    required DateTime month,
    required List<DateTime> weeks,
    String exportType = 'grid',
  }) async {
    try {
      isLoading.value = true;

      // Mostrar diálogo de loading
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
                      'home.exporting.title'.tr,
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'home.exporting.subtitle'.tr,
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

      // Crear controller de screenshot
      final screenshotController = ScreenshotController();

      // Calcular rangeStartDate
      DateTime rangeStartDate;
      if (records.isNotEmpty) {
        final firstRecord = records.last;
        rangeStartDate =
            DateTime(firstRecord.date.year, firstRecord.date.month, 1);
      } else {
        final now = DateTime.now();
        rangeStartDate = DateTime(now.year, now.month, 1);
      }

      // Seleccionar widget según el tipo de exportación
      Widget exportWidget;
      if (exportType == 'chart') {
        exportWidget = MonthChartExportWidget(
          month: month,
          recordsMap: recordsMap,
        );
      } else {
        exportWidget = MonthExportWidget(
          month: month,
          weeks: weeks,
          recordsMap: recordsMap,
          rangeStartDate: rangeStartDate,
        );
      }

      // Capturar widget
      final Uint8List imageBytes =
          await screenshotController.captureFromWidget(
        exportWidget,
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 300),
      );

      // Guardar en archivo temporal
      final tempDir = await getTemporaryDirectory();
      final monthName = appDateFormat(month, 'MMMM');
      final exportTypeName = exportType == 'chart' ? 'chart' : 'grid';
      final fileName = 'emotionsmap_${monthName}_${month.year}_$exportTypeName.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Cerrar diálogo de loading
      Get.back();

      // Compartir archivo
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'home.share.month.subject'.trParams({
            'month': monthName,
            'year': '${month.year}',
          }),
          text: 'home.share.month.text'.trParams({
            'month': monthName,
            'year': '${month.year}',
          }),
        ),
      );

      // Mostrar interstitial si está cargado y el cap de frecuencia lo permite.
      // El usuario acaba de completar una acción de "valor recibido" (export +
      // share), es el momento de menor fricción para mostrarlo.
      await AdsService.instance.showInterstitialIfAllowed();

      // No mostramos snackbar de éxito porque el diálogo de compartir ya da feedback
    } catch (e) {
      // Cerrar diálogo de loading si está abierto
      try {
        Get.back();
      } catch (_) {}

      // Solo mostramos error si falla antes de compartir
      try {
        appSnackBar(
          title: 'common.error'.tr,
          message: 'home.error.export_image'.trParams({'e': '$e'}),
          kind: AppSnackKind.error,
        );
      } catch (_) {
        // Si el snackbar también falla, ignoramos el error
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Mostrar diálogo de registro
  void showRecordDialog(DateTime date) {
    selectedDate.value = _getDateKey(date);
    final existingRecord = getRecordForDate(date);

    int? selectedMoodIndex = existingRecord?.colorIndex;
    final TextEditingController commentController = TextEditingController(
      text: existingRecord?.comment ?? '',
    );

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Título con botón eliminar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        appDateFormat(date, 'EEEE, d MMMM yyyy'),
                        style: Get.textTheme.titleLarge,
                      ),
                    ),
                    if (existingRecord != null)
                      IconButton(
                        onPressed: () {
                          Get.back();
                          deleteRecord(date);
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        tooltip: 'home.record.tooltip.delete'.tr,
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Selección de estado de ánimo
                Text(
                  'home.record.title'.tr,
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                // Botones de estados de ánimo
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(5, (index) {
                    final emojis = [
                      '😄',
                      '🙂',
                      '😐',
                      '😕',
                      '😢'
                    ];
                    final isSelected = selectedMoodIndex == index;
                    final moodColor = AppColors.getMoodColor(index);

                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppColors.getMoodText(index)),
                          const SizedBox(width: 8),
                          Text(emojis[index]),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedMoodIndex = selected ? index : null;
                        });
                      },
                      selectedColor: moodColor,
                      backgroundColor: moodColor.withValues(alpha: 0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Campo de comentario
                Text(
                  'home.record.comment.label'.tr,
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'home.record.comment.hint'.tr,
                  ),
                ),
                const SizedBox(height: 24),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('common.cancel'.tr),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: selectedMoodIndex == null
                          ? null
                          : () {
                              Get.back();
                              saveRecord(
                                date: date,
                                colorIndex: selectedMoodIndex!,
                                comment: commentController.text.isEmpty
                                    ? null
                                    : commentController.text,
                              );
                            },
                      child: Text('home.record.button.save'.tr),
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}
