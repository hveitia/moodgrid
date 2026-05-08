import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/utils/date_format_helper.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';

class JournalController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final RxList<DailyRecord> journalEntries = <DailyRecord>[].obs;
  final RxList<DailyRecord> filteredEntries = <DailyRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadJournalEntries();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  Future<void> loadJournalEntries() async {
    try {
      isLoading.value = true;
      final entries = await _databaseHelper.getRecordsWithComments();
      journalEntries.value = entries;
      _applySearch();
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'journal.error.load'.trParams({'e': '$e'}),
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query.trim();
      _applySearch();
    });
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredEntries.value = journalEntries;
      return;
    }

    final query = searchQuery.value.toLowerCase();
    filteredEntries.value = journalEntries.where((entry) {
      final comment = entry.comment?.toLowerCase() ?? '';
      return comment.contains(query);
    }).toList();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applySearch();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      clearSearch();
    }
  }

  int get resultCount => filteredEntries.length;

  bool get hasSearchQuery => searchQuery.value.isNotEmpty;

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
                            tooltip: 'home.record.tooltip.delete'.tr,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'home.record.title'.tr,
                      style: Get.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(5, (index) {
                        final emojis = ['😄', '🙂', '😐', '😕', '😢'];
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

  String formatDate(DateTime date) {
    return appDateFormat(date, 'EEEE, d MMMM yyyy');
  }

  String formatShortDate(DateTime date) {
    return appDateFormat(date, 'd MMM yyyy');
  }

  Color getMoodColor(int colorIndex) {
    return AppColors.getMoodColor(colorIndex);
  }

  String getMoodText(int colorIndex) {
    return AppColors.getMoodText(colorIndex);
  }
}
