import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/theme/app_theme.dart';
import 'package:moodgrid/app/core/services/ads_service.dart';
import 'package:moodgrid/app/core/services/analytics_service.dart';
import 'package:moodgrid/app/core/services/lifecycle_service.dart';
import 'package:moodgrid/app/core/services/locale_service.dart';
import 'package:moodgrid/app/core/services/reminder_service.dart';
import 'package:moodgrid/app/core/services/remote_config_service.dart';
import 'package:moodgrid/app/core/services/security_service.dart';
import 'package:moodgrid/app/core/services/update_service.dart';
import 'package:moodgrid/app/core/translations/app_translations.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';
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

  // Crashlytics: captura errores de Flutter y de la plataforma.
  // En debug se desactiva la subida para no ensuciar el dashboard.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await AnalyticsService.instance.init();

  // Remote Config: fetch en segundo plano; UpdateService espera a que
  // termine antes de comparar versiones.
  unawaited(RemoteConfigService.instance.ensureInitialized());

  // Inicializar locale (carga preferencia + initializeDateFormatting para EN y ES)
  await LocaleService.instance.init();

  // Inicializar AdMob (NPA por defecto). El ATT prompt se solicita
  // desde la primera pantalla visible (ver `_HomeWrapper` / `_LandingWrapper`).
  await AdsService.instance.init();

  // Inicializar SecurityService
  await SecurityService.instance.init();

  // Recordatorio diario: reprograma el aviso si el usuario ya lo activo.
  await ReminderService.instance.init();

  // Inicializar AuthController globalmente
  Get.put(AuthController(), permanent: true);

  // Inicializar SecurityController globalmente
  final securityController = Get.put(SecurityController(), permanent: true);

  // Registrar lifecycle observer para bloqueo automático
  final lifecycleService = LifecycleService(securityController);
  WidgetsBinding.instance.addObserver(lifecycleService);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Solicitar ATT en iOS después del primer frame, cuando ya hay un
    // árbol Material visible. En Android es no-op.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdsService.instance.requestATTIfNeeded();
      UpdateService.instance.checkForRequiredUpdate();
      // Las traducciones ya estan cargadas: el recordatorio se reprograma
      // con el texto en el idioma activo.
      ReminderService.instance.applyLocalizedTexts(
        title: 'profile.settings.reminder.notification.title'.tr,
        body: 'profile.settings.reminder.notification.body'.tr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final securityController = Get.find<SecurityController>();

    return GetMaterialApp(
      title: 'EmotionsMap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: appScaffoldMessengerKey,
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
      navigatorObservers: [AnalyticsService.instance.observer],
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      translations: AppTranslations(),
      locale: LocaleService.instance.currentLocale,
      fallbackLocale: LocaleService.fallback,
      supportedLocales: LocaleService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
