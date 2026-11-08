
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_controller.dart';

void main() {
  runApp(const MindCheckApp());
}

class MindCheckApp extends StatefulWidget {
  const MindCheckApp({super.key});

  @override
  State<MindCheckApp> createState() => _MindCheckAppState();
}

class _MindCheckAppState extends State<MindCheckApp> {
  final ThemeController themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    themeController.loadTheme();
  }

  @override
  void dispose() {
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MindCheck',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: HomeScreen(
            themeController: themeController,
          ),
        );
      },
    );
  }
}
