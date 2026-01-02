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
        title: Obx(() => controller.isSearching.value
            ? _buildSearchField()
            : const Text('Mi Diario')),
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isSearching.value ? Icons.close : Icons.search),
                onPressed: controller.toggleSearch,
                tooltip: controller.isSearching.value ? 'Cerrar búsqueda' : 'Buscar',
              )),
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

        return Column(
          children: [
            // Contador de resultados
            if (controller.hasSearchQuery) _buildResultsCounter(),
            // Lista de entradas
            Expanded(
              child: controller.filteredEntries.isEmpty
                  ? _buildNoResultsState()
                  : _buildJournalList(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Buscar en comentarios...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: controller.clearSearch,
              )
            : const SizedBox.shrink()),
      ),
      style: const TextStyle(fontSize: 16),
      onChanged: controller.onSearchChanged,
    );
  }

  Widget _buildResultsCounter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.moodExcellent.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 18,
            color: AppColors.moodExcellent,
          ),
          const SizedBox(width: 8),
          Obx(() => Text(
                '${controller.resultCount} ${controller.resultCount == 1 ? 'día encontrado' : 'días encontrados'}',
                style: TextStyle(
                  color: AppColors.moodExcellent,
                  fontWeight: FontWeight.w600,
                ),
              )),
          const Spacer(),
          Obx(() => Text(
                '"${controller.searchQuery.value}"',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Sin resultados',
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
                  'No se encontraron comentarios con "${controller.searchQuery.value}"',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: controller.clearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar búsqueda'),
            ),
          ],
        ),
      ),
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
      child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = controller.filteredEntries[index];
              return _buildJournalCard(entry);
            },
          )),
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
                      child: Obx(() => _buildHighlightedText(
                            entry.comment ?? '',
                            controller.searchQuery.value,
                          )),
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

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: Get.textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: AppColors.textPrimary,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Texto antes de la coincidencia
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            height: 1.5,
            color: AppColors.textPrimary,
          ),
        ));
      }

      // Texto resaltado
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          height: 1.5,
          color: AppColors.textPrimary,
          backgroundColor: AppColors.moodNeutral.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Texto restante después de la última coincidencia
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          height: 1.5,
          color: AppColors.textPrimary,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
