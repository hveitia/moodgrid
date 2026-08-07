import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/locale_service.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:moodgrid/app/core/widgets/language_sheet.dart';

class LanguageSelectorTile extends StatelessWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.moodGood.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.language,
          color: AppColors.moodGood,
        ),
      ),
      title: Text(
        'profile.settings.language.title'.tr,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Obx(() {
        final current = LocaleService.instance.currentLocaleRx.value;
        final isSpanish = current.languageCode == 'es';
        return Text(
          isSpanish ? 'language.spanish'.tr : 'language.english'.tr,
        );
      }),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showLanguageSheet(context),
    );
  }
}
