import 'package:flutter/material.dart';
import 'package:love_days/utils/app_colors.dart';

class AppTheme {
  static ThemeData buildTheme(TextTheme baseTextTheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accentOrange,
      brightness: Brightness.dark,
    );

    final textTheme = _buildTextTheme(baseTextTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.appBlack,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerTheme: DividerThemeData(
        color: AppColors.whiteA(0.08),
        thickness: 1,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accentOrange,
        selectionColor: AppColors.accentOrange.withValues(alpha: 0.28),
        selectionHandleColor: AppColors.accentOrange,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentOrange,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          side: BorderSide(color: AppColors.whiteA(0.16)),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.accentOrange,
        unselectedLabelColor: Colors.white38,
        indicatorColor: AppColors.accentOrange,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white24),
        labelStyle: textTheme.bodyMedium,
        filled: true,
        fillColor: AppColors.whiteA(0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.whiteA(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              const BorderSide(color: AppColors.accentOrange, width: 1.2),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    // Small, consistent type scale across the app.
    // Prefer semantic styles (see `lib/theme/app_text.dart`) over ad-hoc sizing.
    return base.copyWith(
      // Heading
      displayLarge: base.displayLarge?.copyWith(fontSize: 24),
      displayMedium: base.displayMedium?.copyWith(fontSize: 24),
      displaySmall: base.displaySmall?.copyWith(fontSize: 24),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 24),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 24),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 24),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
      ),

      // Subheading
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),

      // Body
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),

      // Labels
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
