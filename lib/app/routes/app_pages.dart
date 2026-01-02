import 'package:get/get.dart';
import 'package:moodgrid/app/modules/auth/bindings/auth_binding.dart';
import 'package:moodgrid/app/modules/backup/views/backup_view.dart';
import 'package:moodgrid/app/modules/home/bindings/home_binding.dart';
import 'package:moodgrid/app/modules/home/views/home_view.dart';
import 'package:moodgrid/app/modules/journal/bindings/journal_binding.dart';
import 'package:moodgrid/app/modules/journal/views/journal_view.dart';
import 'package:moodgrid/app/modules/landing/views/landing_view.dart';
import 'package:moodgrid/app/modules/login/views/login_view.dart';
import 'package:moodgrid/app/modules/profile/bindings/profile_binding.dart';
import 'package:moodgrid/app/modules/profile/views/profile_view.dart';
import 'package:moodgrid/app/modules/register/views/register_view.dart';
import 'package:moodgrid/app/modules/security/bindings/security_binding.dart';
import 'package:moodgrid/app/modules/security/views/pin_setup_view.dart';
import 'package:moodgrid/app/modules/security/views/security_settings_view.dart';
import 'package:moodgrid/app/modules/word_cloud/bindings/word_cloud_binding.dart';
import 'package:moodgrid/app/modules/word_cloud/views/word_cloud_view.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.landing;

  static final routes = [
    GetPage(
      name: Routes.landing,
      page: () => const LandingView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.backup,
      page: () => const BackupView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.securitySettings,
      page: () => const SecuritySettingsView(),
      binding: SecurityBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.pinSetup,
      page: () => const PinSetupView(),
      binding: SecurityBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.journal,
      page: () => const JournalView(),
      binding: JournalBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.wordCloud,
      page: () => const WordCloudView(),
      binding: WordCloudBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
