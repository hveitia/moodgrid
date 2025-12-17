class DailyRecord {
  final int? id;
  final DateTime date;
  final int colorIndex; // 0-4 para los estados de ánimo, 5 para vacío
  final String? comment;

  DailyRecord({
    this.id,
    required this.date,
    required this.colorIndex,
    this.comment,
  });

  // Convertir de Map (SQLite) a DailyRecord
  factory DailyRecord.fromMap(Map<String, dynamic> map) {
    return DailyRecord(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      colorIndex: map['color_index'] as int,
      comment: map['comment'] as String?,
    );
  }

  // Convertir DailyRecord a Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0], // Solo la fecha (YYYY-MM-DD)
      'color_index': colorIndex,
      'comment': comment,
    };
  }

  // Convertir a JSON para export/import
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'color_index': colorIndex,
      'comment': comment,
    };
  }

  // Crear desde JSON
  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      date: DateTime.parse(json['date'] as String),
      colorIndex: json['color_index'] as int,
      comment: json['comment'] as String?,
    );
  }

  // Copiar con modificaciones
  DailyRecord copyWith({
    int? id,
    DateTime? date,
    int? colorIndex,
    String? comment,
  }) {
    return DailyRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      colorIndex: colorIndex ?? this.colorIndex,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() {
    return 'DailyRecord{id: $id, date: ${date.toIso8601String().split('T')[0]}, colorIndex: $colorIndex, comment: $comment}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyRecord &&
        other.id == id &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day &&
        other.colorIndex == colorIndex &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        colorIndex.hashCode ^
        comment.hashCode;
  }
}
