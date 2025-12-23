import 'package:flutter/material.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';

class BiometricButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const BiometricButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: isLoading ? null : onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.moodExcellent.withValues(alpha: 0.2),
              border: Border.all(
                color: AppColors.moodExcellent,
                width: 2,
              ),
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: AppColors.moodExcellent,
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isLoading ? 'Autenticando...' : 'Usar biometría',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
