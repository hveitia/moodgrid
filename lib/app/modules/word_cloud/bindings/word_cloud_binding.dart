import 'package:get/get.dart';
import 'package:moodgrid/app/modules/word_cloud/controllers/word_cloud_controller.dart';

class WordCloudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordCloudController>(() => WordCloudController());
  }
}
