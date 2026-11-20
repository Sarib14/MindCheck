import 'package:flutter/material.dart';

import '../models/mood_catalog.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

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

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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

  String formatDate(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${date.day} ${_months[date.month - 1]} ${date.year} · $hour:$minute';
  }

  List<String> get filterOptions {
    final customMoods = moods
        .map((entry) => entry.mood)
        .where((mood) => !MoodCatalog.defaultMoods.contains(mood))
        .toSet()
        .toList();

    return ['All', ...MoodCatalog.defaultMoods, ...customMoods];
  }

  /// Falls back to "All" if the selected mood no longer exists
  /// (for example after the last entry of a custom mood was deleted).
  String get activeFilter {
    return filterOptions.contains(selectedFilter) ? selectedFilter : 'All';
  }

  List<MoodEntry> get filteredMoods {
    final searchText = searchController.text.toLowerCase().trim();
    final filter = activeFilter;

    return moods.where((entry) {
      final matchesFilter = filter == 'All' || entry.mood == filter;

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
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: dialogContext.palette.danger,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
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
        const SnackBar(content: Text('Mood entry deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to delete this entry.')),
      );
    }
  }

  Future<void> editMood(MoodEntry entry) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _EditEntryDialog(entry: entry),
    );

    if (updated == true && mounted) {
      await loadMoods();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood entry updated successfully.')),
      );
    }
  }

  Widget buildMoodCard(MoodEntry entry) {
    final theme = Theme.of(context);
    final p = context.palette;
    final accent = MoodCatalog.color(entry.mood);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  MoodCatalog.emoji(entry.mood),
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.mood, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
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
                icon: Icon(Icons.edit_outlined, color: p.primary),
              ),
              IconButton(
                tooltip: 'Delete entry',
                onPressed: () => deleteMood(entry),
                icon: Icon(Icons.delete_outline, color: p.danger),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Intensity', style: theme.textTheme.bodyMedium),
              Text(
                '${entry.intensity}/5 · ${MoodCatalog.intensityLabel(entry.intensity)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: p.heading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (entry.intensity / 5).clamp(0.0, 1.0),
            minHeight: 7,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: p.border,
            color: accent,
          ),
          if (entry.note.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: p.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Journal note', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 5),
                  Text(entry.note, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final p = context.palette;
    final options = filterOptions;
    final current = activeFilter;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = option == current;
          final label =
              option == 'All' ? 'All' : '${MoodCatalog.emoji(option)} $option';

          return ChoiceChip(
            label: Text(label),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) {
              setState(() {
                selectedFilter = option;
              });
            },
            backgroundColor: p.surface,
            selectedColor: p.surfaceAlt,
            side: BorderSide(color: selected ? p.primary : p.border),
            shape: const StadiumBorder(),
            labelStyle: TextStyle(
              color: selected ? p.heading : p.body,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              '${moods.length}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: p.primary,
                              ),
                            ),
                            Text(
                              moods.length == 1 ? 'entry' : 'entries',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search moods or journal notes',
                      prefixIcon: const Icon(Icons.search),
                      fillColor: p.surface,
                      suffixIcon: searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: searchController.clear,
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(errorMessage!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loadMoods,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          else if (visibleMoods.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, size: 55, color: p.primary),
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
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => buildMoodCard(visibleMoods[index]),
                  childCount: visibleMoods.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Edit dialog. It owns its own controllers and disposes them safely
/// when the dialog is really removed from the screen.
class _EditEntryDialog extends StatefulWidget {
  const _EditEntryDialog({required this.entry});

  final MoodEntry entry;

  @override
  State<_EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<_EditEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _moodController;
  late final TextEditingController _noteController;
  late int _intensity;
  bool _isSaving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _moodController = TextEditingController(text: widget.entry.mood);
    _noteController = TextEditingController(text: widget.entry.note);
    _intensity = widget.entry.intensity.clamp(1, 5).toInt();
  }

  @override
  void dispose() {
    _moodController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    final updatedEntry = widget.entry.copyWith(
      mood: _moodController.text.trim(),
      intensity: _intensity,
      note: _noteController.text.trim(),
    );

    try {
      await StorageService.updateMood(updatedEntry);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _saveError = 'Unable to update this entry. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;

    return AlertDialog(
      title: const Text('Edit Mood Entry'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _moodController,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Mood'),
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
              const SizedBox(height: 10),
              Text(
                'Mood intensity: $_intensity / 5',
                style: theme.textTheme.titleSmall,
              ),
              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _intensity.toString(),
                onChanged: (value) {
                  setState(() {
                    _intensity = value.round();
                  });
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLength: 500,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Journal Note',
                  hintText: 'Write about your feelings...',
                ),
              ),
              if (_saveError != null) ...[
                const SizedBox(height: 8),
                Text(_saveError!, style: TextStyle(color: p.danger)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: p.onPrimary,
                  ),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}