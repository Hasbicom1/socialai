import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the social media aggregation application.
/// Implements Adaptive Dark Intelligence theme with Intelligent Minimalism design principles.
class AppTheme {
  AppTheme._();

  // Core AI and Brand Colors
  static const Color primaryAIBlue = Color(0xFF667eea);
  static const Color secondaryPurple = Color(0xFF764ba2);
  static const Color accentPink = Color(0xFFf093fb);

  // Background Colors - Optimized for OLED displays
  static const Color backgroundDeep = Color(0xFF0f0f23);
  static const Color backgroundElevated = Color(0xFF1a1a2e);

  // Text Colors - WCAG AA compliant
  static const Color textPrimary = Color(0xFFffffff);
  static const Color textSecondary = Color(0xFFa0a0b3);

  // Functional Colors
  static const Color borderSubtle = Color(0xFF2a2a3e);
  static const Color successGreen = Color(0xFF4ade80);
  static const Color warningAmber = Color(0xFFfbbf24);
  static const Color errorRed = Color(0xFFef4444);

  // Light theme fallback colors (minimal usage expected)
  static const Color backgroundLight = Color(0xFFffffff);
  static const Color surfaceLight = Color(0xFFf8fafc);
  static const Color textLight = Color(0xFF1e293b);

  // Shadow and overlay colors
  static const Color shadowDark =
      Color(0x33000000); // 20% opacity for subtle depth
  static const Color overlayDark = Color(0x80000000); // 50% opacity for modals

  /// Dark theme (primary theme for the application)
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryAIBlue,
          onPrimary: textPrimary,
          primaryContainer: primaryAIBlue.withValues(alpha: 0.2),
          onPrimaryContainer: textPrimary,
          secondary: secondaryPurple,
          onSecondary: textPrimary,
          secondaryContainer: secondaryPurple.withValues(alpha: 0.2),
          onSecondaryContainer: textPrimary,
          tertiary: accentPink,
          onTertiary: textPrimary,
          tertiaryContainer: accentPink.withValues(alpha: 0.2),
          onTertiaryContainer: textPrimary,
          error: errorRed,
          onError: textPrimary,
          surface: backgroundElevated,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          outline: borderSubtle,
          outlineVariant: borderSubtle.withValues(alpha: 0.5),
          shadow: shadowDark,
          scrim: overlayDark,
          inverseSurface: backgroundLight,
          onInverseSurface: textLight,
          inversePrimary: primaryAIBlue),
      scaffoldBackgroundColor: backgroundDeep,
      cardColor: backgroundElevated,
      dividerColor: borderSubtle,

      // AppBar Theme - Minimal and context-aware
      appBarTheme: AppBarTheme(
          backgroundColor: backgroundDeep,
          foregroundColor: textPrimary,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
              letterSpacing: -0.02),
          toolbarTextStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary)),

      // Card Theme - Adaptive elevation for content hierarchy
      cardTheme: CardTheme(
          color: backgroundElevated,
          elevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom Navigation - Gesture-first navigation support
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundElevated,
          selectedItemColor: primaryAIBlue,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Floating Action Button - Contextual appearance
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryAIBlue,
          foregroundColor: textPrimary,
          elevation: 6,
          focusElevation: 8,
          hoverElevation: 8,
          highlightElevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button Themes - Consistent with AI-first interactions
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: textPrimary,
              backgroundColor: primaryAIBlue,
              disabledForegroundColor: textSecondary,
              disabledBackgroundColor: borderSubtle,
              elevation: 2,
              shadowColor: shadowDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.02))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryAIBlue,
              disabledForegroundColor: textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: primaryAIBlue, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.02))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryAIBlue,
              disabledForegroundColor: textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.02))),

      // Typography - Platform-native fonts with excellent readability
      textTheme: _buildDarkTextTheme(),

      // Input Decoration - Minimal borders with clear focus states
      inputDecorationTheme: InputDecorationTheme(
          fillColor: backgroundElevated,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: borderSubtle, width: 1)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: borderSubtle, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryAIBlue, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorRed, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorRed, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w400),
          helperStyle: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorRed, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch Theme - AI feature toggles
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryAIBlue;
        }
        return textSecondary;
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryAIBlue.withValues(alpha: 0.3);
        }
        return borderSubtle;
      }), overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return primaryAIBlue.withValues(alpha: 0.1);
        }
        return null;
      })),

      // Checkbox Theme - Selection states
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryAIBlue;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(textPrimary),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryAIBlue.withValues(alpha: 0.1);
            }
            return null;
          }),
          side: const BorderSide(color: borderSubtle, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Radio Theme - Single selection
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryAIBlue;
        }
        return borderSubtle;
      }), overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return primaryAIBlue.withValues(alpha: 0.1);
        }
        return null;
      })),

      // Progress Indicators - AI processing states
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryAIBlue, linearTrackColor: borderSubtle, circularTrackColor: borderSubtle),

      // Slider Theme - Engagement controls
      sliderTheme: SliderThemeData(activeTrackColor: primaryAIBlue, inactiveTrackColor: borderSubtle, thumbColor: primaryAIBlue, overlayColor: primaryAIBlue.withValues(alpha: 0.2), valueIndicatorColor: primaryAIBlue, valueIndicatorTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w500)),

      // Tab Bar Theme - Platform switching
      tabBarTheme: TabBarTheme(
          labelColor: primaryAIBlue,
          unselectedLabelColor: textSecondary,
          indicatorColor: primaryAIBlue,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.02),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.02),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryAIBlue.withValues(alpha: 0.1);
            }
            return null;
          })),

      // Tooltip Theme - Contextual help
      tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(color: backgroundElevated, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderSubtle, width: 1), boxShadow: [
            BoxShadow(
                color: shadowDark, blurRadius: 8, offset: const Offset(0, 4)),
          ]),
          textStyle: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w400),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

      // SnackBar Theme - Feedback and notifications
      snackBarTheme: SnackBarThemeData(backgroundColor: backgroundElevated, contentTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: primaryAIBlue, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 6),

      // Dialog Theme - Modal interactions
      dialogTheme: DialogTheme(backgroundColor: backgroundElevated, surfaceTintColor: Colors.transparent, elevation: 8, shadowColor: shadowDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), titleTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.02), contentTextStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5)),

      // Bottom Sheet Theme - Contextual actions
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: backgroundElevated, surfaceTintColor: Colors.transparent, elevation: 8, shadowColor: shadowDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), clipBehavior: Clip.antiAlias),

      // List Tile Theme - Content presentation
      listTileTheme: ListTileThemeData(tileColor: Colors.transparent, selectedTileColor: primaryAIBlue.withValues(alpha: 0.1), iconColor: textSecondary, selectedColor: primaryAIBlue, textColor: textPrimary, titleTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: -0.01), subtitleTextStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w400, height: 1.4), leadingAndTrailingTextStyle: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w400), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),

      // Chip Theme - Tags and filters
      chipTheme: ChipThemeData(backgroundColor: borderSubtle, selectedColor: primaryAIBlue.withValues(alpha: 0.2), disabledColor: borderSubtle.withValues(alpha: 0.5), deleteIconColor: textSecondary, labelStyle: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w500), secondaryLabelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0, pressElevation: 2));

  /// Light theme (fallback for system preferences)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryAIBlue,
        onPrimary: backgroundLight,
        primaryContainer: primaryAIBlue.withValues(alpha: 0.1),
        onPrimaryContainer: primaryAIBlue,
        secondary: secondaryPurple,
        onSecondary: backgroundLight,
        secondaryContainer: secondaryPurple.withValues(alpha: 0.1),
        onSecondaryContainer: secondaryPurple,
        tertiary: accentPink,
        onTertiary: backgroundLight,
        tertiaryContainer: accentPink.withValues(alpha: 0.1),
        onTertiaryContainer: accentPink,
        error: errorRed,
        onError: backgroundLight,
        surface: surfaceLight,
        onSurface: textLight,
        onSurfaceVariant: textLight.withValues(alpha: 0.7),
        outline: textLight.withValues(alpha: 0.2),
        outlineVariant: textLight.withValues(alpha: 0.1),
        shadow: const Color(0x1A000000),
        scrim: const Color(0x80000000),
        inverseSurface: backgroundDeep,
        onInverseSurface: textPrimary,
        inversePrimary: primaryAIBlue),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: textLight.withValues(alpha: 0.12),
    textTheme: _buildLightTextTheme(), dialogTheme: DialogThemeData(backgroundColor: backgroundLight),
    // Note: Light theme uses simplified configuration
    // as the app is primarily designed for dark mode usage
  );

  /// Helper method to build dark theme text styles
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
        // Display styles - Large headings and hero text
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles - Section headers
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.02,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.02,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.01,
            height: 1.33),

        // Title styles - Card headers and important labels
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: -0.01,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.01,
            height: 1.5),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.01,
            height: 1.43),

        // Body styles - Main content text
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.01,
            height: 1.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.02,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.04,
            height: 1.33),

        // Label styles - Buttons, tabs, and form labels
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.01,
            height: 1.43),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.05,
            height: 1.33),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.05,
            height: 1.45));
  }

  /// Helper method to build light theme text styles
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: textLight,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: textLight,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textLight,
            letterSpacing: 0,
            height: 1.22),
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textLight,
            letterSpacing: -0.02,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textLight,
            letterSpacing: -0.02,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textLight,
            letterSpacing: -0.01,
            height: 1.33),
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textLight,
            letterSpacing: -0.01,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textLight,
            letterSpacing: 0.01,
            height: 1.5),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textLight,
            letterSpacing: 0.01,
            height: 1.43),
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textLight,
            letterSpacing: 0.01,
            height: 1.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textLight,
            letterSpacing: 0.02,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textLight.withValues(alpha: 0.7),
            letterSpacing: 0.04,
            height: 1.33),
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textLight,
            letterSpacing: 0.01,
            height: 1.43),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textLight,
            letterSpacing: 0.05,
            height: 1.33),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textLight.withValues(alpha: 0.7),
            letterSpacing: 0.05,
            height: 1.45));
  }

  /// Custom gradient for AI processing states
  static const LinearGradient aiGradient = LinearGradient(
      colors: [primaryAIBlue, secondaryPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  /// Box shadow for elevated cards with subtle depth
  static List<BoxShadow> get cardShadow => [
        BoxShadow(color: shadowDark, blurRadius: 4, offset: const Offset(0, 2)),
      ];

  /// Box shadow for floating elements
  static List<BoxShadow> get floatingShadow => [
        BoxShadow(color: shadowDark, blurRadius: 8, offset: const Offset(0, 4)),
      ];
}
