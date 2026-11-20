import 'package:flutter/material.dart';

import '../models/mood_catalog.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  String selectedMood = 'Happy';
  double moodIntensity = 3;
  bool isSaving = false;
  bool isCustomMood = false;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController customMoodController = TextEditingController();

  final List<String> moods = MoodCatalog.defaultMoods;

  Future<void> saveMood() async {
    if (isSaving) return;

    // Grab these before any await so we never use a stale context.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final customMood = customMoodController.text.trim();

    if (isCustomMood && customMood.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please enter your custom mood.')),
      );
      return;
    }

    final moodName = isCustomMood ? customMood : selectedMood;

    if (moodName.length > 40) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Mood name must be 40 characters or fewer.'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final entry = MoodEntry(
      mood: moodName,
      intensity: moodIntensity.round(),
      note: noteController.text.trim(),
      date: DateTime.now(),
    );

    try {
      await StorageService.saveMood(entry);

      if (!mounted) return;

      navigator.pop(true);

      messenger.showSnackBar(
        const SnackBar(content: Text('Mood saved successfully!')),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Unable to save mood. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    customMoodController.dispose();
    super.dispose();
  }

  Widget _card({required Widget child}) {
    final p = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.border),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;
    final intensity = moodIntensity.round();

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Check-in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Intro ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite_outline, color: p.primary, size: 32),
                    const SizedBox(height: 14),
                    Text(
                      'Your feelings matter.',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a moment to understand how you are feeling today. There are no right or wrong answers.',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ---------- Mood picker ----------
              Text('How are you feeling?', style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                'Choose the mood that describes you best.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moods.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final isCustomTile = index == moods.length;
                  final name = isCustomTile ? 'Custom' : moods[index];
                  final emoji = isCustomTile ? '✨' : MoodCatalog.emoji(name);

                  final isSelected = isCustomTile
                      ? isCustomMood
                      : !isCustomMood && selectedMood == name;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isCustomMood = isCustomTile;

                        if (!isCustomTile) {
                          selectedMood = name;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? p.surfaceAlt : p.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? p.primary : p.border,
                          width: isSelected ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 30)),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? p.heading : p.body,
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.check_circle,
                                color: p.primary,
                                size: 15,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (isCustomMood) ...[
                const SizedBox(height: 20),
                Text('Enter your mood', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: customMoodController,
                  maxLength: 40,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Overwhelmed, Grateful, Motivated...',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),
              ],
              const SizedBox(height: 26),

              // ---------- Intensity ----------
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intensity of your feeling',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'How strongly are you experiencing this mood?',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        '$intensity / 5',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: p.primary,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        MoodCatalog.intensityLabel(intensity),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Slider(
                      value: moodIntensity,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: intensity.toString(),
                      onChanged: (value) {
                        setState(() {
                          moodIntensity = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Low', style: theme.textTheme.bodySmall),
                        Text('High', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ---------- Journal ----------
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write about your feelings',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This is your private space. Share anything on your mind.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: noteController,
                      maxLines: 5,
                      maxLength: 500,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Write something about your day...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // ---------- Save ----------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveMood,
                  child: isSaving
                      ? SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: p.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_outline, size: 20),
                            SizedBox(width: 10),
                            Text('Save My Mood'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Your wellbeing journey starts with one small step.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}