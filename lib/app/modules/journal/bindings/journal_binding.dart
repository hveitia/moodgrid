import 'package:get/get.dart';
import 'package:moodgrid/app/modules/journal/controllers/journal_controller.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalController>(() => JournalController());
  }
}
