import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/locale_service.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/core/widgets/language_sheet.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Obx(() {
                  final isSpanish = LocaleService
                          .instance.currentLocaleRx.value.languageCode ==
                      'es';
                  return TextButton.icon(
                    onPressed: () => showLanguageSheet(context),
                    icon: Icon(
                      Icons.language,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    label: Text(
                      isSpanish ? 'ES' : 'EN',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),

              Image.asset(
                'assets/moodgrid.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),

              Text(
                'EmotionsMap',
                style: Get.textTheme.displayLarge?.copyWith(
                  color: AppColors.moodExcellent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'landing.tagline'.tr,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () => Get.toNamed(Routes.login),
                child: Text('landing.button.signin'.tr),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.register),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.moodExcellent, width: 2),
                  foregroundColor: AppColors.moodExcellent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('landing.button.signup'.tr),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
