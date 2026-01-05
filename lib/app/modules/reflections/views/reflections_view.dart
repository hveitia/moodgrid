import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/modules/reflections/controllers/reflections_controller.dart';
import 'package:moodgrid/app/modules/reflections/widgets/year_in_pixels_widget.dart';

class ReflectionsView extends GetView<ReflectionsController> {
  const ReflectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Reflexión'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadStatistics,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildYearInPixels(),
              const SizedBox(height: 16),
              Obx(() => controller.hasComments
                  ? _buildStatsContent()
                  : _buildNoCommentsMessage()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.moodGood.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.edit_note_rounded,
                color: AppColors.moodGood,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tus Reflexiones',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Análisis de tus comentarios y hábitos de escritura',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearInPixels() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: controller.previousYear,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Año anterior',
            ),
            Obx(() => Text(
              '${controller.selectedYear.value}',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )),
            Obx(() => IconButton(
              onPressed: controller.selectedYear.value < DateTime.now().year
                  ? controller.nextYear
                  : null,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Año siguiente',
            )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final _ = controller.yearRecordsMap.length;
          return YearInPixelsWidget(
            year: controller.selectedYear.value,
            recordsMap: Map<String, DailyRecord>.from(controller.yearRecordsMap),
            onExport: controller.exportYearAsImage,
          );
        }),
      ],
    );
  }

  Widget _buildStatsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainStats(),
        const SizedBox(height: 16),
        _buildStreakCard(),
        const SizedBox(height: 16),
        _buildTopMonthCard(),
      ],
    );
  }

  Widget _buildMainStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    icon: Icons.comment,
                    value: controller.totalDaysWithComments.value.toString(),
                    label: 'Días con\ncomentarios',
                    color: AppColors.moodGood,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    icon: Icons.percent,
                    value: '${controller.commentPercentage.value.toStringAsFixed(1)}%',
                    label: 'De días\nregistrados',
                    color: AppColors.moodExcellent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    icon: Icons.text_fields,
                    value: controller.averageCommentLength.value.toStringAsFixed(1),
                    label: 'Palabras\npromedio',
                    color: AppColors.moodNeutral,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    icon: Icons.note_alt,
                    value: controller.totalRecords.value.toString(),
                    label: 'Total días\nregistrados',
                    color: AppColors.moodGood,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: AppColors.moodDifficult),
                const SizedBox(width: 8),
                Text(
                  'Rachas de Escritura',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStreakItem(
                    title: 'Racha Actual',
                    value: controller.currentStreak.value,
                    icon: Icons.trending_up,
                    color: AppColors.moodDifficult,
                    isActive: controller.currentStreak.value > 0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStreakItem(
                    title: 'Mejor Racha',
                    value: controller.longestStreak.value,
                    icon: Icons.emoji_events,
                    color: AppColors.moodExcellent,
                    isActive: true,
                  ),
                ),
              ],
            ),
            if (controller.currentStreak.value > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.moodExcellent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: AppColors.moodExcellent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.currentStreak.value >= controller.longestStreak.value
                            ? '¡Estás en tu mejor racha!'
                            : '¡Sigue así! Te faltan ${controller.longestStreak.value - controller.currentStreak.value} días para tu récord.',
                        style: TextStyle(
                          color: AppColors.moodExcellent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStreakItem({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.3) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? color : Colors.grey[400],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: Get.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive ? color : Colors.grey[400],
            ),
          ),
          Text(
            value == 1 ? 'día' : 'días',
            style: TextStyle(
              color: isActive ? color : Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopMonthCard() {
    final month = controller.topCommentMonth.value;
    final count = controller.topCommentMonthCount.value;

    if (month.isEmpty) return const SizedBox.shrink();

    final capitalizedMonth = month.isNotEmpty
        ? month[0].toUpperCase() + month.substring(1)
        : month;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.moodGood),
                const SizedBox(width: 8),
                Text(
                  'Mes Más Productivo',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.moodGood.withValues(alpha: 0.1),
                    AppColors.moodExcellent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.moodExcellent,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    capitalizedMonth,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count ${count == 1 ? 'comentario' : 'comentarios'}',
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: AppColors.moodExcellent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoCommentsMessage() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: AppColors.moodNeutral,
            ),
            const SizedBox(height: 24),
            Text(
              'Empieza a Reflexionar',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agregar comentarios a tus registros te ayuda a reflexionar sobre tus emociones y descubrir patrones en tu bienestar.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.moodExcellent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: AppColors.moodExcellent,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca cualquier día en la cuadrícula para agregar un comentario sobre cómo te sentiste.',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppColors.moodExcellent,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
}
