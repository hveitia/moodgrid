import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
import 'package:moodgrid/app/modules/home/widgets/month_export_widget.dart';
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

  // Mapa de registros por fecha para acceso rápido
  final RxMap<String, DailyRecord> recordsMap = <String, DailyRecord>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecords();
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
      Get.snackbar(
        'Error',
        'Error al cargar registros: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
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

      Get.snackbar(
        'Éxito',
        'Registro guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar registro: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
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

      Get.snackbar(
        'Éxito',
        'Registro eliminado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al eliminar registro: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
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

      // Compartir archivo
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'MoodGrid Backup',
          text: 'Respaldo de mis registros de MoodGrid',
        ),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error al exportar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
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

      Get.snackbar(
        'Éxito',
        'Se importaron $importedCount registros',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al importar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
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

  // Exportar mes como imagen
  Future<void> exportMonthAsImage({
    required DateTime month,
    required List<DateTime> weeks,
  }) async {
    try {
      isLoading.value = true;

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

      // Capturar widget
      final Uint8List imageBytes =
          await screenshotController.captureFromWidget(
        MonthExportWidget(
          month: month,
          weeks: weeks,
          recordsMap: recordsMap,
          rangeStartDate: rangeStartDate,
        ),
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 10),
      );

      // Guardar en archivo temporal
      final tempDir = await getTemporaryDirectory();
      final monthName = DateFormat('MMMM', 'es_ES').format(month);
      final fileName = 'moodgrid_${monthName}_${month.year}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Compartir archivo
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'MoodGrid - $monthName ${month.year}',
          text: 'Mi registro de estado de ánimo de $monthName ${month.year}',
        ),
      );

      Get.snackbar(
        'Éxito',
        'Imagen exportada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al exportar imagen: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
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
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
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
                        DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(date),
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
                        tooltip: 'Eliminar registro',
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Selección de estado de ánimo
                Text(
                  '¿Cómo te sentiste?',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                // Botones de estados de ánimo
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(5, (index) {
                    final moods = [
                      'Excelente',
                      'Bien',
                      'Neutral',
                      'Difícil',
                      'Mal'
                    ];
                    final isSelected = selectedMoodIndex == index;
                    final moodColor = AppColors.getMoodColor(index);

                    return ChoiceChip(
                      label: Text(moods[index]),
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
                  'Comentario (opcional)',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un comentario...',
                  ),
                ),
                const SizedBox(height: 24),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancelar'),
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
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}
