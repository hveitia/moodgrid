import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  AppColors._();

  // Mood Colors - Paleta de Salud Mental (Muted)
  static const Color moodExcellent = Color(0xFF88B486); // Verde salvia
  static const Color moodGood = Color(0xFF90AFCF); // Azul sereno
  static const Color moodNeutral = Color(0xFFEED694); // Arena
  static const Color moodDifficult = Color(0xFFE3A676); // Terracota
  static const Color moodBad = Color(0xFFD68078); // Coral
  static const Color moodEmpty = Color(0xFFF0F0F0); // Gris suave

  // Obtener color por índice
  static Color getMoodColor(int index) {
    switch (index) {
      case 0:
        return moodExcellent;
      case 1:
        return moodGood;
      case 2:
        return moodNeutral;
      case 3:
        return moodDifficult;
      case 4:
        return moodBad;
      default:
        return moodEmpty;
    }
  }

  // Obtener texto del estado de ánimo (traducido según el locale activo)
  static String getMoodText(int index) {
    switch (index) {
      case 0:
        return 'mood.label.excellent'.tr;
      case 1:
        return 'mood.label.good'.tr;
      case 2:
        return 'mood.label.neutral'.tr;
      case 3:
        return 'mood.label.difficult'.tr;
      case 4:
        return 'mood.label.bad'.tr;
      default:
        return 'mood.label.empty'.tr;
    }
  }

  // UI Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
}
