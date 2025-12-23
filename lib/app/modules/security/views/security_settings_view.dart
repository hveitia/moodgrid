import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              'Desactivar Seguridad',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Para desactivar la seguridad, ingresa tu PIN actual.',
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
                    Get.snackbar(
                      'Error',
                      'PIN incorrecto',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              );
            }),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
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
        title: const Text('Seguridad'),
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
                      'Protección con PIN',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protege tu diario de emociones con un código PIN',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Activar Seguridad'),
                      subtitle: controller.isSecurityEnabled.value
                          ? const Text('Tu app está protegida con PIN')
                          : const Text('Configura un PIN para proteger tu app'),
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
                        title: const Text('Cambiar PIN'),
                        subtitle: Text(
                            'PIN de ${controller.pinLength.value} dígitos configurado'),
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
                        'La app se bloqueará automáticamente al minimizarla si la seguridad está activada.',
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
