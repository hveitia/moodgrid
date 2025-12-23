import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/modules/security/controllers/security_controller.dart';
import 'package:moodgrid/app/modules/security/widgets/pin_input_widget.dart';

class LockScreenView extends GetView<SecurityController> {
  const LockScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return _LockScreenContent();
  }
}

class _LockScreenContent extends StatefulWidget {
  const _LockScreenContent();

  @override
  State<_LockScreenContent> createState() => _LockScreenContentState();
}

class _LockScreenContentState extends State<_LockScreenContent> {
  String? errorText;
  bool showingForgotPinConfirmation = false;

  Future<void> _onPinComplete(String pin) async {
    final controller = Get.find<SecurityController>();
    final isValid = await controller.verifyPin(pin);
    if (isValid) {
      controller.unlockApp();
    } else {
      if (mounted) {
        setState(() {
          errorText = 'PIN incorrecto. Intenta nuevamente.';
        });
      }
    }
  }

  void _toggleForgotPinConfirmation() {
    if (mounted) {
      setState(() {
        showingForgotPinConfirmation = !showingForgotPinConfirmation;
      });
    }
  }

  Future<void> _handleSignOut() async {
    final authController = Get.find<AuthController>();
    final securityController = Get.find<SecurityController>();

    // Desbloquear app primero
    securityController.unlockApp();

    // Cerrar sesión
    await authController.signOut();

    // El Obx en main.dart redirigirá automáticamente al landing
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SecurityController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48, // padding
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                const SizedBox(height: 12),
                Text(
                  'MoodGrid',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Ingresa tu PIN para desbloquear',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                if (!showingForgotPinConfirmation) ...[
                  Obx(() {
                    return PinInputWidget(
                      pinLength: controller.pinLength.value,
                      onComplete: _onPinComplete,
                      errorText: errorText,
                      onClear: () {
                        if (mounted) {
                          setState(() {
                            errorText = null;
                          });
                        }
                      },
                    );
                  }),
                ] else ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '¿Cerrar Sesión?',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Para recuperar el acceso, cerraremos tu sesión actual. '
                                'Podrás iniciar sesión nuevamente y configurar un nuevo PIN.',
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _toggleForgotPinConfirmation,
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _handleSignOut,
                                  child: const Text('Cerrar Sesión'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 60),
                if (!showingForgotPinConfirmation)
                  TextButton(
                    onPressed: _toggleForgotPinConfirmation,
                    child: Text(
                      '¿Olvidaste tu PIN?',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
