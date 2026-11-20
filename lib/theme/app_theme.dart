import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.heading,
    required this.body,
    required this.muted,
    required this.primary,
    required this.onPrimary,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.danger,
    required this.shadow,
    required this.snackBar,
    required this.onSnackBar,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color heading;
  final Color body;
  final Color muted;
  final Color primary;
  final Color onPrimary;
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;
  final Color danger;
  final Color shadow;
  final Color snackBar;
  final Color onSnackBar;

  static const AppPalette light = AppPalette(
    background: Color(0xFFF5F7F2),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFE3EDE5),
    border: Color(0xFFD5E0D8),
    heading: Color(0xFF294D3B),
    body: Color(0xFF5A695F),
    muted: Color(0xFF7D8A81),
    primary: Color(0xFF4F7A63),
    onPrimary: Colors.white,
    heroStart: Color(0xFF548068),
    heroEnd: Color(0xFF3B6650),
    onHero: Colors.white,
    danger: Color(0xFFB3402F),
    shadow: Color(0x14294D3B),
    snackBar: Color(0xFF2F4A3B),
    onSnackBar: Colors.white,
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF17231D),
    surface: Color(0xFF22332A),
    surfaceAlt: Color(0xFF2D4437),
    border: Color(0xFF3A5143),
    heading: Color(0xFFE5F0E8),
    body: Color(0xFFB8C8BD),
    muted: Color(0xFF8EA196),
    primary: Color(0xFF8EB69D),
    onPrimary: Color(0xFF10201A),
    heroStart: Color(0xFF3A5C4A),
    heroEnd: Color(0xFF2A4537),
    onHero: Color(0xFFF1F7F3),
    danger: Color(0xFFFF8A80),
    shadow: Color(0x66000000),
    snackBar: Color(0xFFE5F0E8),
    onSnackBar: Color(0xFF17231D),
  );
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
}

class AppTheme {
  AppTheme._();

  /// Brand sage green.
  static const Color primaryColor = Color(0xFF648C78);

  static ThemeData get lightTheme =>
      _build(AppPalette.light, Brightness.light);

  static ThemeData get darkTheme => _build(AppPalette.dark, Brightness.dark);

  static OutlineInputBorder _outline(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondaryContainer: p.surfaceAlt,
      onSecondaryContainer: p.heading,
      surface: p.surface,
      onSurface: p.heading,
      onSurfaceVariant: p.body,
      surfaceContainerHighest: p.surfaceAlt,
      outline: p.muted,
      outlineVariant: p.border,
      error: p.danger,
    );

    final applied = base.textTheme.apply(
      bodyColor: p.body,
      displayColor: p.heading,
    );

    final textTheme = applied.copyWith(
      headlineMedium: applied.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: p.heading,
        height: 1.2,
      ),
      titleLarge: applied.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: p.heading,
      ),
      titleMedium: applied.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: p.heading,
      ),
      titleSmall: applied.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: p.heading,
      ),
      bodyLarge: applied.bodyLarge?.copyWith(
        fontSize: 16,
        color: p.body,
        height: 1.5,
      ),
      bodyMedium: applied.bodyMedium?.copyWith(
        fontSize: 14,
        color: p.body,
        height: 1.45,
      ),
      bodySmall: applied.bodySmall?.copyWith(
        fontSize: 12,
        color: p.muted,
      ),
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      cardColor: p.surface,
      dividerColor: p.border,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.heading,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: p.heading,
        ),
        iconTheme: IconThemeData(color: p.heading),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: p.muted),
        labelStyle: TextStyle(color: p.body),
        floatingLabelStyle: TextStyle(color: p.primary),
        errorStyle: TextStyle(color: p.danger),
        counterStyle: TextStyle(color: p.muted),
        prefixIconColor: p.muted,
        suffixIconColor: p.muted,
        border: _outline(p.border),
        enabledBorder: _outline(p.border),
        focusedBorder: _outline(p.primary, width: 1.6),
        errorBorder: _outline(p.danger),
        focusedErrorBorder: _outline(p.danger, width: 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          disabledBackgroundColor: p.surfaceAlt,
          disabledForegroundColor: p.muted,
          minimumSize: const Size(64, 52),
          elevation: 0,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          disabledBackgroundColor: p.surfaceAlt,
          disabledForegroundColor: p.muted,
          minimumSize: const Size(64, 52),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: p.primary.withValues(alpha: 0.5)),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 5,
        activeTrackColor: p.primary,
        inactiveTrackColor: p.border,
        thumbColor: p.primary,
        overlayColor: p.primary.withValues(alpha: 0.12),
        valueIndicatorColor: p.primary,
        valueIndicatorTextStyle: TextStyle(
          color: p.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.border,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.snackBar,
        contentTextStyle: TextStyle(color: p.onSnackBar, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: p.heading,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: p.body,
        ),
      ),
    );
  }
}