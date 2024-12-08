import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF6200EE);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFFF5F5F5);
  
  static const spacing_xs = 4.0;
  static const spacing_sm = 8.0;
  static const spacing_md = 16.0;
  static const spacing_lg = 24.0;
  static const spacing_xl = 32.0;

  static const backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
      ],
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: primaryColor,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 