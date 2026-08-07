import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/reminder_service.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';

class ReminderSettingsTile extends StatefulWidget {
  const ReminderSettingsTile({super.key});

  @override
  State<ReminderSettingsTile> createState() => _ReminderSettingsTileState();
}

class _ReminderSettingsTileState extends State<ReminderSettingsTile> {
  final ReminderService _service = ReminderService.instance;

  bool _busy = false;

  String get _formattedTime {
    final hour = _service.hour.toString().padLeft(2, '0');
    final minute = _service.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _toggle(bool value) async {
    if (_busy) return;
    setState(() => _busy = true);

    if (value) {
      final granted = await _service.enable(
        hour: _service.hour,
        minute: _service.minute,
      );
      if (!granted && mounted) {
        appSnackBar(
          title: 'common.error'.tr,
          message: 'profile.settings.reminder.permission_denied'.tr,
          kind: AppSnackKind.warning,
        );
      }
    } else {
      await _service.disable();
    }

    if (mounted) setState(() => _busy = false);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _service.hour, minute: _service.minute),
    );
    if (picked == null) return;

    setState(() => _busy = true);
    final granted = await _service.enable(
      hour: picked.hour,
      minute: picked.minute,
    );
    if (!granted && mounted) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'profile.settings.reminder.permission_denied'.tr,
        kind: AppSnackKind.warning,
      );
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.moodNeutral.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.notifications_active_outlined,
          color: AppColors.moodNeutral,
        ),
      ),
      title: Text(
        'profile.settings.reminder.title'.tr,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        _service.isEnabled
            ? 'profile.settings.reminder.subtitle.on'
                .trParams({'time': _formattedTime})
            : 'profile.settings.reminder.subtitle.off'.tr,
      ),
      trailing: Switch(
        value: _service.isEnabled,
        onChanged: _busy ? null : _toggle,
      ),
      onTap: _service.isEnabled && !_busy ? _pickTime : null,
    );
  }
}
