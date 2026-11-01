
class MoodEntry {
  final String mood;
  final int intensity;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.mood,
    required this.intensity,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'intensity': intensity,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      mood: map['mood'],
      intensity: map['intensity'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }
}
