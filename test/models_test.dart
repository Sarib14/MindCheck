import 'package:flutter_test/flutter_test.dart';
import 'package:mindcheck/models/mood_catalog.dart';
import 'package:mindcheck/models/mood_entry.dart';

void main() {
  group('MoodEntry', () {
    test('toMap and fromMap keep every field', () {
      final entry = MoodEntry(
        id: 'abc',
        mood: 'Calm',
        intensity: 4,
        note: 'A quiet evening',
        date: DateTime(2026, 11, 19, 20, 30),
      );

      final copy = MoodEntry.fromMap(entry.toMap());

      expect(copy.id, 'abc');
      expect(copy.mood, 'Calm');
      expect(copy.intensity, 4);
      expect(copy.note, 'A quiet evening');
      expect(copy.date, entry.date);
    });

    test('fromMap accepts older entries that have no id or note', () {
      final entry = MoodEntry.fromMap({
        'mood': 'Happy',
        'intensity': 3,
        'date': '2026-11-01T10:00:00.000',
      });

      expect(entry.id, isNotEmpty);
      expect(entry.note, '');
      expect(entry.mood, 'Happy');
    });

    test('copyWith changes only the given fields and keeps the id', () {
      final entry = MoodEntry(
        id: 'xyz',
        mood: 'Sad',
        intensity: 2,
        note: 'Rough day',
        date: DateTime(2026, 11, 10),
      );

      final updated = entry.copyWith(mood: 'Tired', intensity: 5);

      expect(updated.id, 'xyz');
      expect(updated.mood, 'Tired');
      expect(updated.intensity, 5);
      expect(updated.note, 'Rough day');
      expect(updated.date, entry.date);
    });
  });

  group('MoodCatalog', () {
    test('emoji lookup ignores case and spaces', () {
      expect(MoodCatalog.emoji('happy'), '😊');
      expect(MoodCatalog.emoji('  CALM '), '😌');
    });

    test('custom moods fall back to the heart emoji', () {
      expect(MoodCatalog.emoji('Grateful'), '💚');
    });

    test('every default mood has its own emoji', () {
      final emojis = MoodCatalog.defaultMoods.map(MoodCatalog.emoji).toSet();

      expect(emojis.length, MoodCatalog.defaultMoods.length);
      expect(emojis.contains('💚'), isFalse);
    });

    test('intensity labels cover 1 to 5', () {
      expect(MoodCatalog.intensityLabel(1), 'Very mild');
      expect(MoodCatalog.intensityLabel(3), 'Moderate');
      expect(MoodCatalog.intensityLabel(5), 'Very strong');
      expect(MoodCatalog.intensityLabel(9), 'Unrated');
    });
  });
}