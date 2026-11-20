import 'package:flutter/material.dart';

import '../models/mood_catalog.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class WeeklySummaryScreen extends StatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  State<WeeklySummaryScreen> createState() => _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends State<WeeklySummaryScreen> {
  // The future is created once, so rebuilding (for example when the theme
  // changes) does not reload everything from storage.
  late Future<List<MoodEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = StorageService.getMoods();
  }

  void _reload() {
    setState(() {
      _future = StorageService.getMoods();
    });
  }

  DateTime _startDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 6);
  }

  /// 0 = six days ago ... 6 = today. Uses UTC maths so daylight-saving
  /// changes can never shift an entry into the wrong day.
  int _dayIndex(DateTime date) {
    final start = _startDate();

    return DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(start.year, start.month, start.day))
        .inDays;
  }

  List<MoodEntry> _weeklyMoods(List<MoodEntry> all) {
    return all.where((entry) {
      final index = _dayIndex(entry.date);
      return index >= 0 && index < 7;
    }).toList();
  }

  String _mostFrequentMood(List<MoodEntry> moods) {
    if (moods.isEmpty) return 'Not available';

    final counts = <String, int>{};

    for (final entry in moods) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  Widget _statCard(String title, String value, IconData icon) {
    final theme = Theme.of(context);
    final p = context.palette;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: p.primary, size: 25),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(title, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(List<MoodEntry> moods) {
    final theme = Theme.of(context);
    final p = context.palette;

    final startDate = _startDate();
    final dailyCounts = List<int>.filled(7, 0);

    for (final entry in moods) {
      final index = _dayIndex(entry.date);

      if (index >= 0 && index < 7) {
        dailyCounts[index]++;
      }
    }

    final highestCount = dailyCounts.reduce((a, b) => a > b ? a : b);
    const weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your activity',
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            'Mood check-ins over the last 7 days',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final date = DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day + index,
                );
                final count = dailyCounts[index];
                final isToday = index == 6;

                final barHeight =
                    count == 0 ? 6.0 : 14.0 + (count / highestCount) * 60;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$count', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Container(
                        height: barHeight,
                        width: 20,
                        decoration: BoxDecoration(
                          color: count == 0
                              ? p.border
                              : (isToday
                                  ? p.primary
                                  : p.primary.withValues(alpha: 0.7)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weekdayLetters[date.weekday - 1],
                        style: TextStyle(
                          fontSize: 11,
                          color: isToday ? p.primary : p.muted,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w400,
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

  Widget _buildContent(List<MoodEntry> allMoods) {
    final theme = Theme.of(context);
    final p = context.palette;

    final moods = _weeklyMoods(allMoods);

    final averageIntensity = moods.isEmpty
        ? 0.0
        : moods.fold<double>(
              0.0,
              (total, entry) => total + entry.intensity,
            ) /
            moods.length;

    final frequentMood = _mostFrequentMood(moods);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        // ---------- Hero ----------
        Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [p.heroStart, p.heroEnd],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.insights_rounded, color: p.onHero, size: 32),
              const SizedBox(height: 14),
              Text(
                'Your week, in reflection',
                style: TextStyle(
                  color: p.onHero,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a gentle look at your emotional journey. Every feeling deserves attention.',
                style: TextStyle(
                  color: p.onHero.withValues(alpha: 0.92),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ---------- Stats ----------
        Row(
          children: [
            _statCard(
              'Check-ins',
              '${moods.length}',
              Icons.edit_calendar_rounded,
            ),
            const SizedBox(width: 13),
            _statCard(
              'Average intensity',
              moods.isEmpty ? '--' : averageIntensity.toStringAsFixed(1),
              Icons.show_chart_rounded,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ---------- Most frequent mood ----------
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  moods.isEmpty ? '💚' : MoodCatalog.emoji(frequentMood),
                  style: const TextStyle(fontSize: 27),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Most frequent mood',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      frequentMood,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildWeeklyChart(moods),
        const SizedBox(height: 20),

        // ---------- Reminder ----------
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: p.surfaceAlt,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_outline_rounded, color: p.primary),
                  const SizedBox(width: 9),
                  Text(
                    'A gentle reminder',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                moods.isEmpty
                    ? 'Your weekly story has not started yet. Add a mood check-in whenever you feel ready.'
                    : 'You recorded ${moods.length} check-ins this week. Take time to appreciate your effort and keep making space for your feelings.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  height: 1.6,
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
      appBar: AppBar(title: const Text('Weekly Summary')),
      body: FutureBuilder<List<MoodEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unable to prepare your weekly summary. Please try again.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildContent(snapshot.data ?? []);
        },
      ),
    );
  }
}