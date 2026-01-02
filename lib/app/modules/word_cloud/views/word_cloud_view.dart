import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/word_cloud_item.dart';
import 'package:moodgrid/app/modules/word_cloud/controllers/word_cloud_controller.dart';

class WordCloudView extends GetView<WordCloudController> {
  const WordCloudView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nube de Palabras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'Información',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasEnoughData) {
          return _buildEmptyState();
        }

        return _buildContent();
      }),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCard(),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 16),
          _buildWordCloud(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.comment,
              value: controller.totalComments.value.toString(),
              label: 'Comentarios',
            ),
            _buildStatItem(
              icon: Icons.text_fields,
              value: controller.totalWords.value.toString(),
              label: 'Palabras',
            ),
            _buildStatItem(
              icon: Icons.cloud,
              value: controller.wordCloudItems.length.toString(),
              label: 'Únicas',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.moodExcellent, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leyenda de colores',
                style: Get.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: List.generate(5, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.getMoodColor(index),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
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
      ),
    );
  }

  Widget _buildWordCloud() {
    final items = controller.wordCloudItems;
    final maxFreq = controller.maxFrequency;

    // Shuffle items for visual variety while maintaining reproducibility
    final shuffledItems = List<WordCloudItem>.from(items);
    shuffledItems.shuffle(math.Random(42));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Palabras más frecuentes',
              style: Get.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: shuffledItems.map((item) {
                return _buildWordChip(item, maxFreq);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordChip(WordCloudItem item, int maxFrequency) {
    final fontSize = item.getFontSize(
      maxFrequency: maxFrequency,
      minSize: 12,
      maxSize: 32,
    );

    return GestureDetector(
      onTap: () => _showWordDetails(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          item.word,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: _getTextColor(item.color),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    // Darken the color for better readability
    final hsl = HSLColor.fromColor(backgroundColor);
    return hsl.withLightness((hsl.lightness * 0.5).clamp(0.0, 1.0)).toColor();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Sin suficientes datos',
              style: Get.textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega comentarios a tus registros de ánimo para ver una nube de palabras con los temas más frecuentes.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Las palabras deben aparecer al menos 2 veces para mostrarse.',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWordDetails(WordCloudItem item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.word,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              'Apariciones',
              '${item.frequency} veces',
              Icons.repeat,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Ánimo promedio',
              item.moodText,
              Icons.mood,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Valor promedio',
              item.averageMood.toStringAsFixed(2),
              Icons.analytics,
            ),
            const SizedBox(height: 16),
            Text(
              'Distribución de ánimos',
              style: Get.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _buildMoodDistribution(item),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMoodDistribution(WordCloudItem item) {
    // Count occurrences of each mood
    final distribution = <int, int>{};
    for (final mood in item.moodIndices) {
      if (mood >= 0 && mood <= 4) {
        distribution[mood] = (distribution[mood] ?? 0) + 1;
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(5, (index) {
        final count = distribution[index] ?? 0;
        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.getMoodColor(index).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.getMoodColor(index),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(AppColors.getMoodColor(index)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showInfoDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.cloud, color: AppColors.moodExcellent),
            const SizedBox(width: 12),
            const Text('Nube de Palabras'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'La nube de palabras muestra los términos más frecuentes en tus comentarios.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Interpretación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Tamaño: indica la frecuencia de la palabra.\n'
              '• Color: representa el ánimo promedio asociado.\n'
              '• Toca una palabra para ver más detalles.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Se filtran palabras comunes (artículos, preposiciones, etc.) para mostrar solo términos significativos.',
              style: TextStyle(
                height: 1.5,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
