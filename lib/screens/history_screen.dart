
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MoodEntry> moods = [];
  bool isLoading = true;
  String? errorMessage;

  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();

  final List<String> defaultMoods = [
    'Happy',
    'Calm',
    'Excited',
    'Sad',
    'Anxious',
    'Angry',
    'Tired',
  ];

  @override
  void initState() {
    super.initState();
    loadMoods();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadMoods() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final entries = await StorageService.getMoods();

      if (!mounted) return;

      setState(() {
        moods = entries;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load mood history.';
        isLoading = false;
      });
    }
  }

  String getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'calm':
        return '😌';
      case 'excited':
        return '🤩';
      case 'sad':
        return '😔';
      case 'anxious':
        return '😟';
      case 'angry':
        return '😠';
      case 'tired':
        return '😴';
      default:
        return '💚';
    }
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }

  List<String> get filterOptions {
    final customMoods = moods
        .map((entry) => entry.mood)
        .where((mood) => !defaultMoods.contains(mood))
        .toSet()
        .toList();

    return ['All', ...defaultMoods, ...customMoods];
  }

  List<MoodEntry> get filteredMoods {
    final searchText = searchController.text.toLowerCase().trim();

    return moods.where((entry) {
      final matchesFilter =
          selectedFilter == 'All' || entry.mood == selectedFilter;

      final matchesSearch =
          entry.mood.toLowerCase().contains(searchText) ||
          entry.note.toLowerCase().contains(searchText);

      return matchesFilter && matchesSearch;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteMood(MoodEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Entry'),
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await StorageService.deleteMood(entry);

      if (!mounted) return;

      await loadMoods();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood entry deleted successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to delete this entry.'),
        ),
      );
    }
  }

  Future<void> editMood(MoodEntry entry) async {
    final moodController = TextEditingController(text: entry.mood);
    final noteController = TextEditingController(text: entry.note);

    int intensity = entry.intensity;
    final formKey = GlobalKey<FormState>();

    final updated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Edit Mood Entry'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: moodController,
                        maxLength: 40,
                        decoration: const InputDecoration(
                          labelText: 'Mood',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a mood.';
                          }

                          if (value.trim().length > 40) {
                            return 'Mood must be 40 characters or less.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mood Intensity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: intensity.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: intensity.toString(),
                        onChanged: (value) {
                          updateDialog(() {
                            intensity = value.round();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: noteController,
                        maxLength: 500,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Journal Note',
                          hintText: 'Write about your feelings...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final updatedEntry = entry.copyWith(
                      mood: moodController.text.trim(),
                      intensity: intensity,
                      note: noteController.text.trim(),
                    );

                    try {
                      await StorageService.updateMood(updatedEntry);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext, true);
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Unable to update this entry.'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );

    moodController.dispose();
    noteController.dispose();

    if (updated == true && mounted) {
      await loadMoods();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood entry updated successfully.'),
        ),
      );
    }
  }

  Widget buildMoodCard(MoodEntry entry) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      color: theme.cardColor,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  getMoodEmoji(entry.mood),
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.mood,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        formatDate(entry.date),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit entry',
                  onPressed: () => editMood(entry),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: colors.primary,
                  ),
                ),
                IconButton(
                  tooltip: 'Delete entry',
                  onPressed: () => deleteMood(entry),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Intensity: ${entry.intensity}/5',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: entry.intensity / 5,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: colors.surfaceContainerHighest,
              color: colors.primary,
            ),
            if (entry.note.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Journal Note',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 5),
              Text(
                entry.note,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final visibleMoods = filteredMoods;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        actions: [
          IconButton(
            onPressed: loadMoods,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh history',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Emotional Journey',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Review your moods and personal reflections.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${moods.length} mood entries saved',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search moods or journal notes',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: searchController.clear,
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedFilter,
              decoration: InputDecoration(
                labelText: 'Filter by mood',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: filterOptions.map((mood) {
                return DropdownMenuItem<String>(
                  value: mood,
                  child: Text(mood),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedFilter = value;
                });
              },
            ),
            const SizedBox(height: 18),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(errorMessage!),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: loadMoods,
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        )
                      : visibleMoods.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 55,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    moods.isEmpty
                                        ? 'No mood entries yet.'
                                        : 'No matching entries found.',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    moods.isEmpty
                                        ? 'Start a mood check-in to see your history.'
                                        : 'Try another search or mood filter.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: visibleMoods.length,
                              itemBuilder: (context, index) {
                                return buildMoodCard(
                                  visibleMoods[index],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
