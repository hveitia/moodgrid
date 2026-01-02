import 'package:get/get.dart';
import 'package:moodgrid/app/modules/reflections/controllers/reflections_controller.dart';

class ReflectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReflectionsController>(() => ReflectionsController());
  }
}
