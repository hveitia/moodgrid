import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authController.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        Get.offAllNamed(Routes.home);
      } catch (e) {
        // Error ya manejado en AuthController
      }
    }
  }

  void _showRecoveryBottomSheet() {
    final recoveryFormKey = GlobalKey<FormState>();
    final recoveryEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: recoveryFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  'recovery.title'.tr,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'recovery.subtitle'.tr,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: recoveryEmailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'recovery.field.email'.tr,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) {
                      return 'recovery.error.missing_email'.tr;
                    }
                    if (!GetUtils.isEmail(v)) {
                      return 'login.error.email_invalid'.tr;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submitRecovery(
                    recoveryFormKey,
                    recoveryEmailController,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : () => _submitRecovery(
                                recoveryFormKey,
                                recoveryEmailController,
                              ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text('recovery.button.send'.tr),
                    )),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('common.cancel'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Future<void> _submitRecovery(
    GlobalKey<FormState> formKey,
    TextEditingController controller,
  ) async {
    if (!formKey.currentState!.validate()) return;
    try {
      await _authController.sendPasswordResetEmail(
        controller.text.trim(),
      );
      // Cerrar primero la bottom sheet para que el SnackBar quede limpio.
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      appSnackBar(
        title: 'recovery.success.title'.tr,
        message: 'recovery.success.message'.tr,
        kind: AppSnackKind.success,
      );
    } catch (e) {
      // Error ya mostrado por AuthController; el sheet permanece abierto
      // para que el usuario pueda corregir el email.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login.title'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                Center(
                  child: Image.asset(
                    'assets/moodgrid.png',
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 48),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'login.field.email'.tr,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'login.error.email_required'.tr;
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'login.error.email_invalid'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'login.field.password'.tr,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'login.error.password_required'.tr;
                    }
                    if (value.length < 6) {
                      return 'login.error.password_short'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Obx(() => ElevatedButton(
                      onPressed: _authController.isLoading.value ? null : _login,
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('login.button.submit'.tr),
                    )),
                const SizedBox(height: 8),

                TextButton(
                  onPressed: _showRecoveryBottomSheet,
                  child: Text('login.forgot.link'.tr),
                ),

                TextButton(
                  onPressed: () => Get.toNamed(Routes.register),
                  child: Text('login.link.signup'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
