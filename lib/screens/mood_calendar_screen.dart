
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class MoodCalendarScreen extends StatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  State<MoodCalendarScreen> createState() => _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends State<MoodCalendarScreen> {
  List<MoodEntry> entries = [];
  bool isLoading = true;
  String? errorMessage;

  DateTime displayedMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  final List<String> monthNames = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  final List<String> weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final savedEntries = await StorageService.getMoods();

      if (!mounted) return;

      setState(() {
        entries = savedEntries;
        isLoading = false;
        errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load your mood calendar.';
      });
    }
  }

  String dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  List<MoodEntry> entriesForDate(DateTime date) {
    return entries.where((entry) {
      return dateKey(entry.date) == dateKey(date);
    }).toList();
  }

  Color moodColor(String mood) {
    switch (mood.toLowerCase()) {
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
        return AppTheme.primaryColor;
    }
  }

  void changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
      );

      selectedDate = displayedMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Mood Calendar'),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.headingColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorMessage!),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            loadEntries();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => changeMonth(-1),
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Text(
                                    '${monthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.headingColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => changeMonth(1),
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: weekdays.map((day) {
                                  return Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              buildCalendarGrid(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Mood activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.headingColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        buildSelectedDay(),
                        const SizedBox(height: 22),
                        buildLegend(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget buildCalendarGrid() {
    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    final offset = firstDay.weekday - 1;
    final totalCells = ((offset + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - offset + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          dayNumber,
        );

        final dayEntries = entriesForDate(date);
        final isSelected = dateKey(date) == dateKey(selectedDate);
        final isToday = dateKey(date) == dateKey(DateTime.now());

        return InkWell(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accentColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday
                  ? Border.all(color: AppTheme.primaryColor)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: AppTheme.headingColor,
                  ),
                ),
                const SizedBox(height: 5),
                if (dayEntries.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dayEntries.take(3).map((entry) {
                      return Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: moodColor(entry.mood),
                        ),
                      );
                    }).toList(),
                  )
                else
                  const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSelectedDay() {
    final dayEntries = entriesForDate(selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.headingColor,
            ),
          ),
          const SizedBox(height: 14),
          if (dayEntries.isEmpty)
            const Text(
              'No mood recorded on this day. Every day is a fresh opportunity to check in with yourself.',
              style: TextStyle(
                color: AppTheme.textColor,
                height: 1.5,
              ),
            )
          else
            ...dayEntries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: moodColor(entry.mood),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.mood,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.headingColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Intensity: ${entry.intensity}/5',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textColor,
                            ),
                          ),
                          if (entry.note.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            Text(
                              entry.note,
                              style: const TextStyle(
                                color: AppTheme.textColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget buildLegend() {
    final colors = [
      moodColor('Happy'),
      moodColor('Calm'),
      moodColor('Sad'),
      moodColor('Anxious'),
      moodColor('Angry'),
      moodColor('Tired'),
    ];

    final names = [
      'Happy',
      'Calm',
      'Sad',
      'Anxious',
      'Angry',
      'Tired',
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 12,
      children: List.generate(names.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              names[index],
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textColor,
              ),
            ),
          ],
        );
      }),
    );
  }
}
