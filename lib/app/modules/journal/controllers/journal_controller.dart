import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';

class JournalController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final RxList<DailyRecord> journalEntries = <DailyRecord>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadJournalEntries();
  }

  Future<void> loadJournalEntries() async {
    try {
      isLoading.value = true;
      final entries = await _databaseHelper.getRecordsWithComments();
      journalEntries.value = entries;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar el diario: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showRecordDialog(DateTime date) {
    final homeController = Get.find<HomeController>();
    final existingRecord = homeController.getRecordForDate(date);

    int? selectedMoodIndex = existingRecord?.colorIndex;
    final TextEditingController commentController = TextEditingController(
      text: existingRecord?.comment ?? '',
    );

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            formatDate(date),
                            style: Get.textTheme.titleLarge,
                          ),
                        ),
                        if (existingRecord != null)
                          IconButton(
                            onPressed: () async {
                              Get.back();
                              await homeController.deleteRecord(date);
                              await loadJournalEntries();
                            },
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            tooltip: 'Eliminar registro',
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¿Cómo te sentiste?',
                      style: Get.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(5, (index) {
                        final moods = ['Excelente', 'Bien', 'Neutral', 'Difícil', 'Mal'];
                        final emojis = ['😄', '🙂', '😐', '😕', '😢'];
                        final isSelected = selectedMoodIndex == index;
                        final moodColor = AppColors.getMoodColor(index);

                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(moods[index]),
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
                              : () async {
                                  Get.back();
                                  await homeController.saveRecord(
                                    date: date,
                                    colorIndex: selectedMoodIndex!,
                                    comment: commentController.text.isEmpty
                                        ? null
                                        : commentController.text,
                                  );
                                  await loadJournalEntries();
                                },
                          child: const Text('Guardar'),
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

  String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(date);
  }

  String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'es_ES').format(date);
  }

  Color getMoodColor(int colorIndex) {
    return AppColors.getMoodColor(colorIndex);
  }

  String getMoodText(int colorIndex) {
    return AppColors.getMoodText(colorIndex);
  }
}
