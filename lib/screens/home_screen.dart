import 'package:flutter/material.dart';

import '../providers/theme_controller.dart';
import '../theme/app_theme.dart';
import 'breathing_screen.dart';
import 'grounding_screen.dart';
import 'history_screen.dart';
import 'mood_calendar_screen.dart';
import 'mood_checkin_screen.dart';
import 'weekly_summary_screen.dart';

class HomeScreen extends StatelessWidget {
  final ThemeController themeController;

  const HomeScreen({
    super.key,
    required this.themeController,
  });

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header ----------
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.spa_outlined,
                      color: p.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MindCheck',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 21,
                          ),
                        ),
                        Text(
                          'Your personal wellbeing space',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: isDark
                        ? 'Switch to light mode'
                        : 'Switch to dark mode',
                    onPressed: () {
                      themeController.setDarkMode(!themeController.isDarkMode);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: p.surfaceAlt,
                      foregroundColor: p.primary,
                    ),
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ---------- Greeting ----------
              Text(
                _greeting(),
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 29),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a moment for yourself. Your feelings matter.',
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 26),

              // ---------- Hero card ----------
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [p.heroStart, p.heroEnd],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: p.heroEnd.withValues(alpha: 0.28),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -36,
                        top: -36,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.onHero.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        bottom: -50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.onHero.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.wb_sunny_outlined,
                                    color: p.onHero,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 9),
                                  Text(
                                    'A moment for you',
                                    style: TextStyle(
                                      color: p.onHero,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'How are you feeling today?',
                                style: TextStyle(
                                  color: p.onHero,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                'Check in with your emotions and give yourself space to reflect.',
                                style: TextStyle(
                                  color: p.onHero.withValues(alpha: 0.92),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _open(context, const MoodCheckinScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.onHero,
                                    foregroundColor: p.heroEnd,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start Mood Check-in'),
                                      SizedBox(width: 9),
                                      Icon(Icons.arrow_forward_rounded, size: 19),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ---------- Explore ----------
              Text(
                'Explore MindCheck',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Small steps towards a healthier mind.',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 16),
              _featureRow(
                _FeatureCard(
                  icon: Icons.history_rounded,
                  title: 'Mood History',
                  subtitle: 'Look back at your feelings and entries.',
                  onTap: () => _open(context, const HistoryScreen()),
                ),
                _FeatureCard(
                  icon: Icons.insights_rounded,
                  title: 'Weekly Summary',
                  subtitle: 'Understand your mood patterns this week.',
                  onTap: () => _open(context, const WeeklySummaryScreen()),
                ),
              ),
              const SizedBox(height: 14),
              _featureRow(
                _FeatureCard(
                  icon: Icons.air_rounded,
                  title: 'Guided Breathing',
                  subtitle: 'Relax with a simple breathing exercise.',
                  onTap: () => _open(context, const BreathingScreen()),
                ),
                _FeatureCard(
                  icon: Icons.spa_outlined,
                  title: 'Grounding',
                  subtitle: 'Reconnect with the present moment.',
                  onTap: () => _open(context, const GroundingScreen()),
                ),
              ),
              const SizedBox(height: 14),
              _FeatureCard(
                wide: true,
                icon: Icons.calendar_month_rounded,
                title: 'Mood Calendar',
                subtitle: 'Explore your emotional journey day by day.',
                onTap: () => _open(context, const MoodCalendarScreen()),
              ),
              const SizedBox(height: 26),

              // ---------- Reminder ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.self_improvement_outlined,
                      size: 38,
                      color: p.primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A gentle reminder',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'You do not have to figure everything out today. Take one small step at a time.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  'Small steps can make a difference.',
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

Widget _featureRow(Widget left, Widget right) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: left),
        const SizedBox(width: 14),
        Expanded(child: right),
      ],
    ),
  );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.wide = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;

    final badge = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: p.primary, size: 26),
    );

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12.5,
            height: 1.4,
          ),
        ),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: p.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: p.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: wide
                ? Row(
                    children: [
                      badge,
                      const SizedBox(width: 16),
                      Expanded(child: texts),
                      Icon(Icons.chevron_right_rounded, color: p.muted),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      badge,
                      const SizedBox(height: 16),
                      texts,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}