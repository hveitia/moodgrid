import 'package:flutter/material.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';

/// Represents a word in the word cloud with its frequency and mood association
class WordCloudItem {
  final String word;
  final int frequency;
  final double averageMood;
  final List<int> moodIndices;

  const WordCloudItem({
    required this.word,
    required this.frequency,
    required this.averageMood,
    required this.moodIndices,
  });

  /// Get the color for this word based on average mood
  Color get color => AppColors.getMoodColor(averageMood.round().clamp(0, 4));

  /// Get the mood text description
  String get moodText => AppColors.getMoodText(averageMood.round().clamp(0, 4));

  /// Calculate font size based on frequency
  /// minSize and maxSize define the range of font sizes
  double getFontSize({
    required int maxFrequency,
    double minSize = 12,
    double maxSize = 48,
  }) {
    if (maxFrequency <= 1) return minSize;

    final ratio = (frequency - 1) / (maxFrequency - 1);
    return minSize + (ratio * (maxSize - minSize));
  }

  @override
  String toString() {
    return 'WordCloudItem(word: $word, frequency: $frequency, avgMood: ${averageMood.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordCloudItem && other.word == word;
  }

  @override
  int get hashCode => word.hashCode;
}
