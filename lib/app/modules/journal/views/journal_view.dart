import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/modules/journal/controllers/journal_controller.dart';

class JournalView extends GetView<JournalController> {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Diario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadJournalEntries(),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.journalEntries.isEmpty) {
          return _buildEmptyState();
        }

        return _buildJournalList();
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Tu diario está vacío',
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega comentarios a tus registros de ánimo para verlos aquí como un diario personal.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.grid_on),
              label: const Text('Ir a la cuadrícula'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalList() {
    return RefreshIndicator(
      onRefresh: () => controller.loadJournalEntries(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.journalEntries.length,
        itemBuilder: (context, index) {
          final entry = controller.journalEntries[index];
          return _buildJournalCard(entry);
        },
      ),
    );
  }

  Widget _buildJournalCard(DailyRecord entry) {
    final moodColor = controller.getMoodColor(entry.colorIndex);
    final moodText = controller.getMoodText(entry.colorIndex);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => controller.showRecordDialog(entry.date),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: moodColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: moodColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.formatDate(entry.date),
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: moodColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      moodText,
                      style: TextStyle(
                        color: moodColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.comment ?? '',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Toca para editar',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
