import 'package:flutter/material.dart';

import '../models/mood_catalog.dart';
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
    'September', 'October', 'November', 'December',
  ];

  final List<String> weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
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

  void changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
      );

      selectedDate = displayedMonth;
    });
  }

  void goToToday() {
    final now = DateTime.now();

    setState(() {
      displayedMonth = now;
      selectedDate = now;
    });
  }

  String _time(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Calendar'),
        actions: [
          IconButton(
            tooltip: 'Jump to today',
            onPressed: goToToday,
            icon: const Icon(Icons.today_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage!,
                          style: theme.textTheme.bodyMedium,
                        ),
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
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: p.border),
                            boxShadow: [
                              BoxShadow(
                                color: p.shadow,
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    tooltip: 'Previous month',
                                    onPressed: () => changeMonth(-1),
                                    style: IconButton.styleFrom(
                                      backgroundColor: p.surfaceAlt,
                                      foregroundColor: p.primary,
                                    ),
                                    icon: const Icon(
                                      Icons.chevron_left_rounded,
                                    ),
                                  ),
                                  Text(
                                    '${monthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(fontSize: 18),
                                  ),
                                  IconButton(
                                    tooltip: 'Next month',
                                    onPressed: () => changeMonth(1),
                                    style: IconButton.styleFrom(
                                      backgroundColor: p.surfaceAlt,
                                      foregroundColor: p.primary,
                                    ),
                                    icon: const Icon(
                                      Icons.chevron_right_rounded,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: weekdays.map((day) {
                                  return Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: p.muted,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              buildCalendarGrid(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Mood activity',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontSize: 20),
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
    final p = context.palette;

    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);

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
              color: isSelected ? p.surfaceAlt : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday
                  ? Border.all(color: p.primary, width: 1.4)
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
                        isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                    color: p.heading,
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
                          color: MoodCatalog.color(entry.mood),
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
    final theme = Theme.of(context);
    final p = context.palette;
    final dayEntries = entriesForDate(selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          if (dayEntries.isEmpty)
            Text(
              'No mood recorded on this day. Every day is a fresh opportunity to check in with yourself.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            )
          else
            ...dayEntries.map((entry) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: p.background,
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
                        color: MoodCatalog.color(entry.mood),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${MoodCatalog.emoji(entry.mood)} ${entry.mood}',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Intensity: ${entry.intensity}/5 · ${_time(entry.date)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          if (entry.note.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            Text(
                              entry.note,
                              style: theme.textTheme.bodyMedium?.copyWith(
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
    final theme = Theme.of(context);

    const names = [
      'Happy / Excited',
      'Calm',
      'Sad',
      'Anxious',
      'Angry',
      'Tired',
      'Custom',
    ];

    const colorKeys = [
      'Happy',
      'Calm',
      'Sad',
      'Anxious',
      'Angry',
      'Tired',
      'Custom',
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 12,
      children: List.generate(names.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: MoodCatalog.color(colorKeys[index]),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              names[index],
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }
}