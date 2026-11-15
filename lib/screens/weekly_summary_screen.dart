
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class WeeklySummaryScreen extends StatelessWidget {
  const WeeklySummaryScreen({super.key});

  DateTime getStartDate() {
    final today = DateTime.now();
    final date = DateTime(today.year, today.month, today.day);
    return date.subtract(const Duration(days: 6));
  }

  List<MoodEntry> getWeeklyMoods(List<MoodEntry> moods) {
    final startDate = getStartDate();
    final today = DateTime.now();

    return moods.where((entry) {
      final date = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );

      return !date.isBefore(startDate) &&
          !date.isAfter(DateTime(today.year, today.month, today.day));
    }).toList();
  }

  String getMostFrequentMood(List<MoodEntry> moods) {
    if (moods.isEmpty) return 'Not available';

    final counts = <String, int>{};

    for (final entry in moods) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  String getEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Calm':
        return '😌';
      case 'Excited':
        return '🤩';
      case 'Sad':
        return '😔';
      case 'Anxious':
        return '😟';
      case 'Angry':
        return '😠';
      case 'Tired':
        return '😴';
      default:
        return '💚';
    }
  }

  Widget buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 25),
            const SizedBox(height: 13),
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30483C),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF78847B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeeklyChart(List<MoodEntry> moods) {

    final startDate = getStartDate();

    final dailyCounts = List<int>.filled(7, 0);

    for (final entry in moods) {
      final date = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );

      final index = date.difference(startDate).inDays;

      if (index >= 0 && index < 7) {
        dailyCounts[index]++;
      }
    }

    final highestCount = dailyCounts.reduce(
      (a, b) => a > b ? a : b,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your activity',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF30483C),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Mood check-ins over the last 7 days',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78847B),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 125,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final date = startDate.add(Duration(days: index));
                final count = dailyCounts[index];

                final barHeight = highestCount == 0
                    ? 8.0
                    : (count / highestCount) * 75;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF78847B),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        height: barHeight,
                        width: 19,
                        decoration: BoxDecoration(
                          color: count == 0
                              ? const Color(0xFFE5EDE7)
                              : AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                            [date.weekday - 1],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF78847B),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(List<MoodEntry> allMoods) {
    final moods = getWeeklyMoods(allMoods);

    final averageIntensity = moods.isEmpty
    ? 0.0
    : moods.fold<double>(
        0.0,
        (total, entry) => total + entry.intensity,
      ) /
      moods.length;

    final frequentMood = getMostFrequentMood(moods);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.insights_rounded,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(height: 16),
              Text(
                'Your week, in reflection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Take a gentle look at your emotional journey. Every feeling deserves attention.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            buildStatCard(
              'Check-ins',
              '${moods.length}',
              Icons.edit_calendar_rounded,
            ),
            const SizedBox(width: 13),
            buildStatCard(
              'Average intensity',
              moods.isEmpty ? '--' : averageIntensity.toStringAsFixed(1),
              Icons.show_chart_rounded,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EDE7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  moods.isEmpty ? '💚' : getEmoji(frequentMood),
                  style: const TextStyle(fontSize: 27),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Most frequent mood',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF78847B),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      frequentMood,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        buildWeeklyChart(moods),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE5EDE7),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'A gentle reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30483C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                moods.isEmpty
                    ? 'Your weekly story has not started yet. Add a mood check-in whenever you feel ready.'
                    : 'You recorded ${moods.length} check-ins this week. Take time to appreciate your effort and keep making space for your feelings.',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: Color(0xFF64766A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF30483C),
        ),
        title: const Text(
          'Weekly Summary',
          style: TextStyle(
            color: Color(0xFF30483C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<MoodEntry>>(
        future: StorageService.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Unable to prepare your weekly summary. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF78847B),
                  ),
                ),
              ),
            );
          }

          return buildContent(snapshot.data ?? []);
        },
      ),
    );
  }
}
