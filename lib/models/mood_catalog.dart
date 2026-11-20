import 'package:flutter/material.dart';

/// One place for mood emojis, colours and labels, so every screen agrees.
class MoodCatalog {
  MoodCatalog._();

  static const List<String> defaultMoods = [
    'Happy',
    'Calm',
    'Excited',
    'Sad',
    'Anxious',
    'Angry',
    'Tired',
  ];

  static const Map<String, String> _emojis = {
    'happy': '😊',
    'calm': '😌',
    'excited': '🤩',
    'sad': '😔',
    'anxious': '😟',
    'angry': '😠',
    'tired': '😴',
  };

  static String emoji(String mood) {
    return _emojis[mood.trim().toLowerCase()] ?? '💚';
  }

  static Color color(String mood) {
    switch (mood.trim().toLowerCase()) {
      case 'happy':
      case 'excited':
        return const Color(0xFFE8B95D);
      case 'calm':
        return const Color(0xFF79A88B);
      case 'sad':
        return const Color(0xFF7E9DC2);
      case 'anxious':
        return const Color(0xFFB39BCB);
      case 'angry':
        return const Color(0xFFD98279);
      case 'tired':
        return const Color(0xFF9B9DA8);
      default:
        return const Color(0xFF648C78);
    }
  }

  static String intensityLabel(int value) {
    switch (value) {
      case 1:
        return 'Very mild';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Strong';
      case 5:
        return 'Very strong';
      default:
        return 'Unrated';
    }
  }
}