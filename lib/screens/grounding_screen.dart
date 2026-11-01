
import 'package:flutter/material.dart';

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
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      setState(() {
        currentStep = steps.length;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0 && currentStep < steps.length) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == steps.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Grounding Exercise')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.spa_outlined,
                  size: 80,
                  color: Color(0xFF648C78),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Well done!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You have completed the 5–4–3–2–1 grounding exercise. Take a slow breath and notice how you feel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Finish'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final step = steps[currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grounding Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${currentStep + 1} of 5',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (currentStep + 1) / steps.length,
              color: const Color(0xFF648C78),
              backgroundColor: const Color(0xFFE5EDE7),
            ),
            const SizedBox(height: 40),
            Icon(
              step['icon'] as IconData,
              size: 75,
              color: const Color(0xFF648C78),
            ),
            const SizedBox(height: 24),
            Text(
              step['number'] as String,
              style: const TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Color(0xFF648C78),
              ),
            ),
            Text(
              step['sense'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              step['instruction'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: previousStep,
                      child: const Text('Previous'),
                    ),
                  ),
                if (currentStep > 0)
                  const SizedBox(width: 12),
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
    );
  }
}
