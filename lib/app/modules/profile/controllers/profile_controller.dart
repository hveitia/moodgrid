import 'package:get/get.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';

class ProfileController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final RxMap<int, int> moodStatistics = <int, int>{}.obs;
  final RxInt totalRecords = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;
      final stats = await _databaseHelper.getMoodStatistics();
      final total = await _databaseHelper.getTotalRecordsCount();

      moodStatistics.value = stats;
      totalRecords.value = total;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar estadísticas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
