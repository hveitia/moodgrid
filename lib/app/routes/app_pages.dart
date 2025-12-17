import 'package:get/get.dart';
import 'package:moodgrid/app/modules/home/bindings/home_binding.dart';
import 'package:moodgrid/app/modules/home/views/home_view.dart';
import 'package:moodgrid/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
