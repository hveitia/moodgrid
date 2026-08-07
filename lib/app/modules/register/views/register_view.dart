import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEmailNotice();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showEmailNotice() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.mark_email_read_outlined,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text('register.email_notice.title'.tr)),
          ],
        ),
        content: Text(
          'register.email_notice.message'.tr,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('register.email_notice.button'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authController.createUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        Get.offAllNamed(Routes.home);
      } catch (e) {
        // Error ya manejado en AuthController
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register.title'.tr),
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
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'register.field.confirm_password'.tr,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'register.error.confirm_required'.tr;
                    }
                    if (value != _passwordController.text) {
                      return 'register.error.passwords_mismatch'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Obx(() => ElevatedButton(
                      onPressed: _authController.isLoading.value ? null : _register,
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('register.button.submit'.tr),
                    )),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('register.link.signin'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
