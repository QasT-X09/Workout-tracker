import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF4F46E5); // indigo
  static const Color _purpleAccent = Color(0xFF7C3AED);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withAlpha(26),
          indicatorColor: _seedColor.withAlpha(51),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Color(0x26FFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: const Color(0x1AFFFFFF),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0x1A000000),
          indicatorColor: _purpleAccent.withAlpha(77),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E1B4B), // deep indigo
          Color(0xFF312E81),
          Color(0xFF4C1D95), // deep purple
        ],
      );

  static LinearGradient get backgroundGradientLight => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFEEF2FF),
          Color(0xFFF5F3FF),
          Color(0xFFFAF5FF),
        ],
      );
}
