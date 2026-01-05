import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moodgrid/app/core/theme/app_theme.dart';
import 'package:moodgrid/app/core/services/lifecycle_service.dart';
import 'package:moodgrid/app/core/services/security_service.dart';
import 'package:moodgrid/app/modules/auth/controllers/auth_controller.dart';
import 'package:moodgrid/app/modules/security/controllers/security_controller.dart';
import 'package:moodgrid/app/modules/security/views/lock_screen_view.dart';
import 'package:moodgrid/app/routes/app_pages.dart';
import 'package:moodgrid/app/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar formato de fecha en español
  await initializeDateFormatting('es_ES', null);

  // Inicializar SecurityService
  await SecurityService.instance.init();

  // Inicializar AuthController globalmente
  Get.put(AuthController(), permanent: true);

  // Inicializar SecurityController globalmente
  final securityController = Get.put(SecurityController(), permanent: true);

  // Registrar lifecycle observer para bloqueo automático
  final lifecycleService = LifecycleService(securityController);
  WidgetsBinding.instance.addObserver(lifecycleService);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final securityController = Get.find<SecurityController>();

    return GetMaterialApp(
      title: 'Feelmap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Obx(() {
          if (securityController.isLocked.value) {
            if (kDebugMode) {
              print('🔒 Builder: App is locked, showing LockScreenView');
            }
            return const LockScreenView();
          }
          if (kDebugMode) {
            print('🔓 Builder: App is unlocked, showing normal content');
          }
          return child ?? const SizedBox();
        });
      },
      home: Obx(() {
        if (authController.firebaseUser.value != null) {
          return const _HomeWrapper();
        } else {
          return const _LandingWrapper();
        }
      }),
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('es', 'ES'),
    );
  }
}

class _HomeWrapper extends StatelessWidget {
  const _HomeWrapper();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.home);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _LandingWrapper extends StatelessWidget {
  const _LandingWrapper();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.landing);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
