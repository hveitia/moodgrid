import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
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

      Get.snackbar(
        'Éxito',
        'Backup guardado en: ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Compartir archivo
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'MoodGrid Backup',
        text: 'Respaldo de mis registros de MoodGrid',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al exportar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
                // Título
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(date),
                  style: Get.textTheme.titleLarge,
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

                    return ChoiceChip(
                      label: Text(moods[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedMoodIndex = selected ? index : null;
                        });
                      },
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (existingRecord != null)
                      TextButton.icon(
                        onPressed: () {
                          Get.back();
                          deleteRecord(date);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      )
                    else
                      const SizedBox(),
                    Row(
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
