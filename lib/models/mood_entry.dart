
class MoodEntry {
  final String id;
  final String mood;
  final int intensity;
  final String note;
  final DateTime date;

  MoodEntry({
    String? id,
    required this.mood,
    required this.intensity,
    required this.note,
    required this.date,
  }) : id = id ?? date.microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'intensity': intensity,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    final entryDate = DateTime.parse(map['date'].toString());

    return MoodEntry(
      id: map['id']?.toString() ??
          entryDate.microsecondsSinceEpoch.toString(),
      mood: map['mood'].toString(),
      intensity: (map['intensity'] as num).toInt(),
      note: map['note']?.toString() ?? '',
      date: entryDate,
    );
  }

  MoodEntry copyWith({
    String? mood,
    int? intensity,
    String? note,
    DateTime? date,
  }) {
    return MoodEntry(
      id: id,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
