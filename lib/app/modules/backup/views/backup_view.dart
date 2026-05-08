import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/core/widgets/ad_banner.dart';
import 'package:moodgrid/app/modules/home/controllers/home_controller.dart';

class BackupView extends StatelessWidget {
  const BackupView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('backup.title'.tr),
      ),
      bottomNavigationBar: const AdBanner(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.backup,
              size: 80,
              color: AppColors.moodExcellent,
            ),
            const SizedBox(height: 24),

            Text(
              'backup.heading'.tr,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'backup.subheading'.tr,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.file_upload,
                          color: AppColors.moodExcellent,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'backup.export.title'.tr,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'backup.export.subtitle'.tr,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: homeController.exportData,
                        icon: const Icon(Icons.file_upload),
                        label: Text('backup.export.button'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.file_download,
                          color: AppColors.moodGood,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'backup.import.title'.tr,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'backup.import.subtitle'.tr,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: homeController.importData,
                        icon: const Icon(Icons.file_download),
                        label: Text('backup.import.button'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.moodGood,
                          side: BorderSide(color: AppColors.moodGood, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.moodNeutral.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'backup.note'.tr,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
}
