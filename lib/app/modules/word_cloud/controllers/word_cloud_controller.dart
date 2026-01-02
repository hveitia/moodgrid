import 'package:get/get.dart';
import 'package:moodgrid/app/core/utils/text_processor.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';
import 'package:moodgrid/app/data/models/word_cloud_item.dart';
import 'package:moodgrid/app/data/providers/database_helper.dart';

class WordCloudController extends GetxController {
  final RxList<WordCloudItem> wordCloudItems = <WordCloudItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt totalComments = 0.obs;
  final RxInt totalWords = 0.obs;

  static const int minFrequency = 2;
  static const int maxWords = 50;

  @override
  void onInit() {
    super.onInit();
    loadWordCloud();
  }

  Future<void> loadWordCloud() async {
    isLoading.value = true;

    try {
      final records = await DatabaseHelper().getRecordsWithComments();
      totalComments.value = records.length;

      if (records.isEmpty) {
        wordCloudItems.clear();
        isLoading.value = false;
        return;
      }

      final items = _processRecords(records);
      wordCloudItems.value = items;
    } catch (e) {
      wordCloudItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<WordCloudItem> _processRecords(List<DailyRecord> records) {
    // Map to store word -> list of (frequency contribution, mood index)
    final wordData = <String, List<int>>{};
    int totalWordCount = 0;

    for (final record in records) {
      if (record.comment == null || record.comment!.isEmpty) continue;

      final words = TextProcessor.processText(record.comment!);
      totalWordCount += words.length;

      for (final word in words) {
        wordData.putIfAbsent(word, () => []);
        wordData[word]!.add(record.colorIndex);
      }
    }

    totalWords.value = totalWordCount;

    // Convert to WordCloudItem list, filtering by minimum frequency
    final items = <WordCloudItem>[];

    for (final entry in wordData.entries) {
      final word = entry.key;
      final moodIndices = entry.value;
      final frequency = moodIndices.length;

      if (frequency < minFrequency) continue;

      // Calculate average mood (only consider valid mood indices 0-4)
      final validMoods = moodIndices.where((m) => m >= 0 && m <= 4).toList();
      if (validMoods.isEmpty) continue;

      final averageMood = validMoods.reduce((a, b) => a + b) / validMoods.length;

      items.add(WordCloudItem(
        word: word,
        frequency: frequency,
        averageMood: averageMood,
        moodIndices: moodIndices,
      ));
    }

    // Sort by frequency descending and take top N
    items.sort((a, b) => b.frequency.compareTo(a.frequency));

    return items.take(maxWords).toList();
  }

  int get maxFrequency {
    if (wordCloudItems.isEmpty) return 1;
    return wordCloudItems.map((item) => item.frequency).reduce((a, b) => a > b ? a : b);
  }

  bool get hasEnoughData => wordCloudItems.isNotEmpty;
}
