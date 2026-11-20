import 'package:flutter/material.dart';

import 'providers/theme_controller.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the saved theme BEFORE the first frame so the app never
  // flashes the wrong theme.
  final themeController = ThemeController();

  try {
    await themeController.loadTheme();
  } catch (_) {
    // If preferences cannot be read, fall back to the light theme.
  }

  runApp(MindCheckApp(themeController: themeController));
}

class MindCheckApp extends StatefulWidget {
  const MindCheckApp({
    super.key,
    this.themeController,
    this.showWelcome = true,
  });

  final ThemeController? themeController;

  /// The welcome screen is shown every time the app is opened fresh.
  /// Tests can pass false to start directly on the home screen.
  final bool showWelcome;

  @override
  State<MindCheckApp> createState() => _MindCheckAppState();
}

class _MindCheckAppState extends State<MindCheckApp> {
  late final ThemeController _themeController;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.themeController == null;
    _themeController = widget.themeController ?? ThemeController();

    if (_ownsController) {
      _themeController.loadTheme();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _themeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MindCheck',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: widget.showWelcome
              ? WelcomeScreen(themeController: _themeController)
              : HomeScreen(themeController: _themeController),
        );
      },
    );
  }
}