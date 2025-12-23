import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/modules/security/controllers/security_controller.dart';
import 'package:moodgrid/app/modules/security/widgets/pin_input_widget.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

enum PinSetupMode { create, change }

enum PinSetupStep {
  selectLength, // Solo en modo create
  enterOld, // Solo en modo change
  enterNew,
  confirmNew,
}

class PinSetupView extends StatefulWidget {
  const PinSetupView({super.key});

  @override
  State<PinSetupView> createState() => _PinSetupViewState();
}

class _PinSetupViewState extends State<PinSetupView> {
  final controller = Get.find<SecurityController>();

  late PinSetupMode mode;
  late PinSetupStep currentStep;

  String? oldPin;
  String? newPin;
  String? errorText;

  @override
  void initState() {
    super.initState();
    final String? modeArg = Get.arguments?['mode'];
    mode = modeArg == 'change' ? PinSetupMode.change : PinSetupMode.create;

    if (mode == PinSetupMode.create) {
      currentStep = PinSetupStep.selectLength;
    } else {
      currentStep = PinSetupStep.enterOld;
    }
  }

  String _getTitle() {
    switch (currentStep) {
      case PinSetupStep.selectLength:
        return 'Configura tu PIN';
      case PinSetupStep.enterOld:
        return 'Cambiar PIN';
      case PinSetupStep.enterNew:
        return mode == PinSetupMode.create
            ? 'Crea tu PIN'
            : 'Nuevo PIN';
      case PinSetupStep.confirmNew:
        return 'Confirma tu PIN';
    }
  }

  String _getSubtitle() {
    switch (currentStep) {
      case PinSetupStep.selectLength:
        return 'Selecciona la longitud de tu PIN';
      case PinSetupStep.enterOld:
        return 'Ingresa tu PIN actual';
      case PinSetupStep.enterNew:
        return 'Ingresa tu nuevo PIN';
      case PinSetupStep.confirmNew:
        return 'Vuelve a ingresar tu PIN';
    }
  }

  void _onPinComplete(String pin) {
    setState(() {
      errorText = null;
    });

    switch (currentStep) {
      case PinSetupStep.enterOld:
        _handleOldPin(pin);
        break;
      case PinSetupStep.enterNew:
        _handleNewPin(pin);
        break;
      case PinSetupStep.confirmNew:
        _handleConfirmPin(pin);
        break;
      default:
        break;
    }
  }

  Future<void> _handleOldPin(String pin) async {
    final isValid = await controller.verifyPin(pin);
    if (isValid) {
      setState(() {
        oldPin = pin;
        currentStep = PinSetupStep.enterNew;
      });
    } else {
      setState(() {
        errorText = 'PIN incorrecto';
      });
    }
  }

  void _handleNewPin(String pin) {
    setState(() {
      newPin = pin;
      currentStep = PinSetupStep.confirmNew;
    });
  }

  Future<void> _handleConfirmPin(String pin) async {
    if (pin == newPin) {
      bool success = false;
      if (mode == PinSetupMode.create) {
        success = await controller.enableSecurity(newPin!);
      } else {
        success = await controller.changePin(oldPin!, newPin!);
      }

      if (success) {
        await Future.delayed(const Duration(milliseconds: 800));

        if (mode == PinSetupMode.create) {
          Get.offAllNamed(Routes.securitySettings);
        } else {
          Get.back();
          Get.offAllNamed(Routes.securitySettings);
        }
      }
    } else {
      setState(() {
        errorText = 'Los PINs no coinciden';
        currentStep = PinSetupStep.enterNew;
        newPin = null;
      });
    }
  }

  void _onLengthSelected(int length) {
    controller.setPinLength(length);
    setState(() {
      currentStep = PinSetupStep.enterNew;
    });
  }

  Widget _buildLengthSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Longitud del PIN',
          style: Get.textTheme.titleLarge,
        ),
        const SizedBox(height: 40),
        Obx(() {
          final length = controller.pinLength.value;
          return Column(
            children: [
              Slider(
                value: length.toDouble(),
                min: 4,
                max: 6,
                divisions: 2,
                label: '$length dígitos',
                onChanged: (value) {
                  controller.setPinLength(value.toInt());
                },
              ),
              const SizedBox(height: 16),
              Text(
                '$length dígitos',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: () => _onLengthSelected(controller.pinLength.value),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }

  Widget _buildPinInput() {
    return Center(
      child: Obx(() {
        return PinInputWidget(
          key: ValueKey(currentStep),
          pinLength: controller.pinLength.value,
          onComplete: _onPinComplete,
          errorText: errorText,
          onClear: () {
            setState(() {
              errorText = null;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getSubtitle(),
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (currentStep == PinSetupStep.selectLength)
                _buildLengthSelector()
              else
                _buildPinInput(),
            ],
          ),
        );
      }),
    );
  }
}
