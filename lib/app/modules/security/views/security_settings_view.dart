import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
import 'package:moodgrid/app/modules/security/controllers/security_controller.dart';
import 'package:moodgrid/app/modules/security/widgets/pin_input_widget.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class SecuritySettingsView extends GetView<SecurityController> {
  const SecuritySettingsView({super.key});

  void _showDisableSecurityDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'security.disable.dialog.title'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'security.disable.dialog.message'.tr,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Obx(() {
              return PinInputWidget(
                pinLength: controller.pinLength.value,
                onComplete: (pin) async {
                  final isValid = await controller.verifyPin(pin);
                  if (isValid) {
                    Get.back();
                    await controller.disableSecurity();
                  } else {
                    appSnackBar(
                      title: 'common.error'.tr,
                      message: 'security.error.wrong_pin'.tr,
                      kind: AppSnackKind.error,
                    );
                  }
                },
              );
            }),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('common.cancel'.tr),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('security.title'.tr),
        leading: IconButton(onPressed: (){
          Get.offAllNamed(Routes.home);
        }, icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'security.protection.title'.tr,
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'security.protection.subtitle'.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    SwitchListTile(
                      title: Text('security.toggle.title'.tr),
                      subtitle: controller.isSecurityEnabled.value
                          ? Text('security.toggle.subtitle.on'.tr)
                          : Text('security.toggle.subtitle.off'.tr),
                      value: controller.isSecurityEnabled.value,
                      onChanged: (value) {
                        if (value) {
                          Get.toNamed(
                            Routes.pinSetup,
                            arguments: {'mode': 'create'},
                          );
                        } else {
                          _showDisableSecurityDialog();
                        }
                      },
                    ),
                    if (controller.isSecurityEnabled.value) ...[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: Text('security.change_pin.title'.tr),
                        subtitle: Text(
                          'security.change_pin.subtitle.one'.trPluralParams(
                            'security.change_pin.subtitle.other',
                            controller.pinLength.value,
                            {'count': '${controller.pinLength.value}'},
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Get.toNamed(
                            Routes.pinSetup,
                            arguments: {'mode': 'change'},
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'security.info_banner'.tr,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }
}
