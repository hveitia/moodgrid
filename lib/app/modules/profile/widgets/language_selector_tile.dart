import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/locale_service.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';

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
      onTap: () => _showLanguageSheet(context),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final current = LocaleService.instance.currentLocale;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'language.choose'.tr,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _LanguageOption(
                  flag: '🇺🇸',
                  label: 'language.english'.tr,
                  selected: current.languageCode == 'en',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await LocaleService.instance.changeLocale(
                      LocaleService.english,
                    );
                  },
                ),
                _LanguageOption(
                  flag: '🇪🇸',
                  label: 'language.spanish'.tr,
                  selected: current.languageCode == 'es',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await LocaleService.instance.changeLocale(
                      LocaleService.spanish,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.moodExcellent.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.moodExcellent.withValues(alpha: 0.4)
                  : Colors.grey.withValues(alpha: 0.18),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.moodExcellent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
