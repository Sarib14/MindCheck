
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
    final isExpanded = phaseIndex != 2;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Guided Breathing'),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.headingColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Text(
                'Take a moment to breathe',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.headingColor,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Relax your body and follow the breathing guide.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 35),
              AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: isExpanded ? 220 : 165,
                height: isExpanded ? 220 : 165,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor,
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.35),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phases[phaseIndex],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.headingColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$secondsLeft seconds',
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                instructions[phaseIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.headingColor,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: isRunning
                        ? pauseBreathing
                        : startBreathing,
                    icon: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(isRunning ? 'Pause' : 'Start'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: resetBreathing,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.headingColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$completedCycles breathing cycles completed',
                      style: const TextStyle(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Tips',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.headingColor,
                      ),
                    ),
                    SizedBox(height: 13),
                    Text('• Find a quiet and comfortable place.'),
                    SizedBox(height: 9),
                    Text('• Relax your shoulders and jaw.'),
                    SizedBox(height: 9),
                    Text('• Breathe gently without forcing it.'),
                    SizedBox(height: 9),
                    Text('• Stop if you feel dizzy or uncomfortable.'),
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
