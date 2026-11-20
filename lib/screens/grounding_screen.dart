import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  int currentStep = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'number': '5',
      'sense': 'SEE',
      'instruction': 'Notice 5 things you can see around you.',
      'icon': Icons.visibility_outlined,
    },
    {
      'number': '4',
      'sense': 'FEEL',
      'instruction': 'Notice 4 things you can physically feel.',
      'icon': Icons.back_hand_outlined,
    },
    {
      'number': '3',
      'sense': 'HEAR',
      'instruction': 'Notice 3 sounds you can hear.',
      'icon': Icons.hearing_outlined,
    },
    {
      'number': '2',
      'sense': 'SMELL',
      'instruction': 'Notice 2 things you can smell.',
      'icon': Icons.air,
    },
    {
      'number': '1',
      'sense': 'TASTE',
      'instruction': 'Notice 1 thing you can taste.',
      'icon': Icons.restaurant_outlined,
    },
  ];

  void nextStep() {
    setState(() {
      if (currentStep < steps.length - 1) {
        currentStep++;
      } else {
        currentStep = steps.length;
      }
    });
  }

  void previousStep() {
    if (currentStep > 0 && currentStep < steps.length) {
      setState(() {
        currentStep--;
      });
    }
  }

  void restart() {
    setState(() {
      currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = context.palette;

    // ---------- Completed ----------
    if (currentStep == steps.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Grounding Exercise')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.surfaceAlt,
                      ),
                      child: Icon(
                        Icons.spa_outlined,
                        size: 64,
                        color: p.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Well done!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You have completed the 5–4–3–2–1 grounding exercise. Take a slow breath and notice how you feel.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Finish'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: restart,
                    child: const Text('Do it again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ---------- Steps ----------
    final step = steps[currentStep];

    return Scaffold(
      appBar: AppBar(title: const Text('Grounding Exercise')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Step ${currentStep + 1} of ${steps.length}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: (currentStep + 1) / steps.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 36),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    key: ValueKey<int>(currentStep),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.surfaceAlt,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 56,
                            color: p.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        step['number'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w700,
                          color: p.primary,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        step['sense'] as String,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        step['instruction'] as String,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    if (currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: previousStep,
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: nextStep,
                        child: Text(
                          currentStep == steps.length - 1
                              ? 'Complete'
                              : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}