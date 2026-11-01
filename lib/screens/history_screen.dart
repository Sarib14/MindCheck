
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String formatDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day}/${localDate.month}/${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  String getMoodEmoji(String mood) {
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

  Color getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return const Color(0xFFE5F1E4);
      case 'Calm':
        return const Color(0xFFE5EDE7);
      case 'Excited':
        return const Color(0xFFFFF0D9);
      case 'Sad':
        return const Color(0xFFE7EAF5);
      case 'Anxious':
        return const Color(0xFFF8E9DC);
      case 'Angry':
        return const Color(0xFFF6E2E0);
      case 'Tired':
        return const Color(0xFFECE7F3);
      default:
        return const Color(0xFFE5EDE7);
    }
  }

  Future<void> deleteMood(
    BuildContext context,
    MoodEntry entry,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F7F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Delete Mood',
            style: TextStyle(
              color: Color(0xFF30483C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this mood entry?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) return;

    try {
      await StorageService.deleteMood(entry);

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HistoryScreen(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood entry deleted successfully.'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to delete mood. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget buildMoodCard(
    BuildContext context,
    MoodEntry entry,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: getMoodColor(entry.mood),
                  borderRadius: BorderRadius.circular(17),
                ),
                alignment: Alignment.center,
                child: Text(
                  getMoodEmoji(entry.mood),
                  style: const TextStyle(fontSize: 29),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.mood,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatDate(entry.date),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF78847B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EDE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${entry.intensity}/5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Delete mood',
                onPressed: () => deleteMood(context, entry),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFC76B65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppTheme.primaryColor,
                size: 17,
              ),
              const SizedBox(width: 7),
              const Text(
                'Mood intensity',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF78847B),
                ),
              ),
              const Spacer(),
              Text(
                '${entry.intensity} out of 5',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30483C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (entry.intensity.clamp(1, 5)) / 5,
              minHeight: 7,
              backgroundColor: const Color(0xFFE5EDE7),
              color: AppTheme.primaryColor,
            ),
          ),
          if (entry.note.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Your reflection',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF30483C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.note,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64766A),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        elevation: 0,
        title: const Text(
          'Mood History',
          style: TextStyle(
            color: Color(0xFF30483C),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF30483C),
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
              child: Text(
                'Unable to load mood history. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF78847B)),
              ),
            );
          }

          final moods = snapshot.data ?? [];

          if (moods.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5EDE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        size: 65,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Your story starts here',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'No mood entries found yet. Start your first mood check-in and your reflections will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF78847B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final sortedMoods = moods.reversed.toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your wellbeing journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Every check-in is a step towards understanding yourself.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.spa_outlined,
                      color: Colors.white,
                      size: 43,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your check-ins',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF78847B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${moods.length} mood ${moods.length == 1 ? 'entry' : 'entries'} saved',
                            style: const TextStyle(
                              fontSize: 19,
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
              const SizedBox(height: 25),
              const Text(
                'Your recent moods',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30483C),
                ),
              ),
              const SizedBox(height: 15),
              ...sortedMoods.map(
                (entry) => buildMoodCard(context, entry),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Keep checking in with yourself. Every feeling matters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF89948C),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

