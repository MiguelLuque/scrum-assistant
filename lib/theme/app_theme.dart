import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color primaryColor = Color(0xFF2196F3); // Example blue
  static const Color secondaryColor = Color(0xFF512DA8); // Example deep purple
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color columnBackgroundColor = Color(0xFFF5F7FA);
  static const Color dragTargetColor = Color(0xFFE3E8EF);
  static const Color progressBarBackground = Color(0xFFE0E0E0);
  static const Color progressBarForeground = Color(0xFF4CAF50);
  static const Color backgroundOverlayColor = Color(0x0A000000);

  // Card & Surface colors
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Text colors
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);

  // Spacing
  static const double spacing_xs = 4.0;
  static const double spacing_sm = 8.0;
  static const double spacing_md = 16.0;
  static const double spacing_lg = 24.0;
  static const double spacing_xl = 32.0;
  static const double columnWidth = 300.0;
  static const double columnSpacing = 16.0;
  static const double cardSpacing = 8.0;

  // Border Radius
  static const double borderRadius_sm = 4.0;
  static const double borderRadius_md = 8.0;
  static const double borderRadius_lg = 12.0;

  // Elevation
  static const double elevation_sm = 1.0;
  static const double elevation_md = 2.0;
  static const double elevation_lg = 4.0;

  // Get the theme data
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,

      // Card Theme
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: elevation_sm,
        margin: EdgeInsets.all(spacing_sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius_md),
          ),
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: elevation_sm,
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: primaryTextColor,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: primaryTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: secondaryTextColor,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.all(spacing_md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius_md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius_md),
          borderSide: BorderSide(
            color: secondaryTextColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius_md),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius_md),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing_lg,
            vertical: spacing_md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius_md),
          ),
        ),
      ),
    );
  }

  // Custom styles for Kanban board
  static BoxDecoration get kanbanColumnDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius_md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get kanbanTaskDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius_md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      );

  static BoxDecoration get columnDecoration => BoxDecoration(
        color: columnBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius_lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get taskCardDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius_md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      );

  static TextStyle get columnHeaderStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      );

  static TextStyle get taskTitleStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      );

  static TextStyle get taskDescriptionStyle => const TextStyle(
        fontSize: 14,
        color: secondaryTextColor,
      );

  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);

  static BoxDecoration get backgroundDecoration => const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_img.jpg'),
          fit: BoxFit.cover,
          opacity: 1.0,
        ),
      );
}
