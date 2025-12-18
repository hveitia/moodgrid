import 'package:get/get.dart';
import 'package:moodgrid/app/modules/auth/bindings/auth_binding.dart';
import 'package:moodgrid/app/modules/backup/views/backup_view.dart';
import 'package:moodgrid/app/modules/home/bindings/home_binding.dart';
import 'package:moodgrid/app/modules/home/views/home_view.dart';
import 'package:moodgrid/app/modules/landing/views/landing_view.dart';
import 'package:moodgrid/app/modules/login/views/login_view.dart';
import 'package:moodgrid/app/modules/profile/bindings/profile_binding.dart';
import 'package:moodgrid/app/modules/profile/views/profile_view.dart';
import 'package:moodgrid/app/modules/register/views/register_view.dart';
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
  ];
}
