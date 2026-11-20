import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  Timer? timer;

  final List<String> phases = ['Inhale', 'Hold', 'Exhale'];
  final List<int> durations = [4, 4, 6];
  final List<String> instructions = [
    'Breathe in slowly through your nose.',
    'Gently hold your breath.',
    'Slowly breathe out through your mouth.',
  ];

  int phaseIndex = 0;
  int secondsLeft = 4;
  bool isRunning = false;
  int completedCycles = 0;

  void startBreathing() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (secondsLeft > 1) {
          secondsLeft--;
        } else {
          if (phaseIndex == 2) {
            completedCycles++;
          }

          phaseIndex = (phaseIndex + 1) % phases.length;
          secondsLeft = durations[phaseIndex];
        }
      });
    });
  }

  void pauseBreathing() {
    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetBreathing() {
    timer?.cancel();

    setState(() {
      isRunning = false;
      phaseIndex = 0;
      secondsLeft = durations[0];
      completedCycles = 0;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;

    final isExpanded = phaseIndex != 2;

    // The circle animation lasts as long as the breathing phase,
    // so it grows and shrinks in time with the countdown.
    final circleDuration = isRunning
        ? Duration(seconds: durations[phaseIndex])
        : const Duration(milliseconds: 400);

    const tips = [
      'Find a quiet and comfortable place.',
      'Relax your shoulders and jaw.',
      'Breathe gently without forcing it.',
      'Stop if you feel dizzy or uncomfortable.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Guided Breathing')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Column(
            children: [
              Text(
                'Take a moment to breathe',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 23),
              ),
              const SizedBox(height: 8),
              Text(
                'Relax your body and follow the breathing guide.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Fixed-size box so the layout below never jumps
              // while the circle grows and shrinks.
              SizedBox(
                height: 260,
                child: Center(
                  child: AnimatedContainer(
                    duration: circleDuration,
                    curve: Curves.easeInOut,
                    width: isExpanded ? 230 : 160,
                    height: isExpanded ? 230 : 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.surfaceAlt,
                      border: Border.all(
                        color: p.primary.withValues(alpha: 0.4),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: p.primary.withValues(alpha: 0.18),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          phases[phaseIndex],
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$secondsLeft ${secondsLeft == 1 ? 'second' : 'seconds'}',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                instructions[phaseIndex],
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: isRunning ? pauseBreathing : startBreathing,
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(isRunning ? 'Pause' : 'Start'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: resetBreathing,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- Progress ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text('Your progress', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      completedCycles == 1
                          ? '1 breathing cycle completed'
                          : '$completedCycles breathing cycles completed',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ---------- Tips ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: p.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Tips',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 17,
                                color: p.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tip,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}