
import 'package:flutter/material.dart';
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
  final TextEditingController customMoodController =
      TextEditingController();

  final List<Map<String, String>> moods = [
    {'name': 'Happy', 'emoji': '😊'},
    {'name': 'Calm', 'emoji': '😌'},
    {'name': 'Excited', 'emoji': '🤩'},
    {'name': 'Sad', 'emoji': '😔'},
    {'name': 'Anxious', 'emoji': '😟'},
    {'name': 'Angry', 'emoji': '😠'},
    {'name': 'Tired', 'emoji': '😴'},
  ];

  Future<void> saveMood() async {
    if (isSaving) return;

    final customMood = customMoodController.text.trim();

    if (isCustomMood && customMood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your custom mood.'),
        ),
      );
      return;
    }

    final moodName = isCustomMood ? customMood : selectedMood;

    if (moodName.length > 40) {
      ScaffoldMessenger.of(context).showSnackBar(
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

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood saved successfully!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save mood. Please try again.'),
          backgroundColor: Colors.redAccent,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Check-in'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: colors.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Your feelings matter.',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a moment to understand how you are feeling today. There are no right or wrong answers.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'How are you feeling?',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              Text(
                'Choose the mood that describes you best.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moods.length + 1,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final isCustomTile = index == moods.length;

                  final mood = isCustomTile
                      ? {'name': 'Custom', 'emoji': '✨'}
                      : moods[index];

                  final isSelected = isCustomTile
                      ? isCustomMood
                      : !isCustomMood && selectedMood == mood['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isCustomMood = isCustomTile;

                        if (!isCustomTile) {
                          selectedMood = mood['name']!;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.secondaryContainer
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? colors.primary
                              : colors.outlineVariant,
                          width: isSelected ? 1.8 : 0.8,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood['emoji']!,
                            style: const TextStyle(fontSize: 31),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood['name']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colors.primary,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (isCustomMood) ...[
                const SizedBox(height: 20),
                Text(
                  'Enter your mood',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intensity of your feeling',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How strongly are you experiencing this mood?',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        '${moodIntensity.round()} / 5',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    Slider(
                      value: moodIntensity,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: moodIntensity.round().toString(),
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
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write about your feelings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'This is your private space. Share anything on your mind.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: noteController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        hintText: 'Write something about your day...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveMood,
                  child: isSaving
                      ? const SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: Colors.white,
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
              const SizedBox(height: 15),
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
