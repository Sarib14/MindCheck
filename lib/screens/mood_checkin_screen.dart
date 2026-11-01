
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

  final TextEditingController noteController = TextEditingController();

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

    setState(() {
      isSaving = true;
    });

    final entry = MoodEntry(
      mood: selectedMood,
      intensity: moodIntensity.round(),
      note: noteController.text.trim(),
      date: DateTime.now(),
    );

    final messenger = ScaffoldMessenger.of(context);

    try {
      await StorageService.saveMood(entry);

      if (!mounted) return;

      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Mood saved successfully!'),
          backgroundColor: Color(0xFF648C78),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      messenger.showSnackBar(
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        elevation: 0,
        title: const Text(
          'Mood Check-in',
          style: TextStyle(
            color: Color(0xFF30483C),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF30483C),
        ),
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
                  color: const Color(0xFFE5EDE7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Your feelings matter.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Take a moment to understand how you are feeling today. There are no right or wrong answers.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64766A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30483C),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Choose the mood that describes you best.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF78847B),
                ),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moods.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedMood == mood['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedMood = mood['name']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFDCE9DF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          width: 1.8,
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
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: const Color(0xFF30483C),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Intensity of your feeling',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'How strongly are you experiencing this mood?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF78847B),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        '${moodIntensity.round()} / 5',
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.primaryColor,
                        inactiveTrackColor: const Color(0xFFE5EDE7),
                        thumbColor: AppTheme.primaryColor,
                        overlayColor:
                            AppTheme.primaryColor.withValues(alpha: 0.12),
                        trackHeight: 6,
                      ),
                      child: Slider(
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
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Low',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF78847B),
                          ),
                        ),
                        Text(
                          'High',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF78847B),
                          ),
                        ),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Write about your feelings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30483C),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'This is your private space. Share anything on your mind.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF78847B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: noteController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Write something about your day...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9AA49D),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5EDE7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                        ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppTheme.primaryColor.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    elevation: 2,
                  ),
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
                            Text(
                              'Save My Mood',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Your wellbeing journey starts with one small step.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF89948C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
