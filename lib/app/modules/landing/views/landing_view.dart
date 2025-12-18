import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
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
              const Spacer(),

              Icon(
                Icons.grid_4x4,
                size: 100,
                color: AppColors.moodExcellent,
              ),
              const SizedBox(height: 24),

              Text(
                'MoodGrid',
                style: Get.textTheme.displayLarge?.copyWith(
                  color: AppColors.moodExcellent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Registra tu estado de ánimo día a día y visualiza patrones en tu bienestar emocional',
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () => Get.toNamed(Routes.login),
                child: const Text('Iniciar Sesión'),
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
                child: const Text('Crear Cuenta'),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
